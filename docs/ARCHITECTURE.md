# Architecture and Design

## Overview

The lab separates infrastructure provisioning from application delivery:

- Terraform provisions the AWS network and EC2 compute host.
- EC2 user data installs K3s and the Argo CD control plane.
- The Argo CD `Application` resource points to this repository's `k8s-manifests/` directory.
- Argo CD reconciles those manifests into the `demo-app` namespace.
- Kubernetes maintains the desired NGINX replica count and exposes it through NodePort `30080`.

## Component responsibilities

| Component | Responsibility |
|---|---|
| Terraform | Creates VPC, subnet, Internet Gateway, route table, security group and EC2 instance |
| EC2 user data | Installs and starts K3s, installs Argo CD and exposes its server through NodePort `30443` |
| GitHub | Stores version-controlled desired application state |
| Argo CD Application | Connects Git source to the in-cluster Kubernetes destination |
| Kubernetes Deployment | Maintains the requested NGINX replicas and performs health probes |
| Kubernetes Service | Routes HTTP traffic to matching NGINX pods |

## Design boundaries

This is a single-node learning environment. It does not provide multi-node resilience, managed control-plane availability, a production ingress controller, TLS termination for the sample app, automated image builds, or a dedicated secrets-management platform. The Argo CD Application resource is registered separately after bootstrap with `kubectl apply -f argocd/application.yaml`.
