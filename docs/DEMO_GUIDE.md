# Demo and Verification Guide

This guide is intended for an internship reviewer or a visitor exploring the repository.

## 1. Explain the objective

The goal is to make Git the declared source of truth for a Kubernetes application. Instead of manually applying every application change, Argo CD observes the repository and reconciles the cluster to match it.

## 2. Explain the architecture

1. Terraform creates the AWS network and EC2 host.
2. EC2 user data installs K3s and Argo CD.
3. The Argo CD Application points to `k8s-manifests/` in this GitHub repository.
4. Argo CD deploys the namespace, NGINX Deployment and NodePort Service.
5. A Git commit updates the desired state; Argo CD detects and applies the change.

## 3. Commands to verify the environment

Run these commands on the EC2 host:

```bash
sudo kubectl get nodes -o wide
sudo kubectl get pods -n argocd
sudo kubectl get application gitops-demo -n argocd
sudo kubectl get deployment,service,pods -n demo-app
```

Expected high-level results when the environment is ready:
- K3s node reports `Ready`.
- Argo CD components are running.
- Application reports `Synced` and `Healthy`.
- `gitops-demo` Deployment reports the desired number of ready replicas.
- Service exposes HTTP on NodePort `30080`.

Exact pod names and startup times can vary by version and environment.

## 4. Show a Git-driven change

1. Change `spec.replicas` in `k8s-manifests/deployment.yaml`.
2. Commit and push to the tracked branch.
3. Refresh the Argo CD application view and show the synchronization status.
4. Confirm the Deployment replica count with `kubectl get deployment gitops-demo -n demo-app`.
5. Explain that the Git commit is the change record and Argo CD reconciles the cluster.

## 5. Walk through the supplied evidence

- `01-terraform-apply.png`: cloud infrastructure provisioning.
- `02-k3s-argocd-pods.png`: Kubernetes and Argo CD workloads.
- `03-argocd-synced-healthy.png`: GitOps application health and sync.
- `04-live-app-browser.png`: browser access to NGINX.
- `05-terraform-destroy.png`: resource cleanup.

The screenshots are supporting evidence; they do not replace a live demonstration if a reviewer requests one.

## 6. Cleanup

From the Terraform directory:

```bash
terraform destroy
```

Confirm the plan and completion. Check the AWS console for any manually created resources not managed by this Terraform state. Never assume all account resources were removed by this project's destroy operation.
