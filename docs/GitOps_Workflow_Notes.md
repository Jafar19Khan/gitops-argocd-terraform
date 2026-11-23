# GitOps Workflow Notes

## Git as the desired-state source

Kubernetes application manifests are maintained in GitHub. These files describe the intended state of the application. Argo CD monitors the configured repository revision and manifest directory, compares the Git configuration with live Kubernetes resources, and synchronizes differences according to the Application policy.

## Application source

`argocd/application.yaml` points to:

- Repository: `https://github.com/Jafar19Khan/gitops-argocd-terraform.git`
- Revision: `HEAD`
- Manifest path: `k8s-manifests`
- Destination namespace: `demo-app`

## Automated synchronization

Automated sync is enabled. When a manifest change is committed and pushed to the tracked branch, Argo CD can detect the new desired state and apply it to Kubernetes.

## Self-healing

`selfHeal: true` enables Argo CD to reconcile supported live changes that diverge from the Git-defined state.

## Pruning

`prune: true` allows Argo CD to delete managed resources that have been removed from the Git manifests when the application is synchronized.

## Git-based rollback

Git history provides an auditable record of configuration changes. A previous change can be reversed with a new commit using `git revert <commit>` and pushing that commit. Argo CD then reconciles the reverted configuration. This preserves shared branch history instead of rewriting it.
