<?php
echo json_encode([
    "status"  => "ok",
    "service" => "nginx",
    "env"     => getenv("APP_ENV") ?: "dev"
]);