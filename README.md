## Prerequisites

- Kubernetes cluster with `kubectl` access  
- Prometheus & Grafana installed, scraping `payment` metrics  
- `jq` for JSON parsing  
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





