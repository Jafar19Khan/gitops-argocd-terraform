# Security and Operational Notes

This repository is an educational cloud lab. Review these points before deploying it.

- Restrict SSH and the Argo CD administrative interface to your own trusted public IP using `allowed_ssh_cidr` (CIDR `/32` for one IPv4 address).
- The NGINX demo endpoint is intentionally public on NodePort `30080` in the current configuration. Do not expose sensitive workloads this way.
- Do not commit AWS access keys, private keys, kubeconfig files, Argo CD passwords, access tokens, `terraform.tfstate`, or populated `.tfvars` files.
- Treat Terraform state and plan files as sensitive because they may contain infrastructure details or secrets.
- Change the initial Argo CD admin password after first login and store credentials in a password manager. Do not publish screenshots containing credentials.
- Keep the EC2 host and Kubernetes/Argo CD versions patched.
- The bootstrap script installs Argo CD from the upstream `stable` manifest URL. For a repeatable controlled deployment, pin and review a specific Argo CD release before applying.
- A single EC2 node is a single point of failure and is not a production high-availability design.
- Review AWS costs before deployment and run `terraform destroy` when the lab is no longer needed.
