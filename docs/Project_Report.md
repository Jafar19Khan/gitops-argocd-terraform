# Project Report

## 1. Introduction

This project, GitOps Continuous Delivery Pipeline with ArgoCD and Terraform, demonstrates how Kubernetes application deployment can be managed through a Git repository. The infrastructure is hosted on AWS, and a single-node K3s cluster runs on an EC2 instance.

## 2. Abstract

The project uses Terraform to provision AWS networking and compute resources. The EC2 instance is configured to install K3s and ArgoCD through its startup script. Kubernetes application manifests are maintained in GitHub, and ArgoCD monitors the configured repository path to synchronize the desired application state with the cluster.

The demonstration application is NGINX, deployed in the `demo-app` namespace and exposed through a Kubernetes NodePort service.

## 3. Tools Used

- **Amazon Web Services (AWS):** Cloud infrastructure
- **Terraform:** Infrastructure as Code
- **Ubuntu 22.04 LTS:** Operating system
- **K3s:** Lightweight Kubernetes cluster
- **Kubernetes:** Container orchestration
- **ArgoCD:** GitOps continuous delivery controller
- **GitHub:** Repository for Kubernetes manifests
- **NGINX:** Sample web application

## 4. Steps Involved in Building the Project

1. Created AWS infrastructure using Terraform, including a VPC, public subnet, Internet Gateway, route table, security group and EC2 instance.
2. Configured the EC2 startup script to install K3s and deploy ArgoCD.
3. Created Kubernetes manifests for the application namespace, NGINX Deployment and NodePort Service.
4. Configured an ArgoCD Application to monitor the GitHub repository and the `k8s-manifests` directory.
5. Enabled automated synchronization, pruning and self-healing in the ArgoCD Application configuration.
6. Updated the desired replica count in the Git repository from 2 to 4. As documented in the internship execution report, ArgoCD detected the Git change and reconciled the application to four replicas.
7. Captured screenshots showing infrastructure provisioning, Kubernetes and ArgoCD status, application access and infrastructure teardown.

## 5. Conclusion

The project demonstrates how Terraform can automate cloud infrastructure provisioning and how ArgoCD can manage Kubernetes application deployments using Git as the desired-state source. It provides practical experience with AWS, Terraform, K3s, Kubernetes and GitOps concepts such as automated synchronization, self-healing and version-controlled configuration.
