# Project Report

## 1. Introduction
This project demonstrates a GitOps workflow for deploying and managing a Kubernetes application using ArgoCD. Infrastructure is provisioned on AWS with Terraform, while K3s provides a lightweight Kubernetes cluster on a single EC2 instance.

## 2. Abstract
The solution provisions an AWS EC2 instance and configures K3s and ArgoCD through automated bootstrap. Application Kubernetes manifests are stored in GitHub, which acts as the desired-state source. ArgoCD continuously observes the repository and reconciles the cluster to the declared configuration, enabling repeatable deployments and drift correction.

## 3. Tools Used
- **AWS EC2:** Hosts the single-node Kubernetes environment.
- **Terraform:** Infrastructure-as-Code for repeatable provisioning and teardown.
- **K3s:** Lightweight Kubernetes distribution.
- **Kubernetes:** Runs and manages the application workload.
- **ArgoCD:** GitOps controller that monitors Git and synchronizes manifests.
- **GitHub:** Version-controlled source of desired application state.
- **Docker/NGINX:** Container image and web server used for the demonstration application.

## 4. Steps Involved in Building the Project
1. Configure Terraform variables for AWS region, EC2 key pair, and restricted SSH CIDR.
2. Run Terraform initialization, validation, plan, and apply to provision EC2 and networking rules.
3. EC2 user-data installs K3s, waits for the Kubernetes node to become Ready, and installs ArgoCD.
4. Configure ArgoCD server access and verify cluster and ArgoCD pod readiness.
5. Push the Kubernetes namespace, deployment, and service manifests to the GitHub repository.
6. Apply the ArgoCD Application manifest to connect ArgoCD to the repository path.
7. Verify the application reports Synced and Healthy and access the sample app through its NodePort.
8. Change the desired replica count or image in Git, commit and push, then observe ArgoCD auto-sync the change.
9. Capture evidence and run `terraform destroy` to remove provisioned infrastructure and reduce ongoing costs.

## 5. Conclusion
The project demonstrates infrastructure automation and a pull-based GitOps deployment model. Terraform makes the cloud environment reproducible, while ArgoCD continuously reconciles Kubernetes workloads against Git. The workflow provides a practical foundation for version-controlled deployments, self-healing, and controlled rollback through Git history.
