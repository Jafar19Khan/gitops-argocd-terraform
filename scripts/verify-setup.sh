#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is unavailable. Run this script on the EC2 host or configure kubectl access."
  exit 1
fi

if [[ -z "${KUBECONFIG:-}" && -r /etc/rancher/k3s/k3s.yaml ]]; then
  export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
fi

echo "Kubernetes nodes:"
kubectl get nodes -o wide
echo
echo "Argo CD pods:"
kubectl get pods -n argocd
echo
echo "Argo CD server readiness:"
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s
echo
echo "GitOps application:"
kubectl get application gitops-demo -n argocd
echo
echo "Demo workload:"
kubectl get deployment,service,pods -n demo-app
