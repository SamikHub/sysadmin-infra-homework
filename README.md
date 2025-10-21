Sysadmin Infra Homework

This repository implements a minimal PHP application infrastructure managed with Terraform, configured with Ansible, and tested via GitHub Actions.

Project Structure

sysadmin-infra-homework/
├── terraform/    # Infrastructure provisioning (Docker provider)
├── ansible/     # Configuration management (roles/web)
├── .github/workflows/ # CI/CD pipelines
├── README.md
├── INSTRUCTIONS.md
└── Decisions.md

Terraform Setup

Step 1 — Initialize and validate
cd terraform
terraform init
terraform fmt -check
terraform validate

Step 2 — Deploy
terraform apply -auto-approve

Creates:

nginx (port 8080)

php-fpm

Shared /var/www/html volume

Ansible Setup

Step 1 — Run the role locally
cd ansible
ansible-playbook -i "localhost," -c local site.yml

The role:

Installs Nginx and PHP-FPM

Configures /etc/nginx/sites-available/default

Adds index.php

Configures logrotate

Ensures both services are running and idempotent

Healthcheck Validation

curl http://localhost:8080/healthz

Expected response:
{"status":"ok","service":"nginx","env":"dev"}

CI/CD (GitHub Actions)

Two workflows:

terraform.yml → terraform fmt -check + init + validate + plan -out=tfplan

ansible.yml → ansible-lint (+ optional Molecule tests)

All workflows pass.
GitHub Actions: https://github.com/SamikHub/sysadmin-infra-homework/actions

Cleanup

terraform destroy -auto-approve

Minor sync for PR
