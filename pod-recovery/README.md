# Chaos Resilience Toolkit for Payment Service

A collection of chaos-engineering experiments, Kubernetes manifests, monitoring configurations, and runbooks designed to validate and improve the resilience of the `payment` service. These tests simulate common failure modes—pod termination and network latency injection—to ensure 24×7 self-healing, accurate alerting, and adherence to your service-level objectives (SLOs).

## Prerequisites

- A running Kubernetes cluster with `kubectl` configured  
- `payment` Deployment applied (see `charts/payment-deployment.yaml`)  
- Prometheus (scraping `kube-state-metrics` & `payment` metrics)  
- Grafana (import `monitoring/grafana-dashboard.json`)  
- `jq` for JSON parsing (`curl | jq …`)  
- Bash shell on Linux/Mac (or WSL on Windows)

## Quick Start

1. **Deploy the payment service**  
   ```bash
   kubectl apply -f charts/payment-deployment.yaml

2. **Validate monitoring**

   -Ensure Prometheus is scraping kube-state-metrics and your payment job.

   -Load monitoring/prom_rules.yaml into Prometheus.

   -Import monitoring/grafana-dashboard.json into Grafana.

3. **Run Chaos Tests**
      chmod +x scripts/run_all_tests.sh
      ./scripts/run_all_tests.sh

4. **Inspect Logs**
      ls logs/chaos_test_*.log
      tail -n 100 logs/chaos_test_*.log

5. **Review Runbooks**
   - Pod termination details: runbooks/pod_termination.md
   - Network Latency details: runbooks/network_latency.md
