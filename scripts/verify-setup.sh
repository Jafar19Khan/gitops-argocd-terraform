#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is unavailable. Run this script on the EC2 host or with kubectl configured."
  exit 1
fi

if [[ -z "${KUBECONFIG:-}" && -r /etc/rancher/k3s/k3s.yaml ]]; then
  export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
fi

echo "K3s nodes:"
kubectl get nodes -o wide
echo
echo "ArgoCD pods:"
kubectl get pods -n argocd
echo
echo "ArgoCD server deployment readiness:"
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s
echo
echo "Initial admin password (if initial secret still exists):"
if kubectl get secret argocd-initial-admin-secret -n argocd >/dev/null 2>&1; then
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
  echo
else
  echo "Initial secret not found; password may have been changed or secret deleted."
fi
