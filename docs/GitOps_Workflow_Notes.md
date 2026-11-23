# GitOps Workflow Notes

## Pull-based GitOps vs. Push-based CI/CD
In a traditional push-based CI/CD deployment, a pipeline runner or deployment job pushes changes directly into a target environment, often using credentials with cluster access. In pull-based GitOps, the cluster-side controller (ArgoCD) observes a Git repository and pulls the declared configuration into the cluster. Git is the desired-state source, and deployment changes are made by committing manifests rather than directly modifying the cluster.

## ArgoCD reconciliation and drift
ArgoCD compares the live Kubernetes resources with the desired configuration in Git. A difference is drift. This project enables automated sync, `selfHeal: true`, and `prune: true`:
- **Automated sync:** ArgoCD applies committed manifest changes without a manual sync action.
- **Self-heal:** If live state is changed outside Git, ArgoCD can reconcile it back to the repository's desired state.
- **Prune:** Resources removed from the tracked manifests can be deleted from the cluster during synchronization.

## Rollbacks with Git
The Git history records changes to manifests. To roll back a problematic change, identify the commit that introduced it and use `git revert <commit>` to create a new commit reversing that change. Push the revert to the tracked branch; ArgoCD detects the updated desired state and synchronizes the rollback. Prefer revert over rewriting shared history so the change remains auditable.
