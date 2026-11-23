# GitOps Workflow Notes

## Git as the Desired-State Source

In this project, Kubernetes application manifests are maintained in GitHub. The repository contains the desired configuration for the application.

ArgoCD monitors the configured repository revision and manifest directory. It compares the configuration in Git with the live Kubernetes resources and synchronizes differences according to the Application sync policy.

## ArgoCD Application

The project defines the ArgoCD Application in `argocd/application.yaml`.

Its source configuration points to:

- Repository: `https://github.com/Jafar19Khan/gitops-argocd-terraform.git`
- Revision: `HEAD`
- Manifest directory: `k8s-manifests`

The destination is the local Kubernetes cluster, with the application deployed in the `demo-app` namespace.

## Automated Synchronization

Automated synchronization is enabled in the ArgoCD Application configuration.

When application manifests are updated and committed to the tracked Git repository, ArgoCD can detect the updated desired state and synchronize the Kubernetes resources.

## Self-Healing

The Application has `selfHeal: true` enabled.

If a managed resource is changed directly in the cluster and differs from the configuration in Git, ArgoCD can reconcile it with the repository-defined desired state.

## Pruning

The Application has `prune: true` enabled.

When a resource tracked by the Application is removed from the Git manifests, ArgoCD can remove the corresponding managed resource during synchronization.

## Git-Based Rollback

Git history provides a record of configuration changes. A previous change can be reversed by creating a new commit with `git revert <commit>` and pushing that commit to the tracked branch.

ArgoCD can then synchronize the reverted configuration from Git. This keeps the change history available instead of rewriting shared repository history.
