Instructions

Objective
Build a minimal PHP infrastructure using Nginx + PHP-FPM, managed by Terraform (Docker provider) and configured with Ansible.
All steps run locally — no paid cloud services.

Requirements

Terraform ≥ 1.13.4

Ansible ≥ 2.17

Docker Engine ≥ 25

Validation
After terraform apply, run:
curl http://localhost:8080/healthz

Expected:
{"status":"ok","service":"nginx","env":"dev"}

Deliverables

Directories: terraform/, ansible/, .github/workflows/

Files: README.md, INSTRUCTIONS.md, Decisions.md

Screenshots or links to successful GitHub Actions runs