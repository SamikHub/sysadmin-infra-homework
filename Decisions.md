Design Decisions

Terraform + Docker Provider
 Lightweight local setup without external clouds; using kreuzwerker/docker v3.6.2 (latest stable Oct 2025).

Container Separation
 Nginx and PHP-FPM run in separate containers to simulate production isolation; linked via shared network and volume.

Idempotency
 Verified by repeated terraform apply and ansible-playbook runs — no changes after first execution.

CI/CD Integration
 GitHub Actions enforce terraform fmt and ansible-lint for consistent, reproducible builds.

Health Endpoint
 Simple JSON /healthz output for monitoring: {"status":"ok","service":"nginx","env":"dev"}

Extensibility
 Role structure allows future expansion (database container, TLS, etc.).