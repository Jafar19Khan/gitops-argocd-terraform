# GitOps Workflow using ArgoCD on Kubernetes

A GitOps project that uses Terraform to provision AWS infrastructure and ArgoCD to manage a Kubernetes application from GitHub.

## Project Overview

The project runs a single-node K3s Kubernetes cluster on an AWS EC2 instance. ArgoCD monitors the application's Kubernetes manifests stored in this repository and reconciles the cluster with the desired configuration.

## Technology Stack

- **AWS:** VPC, public subnet, Internet Gateway, security group and EC2
- **Terraform:** Infrastructure provisioning
- **Ubuntu 22.04 LTS:** EC2 operating system
- **K3s:** Lightweight Kubernetes distribution
- **ArgoCD:** GitOps continuous delivery
- **Kubernetes:** Application deployment and service management
- **GitHub:** Source control and desired application state
- **NGINX:** Demo application

## Architecture

1. Terraform provisions the AWS network and EC2 infrastructure.
2. EC2 user data installs K3s and ArgoCD.
3. The ArgoCD Application points to the `k8s-manifests/` directory in this repository.
4. ArgoCD monitors GitHub and synchronizes Kubernetes resources.
5. The NGINX application runs in the `demo-app` namespace and is exposed through NodePort `30080`.

## Repository Structure

```text
gitops-argocd-terraform/
├── argocd/
│   └── application.yaml
├── docs/
│   ├── GitOps_Workflow_Notes.md
│   └── Project_Report.md
├── k8s-manifests/
│   ├── deployment.yaml
│   ├── namespace.yaml
│   └── service.yaml
├── screenshots/
├── scripts/
│   └── verify-setup.sh
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── user_data.sh
│   └── variables.tf
└── README.md
```

## Kubernetes Configuration

- Namespace: `demo-app`
- Deployment: `gitops-demo`
- Container image: `nginx:1.25-alpine`
- Desired replicas: `4`
- Service type: `NodePort`
- Application NodePort: `30080`

The Deployment also defines CPU and memory requests and limits, along with readiness and liveness probes.

## ArgoCD Configuration

The ArgoCD Application is defined in `argocd/application.yaml`.

- Repository: `Jafar19Khan/gitops-argocd-terraform`
- Branch/revision: `HEAD`
- Manifest path: `k8s-manifests`
- Automated synchronization: Enabled
- Pruning: Enabled
- Self-healing: Enabled

GitHub acts as the source of truth for the application's desired Kubernetes configuration.

## AWS Network Access

The current Terraform security group defines these inbound rules:

| Port | Purpose |
|---|---|
| 22 | SSH |
| 30080 | NGINX application |
| 30443 | ArgoCD HTTPS interface |

The current Terraform configuration allows SSH from `0.0.0.0/0`. Restrict this access before using the infrastructure beyond a demonstration environment. Port `80` is not currently defined as an inbound security-group rule.

## Screenshots

The `screenshots/` directory contains evidence of infrastructure provisioning, Kubernetes and ArgoCD status, application access, and infrastructure teardown.

See [Screenshots README](screenshots/README.md).

## Project Documentation

- [Project Report](docs/Project_Report.md)
- [GitOps Workflow Notes](docs/GitOps_Workflow_Notes.md)

## Key Learning Outcomes

- Infrastructure provisioning with Terraform
- AWS networking and EC2 configuration
- K3s and Kubernetes application management
- Git-based desired-state management
- ArgoCD automated synchronization
- Self-healing and pruning in GitOps
- Infrastructure lifecycle and cleanup

## Resume Highlight

Implemented a GitOps workflow using ArgoCD and Kubernetes, with AWS infrastructure provisioned through Terraform and application manifests managed in GitHub.
