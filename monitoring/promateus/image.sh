# Add and update the community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install just the CRDs
helm install prometheus-crds prometheus-community/prometheus-operator-crds \
  --namespace monitoring \
  --create-namespace

hr.12w.ir/lqi/prometheus/node-exporter:v1.11.1-distroless
hr.12w.ir/lqi/kiwigrid/k8s-sidecar:2.7.3
hr.12w.ir/docker-hub/grafana/grafana:13.0.1-security-01
hr.12w.ir/lk8/kube-state-metrics/kube-state-metrics:v2.19.0
hr.12w.ir/lqi/prometheus-operator/prometheus-operator:v0.90.1
hr.12w.ir/lqi/prometheus-operator/prometheus-config-reloader:v0.90.1
hr.12w.ir/lqi/thanos/thanos:v0.41.0
hr.12w.ir/lqi/prometheus/alertmanager:v0.32.1
hr.12w.ir/lqi/prometheus/prometheus:v3.11.3-distroless
hr.12w.ir/lghcr/jkroepke/kube-webhook-certgen:1.8.3
