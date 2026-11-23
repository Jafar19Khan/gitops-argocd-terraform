# GitOps Continuous Delivery with Argo CD and Terraform

**Candidate:** Jafar Ali Khan  
**Internship track:** Project 10 — GitOps Workflow using ArgoCD on Kubernetes  
**Repository:** https://github.com/Jafar19Khan/gitops-argocd-terraform  
**Cloud region:** AWS Asia Pacific (Mumbai), `ap-south-1`

## 1. Introduction

This project demonstrates a GitOps-based deployment workflow for a Kubernetes application. Terraform provisions the AWS infrastructure, while Argo CD continuously monitors Kubernetes manifests stored in GitHub and reconciles the live cluster with the desired configuration.

## 2. Abstract

A dedicated AWS VPC and EC2 instance host a single-node K3s Kubernetes cluster. The EC2 bootstrap script installs K3s and Argo CD. An Argo CD Application is configured to watch the repository's `k8s-manifests/` directory and deploy an NGINX workload into the `demo-app` namespace. Automated synchronization, self-healing and pruning demonstrate core GitOps capabilities.

## 3. Tools Used

- Amazon Web Services (VPC, subnet, Internet Gateway, route table and EC2)
- Terraform (Infrastructure as Code)
- Ubuntu 22.04 LTS and K3s
- Kubernetes (Deployment, Service and Namespace)
- Argo CD (GitOps reconciliation)
- Git and GitHub (version control and desired state)
- NGINX (sample web workload)

## 4. Steps Involved

1. Defined AWS network and compute resources using Terraform.
2. Used EC2 user data to install K3s and deploy Argo CD.
3. Created Kubernetes manifests for the application namespace, NGINX Deployment and NodePort Service.
4. Registered an Argo CD Application pointing to the GitHub repository and `k8s-manifests/` path.
5. Enabled automated synchronization, pruning and self-healing.
6. Committed an application replica-count change to Git and observed Argo CD reconcile the workload.
7. Verified cluster status, Argo CD health, browser access and infrastructure teardown using the supplied screenshots.

## 5. Conclusion

The project provided practical experience with Terraform-based AWS provisioning, Kubernetes workload management and GitOps delivery using Argo CD. It demonstrates how version-controlled manifests can act as the desired state for a cluster and how automated reconciliation reduces manual deployment steps. The implementation is a single-node educational lab rather than a production high-availability environment.
