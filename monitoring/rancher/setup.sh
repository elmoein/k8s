#!/bin/bash

echo "🚀 Downloading Rancher chart..."

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update
# helm show values rancher-stable/rancher > default-value.yaml

kubectl create namespace cattle-system --dry-run=client -o yaml | kubectl apply -f -

echo "📝 Generating final manifests with Helm Template..."

helm template rancher rancher-stable/rancher \
  --namespace cattle-system \
  --kube-version "1.35.0" \
  -f values.yaml > final.yaml

echo "⚙️ Applying manifests via Kubectl (Server-Side)..."

kubectl apply -n cattle-system  -f final.yaml --server-side

kubectl apply -f http-route.yaml --server-side

echo "✅ Deployment triggered successfully!"