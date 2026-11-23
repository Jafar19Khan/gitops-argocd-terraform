#!/usr/bin/env bash
set -Eeuo pipefail
exec > >(tee -a /var/log/user-data.log) 2>&1

echo "Bootstrap started: $(date -Is)"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl ca-certificates git

if ! command -v k3s >/dev/null 2>&1; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" sh -
fi
systemctl enable k3s
systemctl start k3s

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
until kubectl get nodes >/dev/null 2>&1; do sleep 5; done
kubectl wait --for=condition=Ready node --all --timeout=600s

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl rollout status deployment/argocd-server -n argocd --timeout=600s
kubectl rollout status deployment/argocd-repo-server -n argocd --timeout=600s
kubectl rollout status deployment/argocd-application-controller -n argocd --timeout=600s

kubectl patch service argocd-server -n argocd --type merge -p '{"spec":{"type":"NodePort","ports":[{"name":"https","port":443,"targetPort":8080,"protocol":"TCP","nodePort":30443}]}}'
echo "Bootstrap finished: $(date -Is)"
kubectl get nodes
kubectl get pods -n argocd
