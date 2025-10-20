locals {
  nginx_conf_rendered = templatefile("${path.module}/templates/nginx.conf.tftpl", {
    app_env = var.app_env
  })
}

# Network and volume
resource "docker_network" "app" {
  name = "${var.project_name}-net"
}

resource "docker_volume" "app" {
  name = "${var.project_name}-vol"
}

# Seed container copies index.php into volume
resource "docker_container" "seed" {
  name  = "${var.project_name}-seed"
  image = "php:8.4-fpm-alpine"

  networks_advanced {
    name = docker_network.app.name
  }

  mounts {
    target = "/var/www/html"
    source = docker_volume.app.name
    type   = "volume"
  }

  upload {
    file    = "/tmp/index.php"
    content = file("${path.module}/templates/index.php")
  }

  command = ["sh", "-c", "cp /tmp/index.php /var/www/html/index.php && sleep 2"]
  restart = "no"
}

# PHP-FPM container
resource "docker_container" "php_fpm" {
  name  = "${var.project_name}-php-fpm"
  image = "php:8.4-fpm-alpine"

  networks_advanced {
    name    = docker_network.app.name
    aliases = ["php-fpm"]
  }

  mounts {
    target = "/var/www/html"
    source = docker_volume.app.name
    type   = "volume"
  }

  env = ["APP_ENV=${var.app_env}"]

  restart    = "unless-stopped"
  depends_on = [docker_container.seed]
}

# Render nginx.conf and bind-mount it
resource "local_file" "nginx_conf" {
  filename = "${path.module}/templates/default.conf"
  content  = local.nginx_conf_rendered
}

# Nginx container
resource "docker_container" "nginx" {
  name  = "${var.project_name}-nginx"
  image = "nginx:1.26-alpine"

  networks_advanced {
    name = docker_network.app.name
  }

  mounts {
    target    = "/etc/nginx/conf.d/default.conf"
    source    = abspath(local_file.nginx_conf.filename)
    type      = "bind"
    read_only = true
  }

  mounts {
    target = "/var/www/html"
    source = docker_volume.app.name
    type   = "volume"
  }

  ports {
    internal = 80
    external = var.host_port
  }

  restart    = "unless-stopped"
  depends_on = [docker_container.php_fpm]
}