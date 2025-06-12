# Chaos Experiment: Network Latency Injection

**Objective:**  
Validate that our payment service SLOs (e.g., p99 latency ≤ 500 ms, Apdex ≥ 0.85) are accurately monitored and that alerts fire when network delays degrade user experience.

## Prerequisites

- Kubernetes cluster accessible via `kubectl`  
- `payment` Deployment running with probes  
- Prometheus rule `HighPaymentLatency` loaded  
- Grafana dashboard displaying p99 latency and Apdex scores

## Steps

1. **Identify the Pod**  
   ```bash
   POD=$(kubectl get pods -n default -l app=payment \
         --field-selector=status.phase=Running \
         -o jsonpath='{.items[0].metadata.name}')

2. **Inject 200 ms Latency**
    kubectl exec -n default "$POD" -- \
        tc qdisc add dev eth0 root netem delay 200ms
    echo "Injected 200ms latency into $POD"

3. **Observe Application Response**
    kubectl exec -n default "$POD" -- \
        curl -w "time_total: %{time_total}s\n" -o /dev/null -s http://localhost:8080/health

4. **Monitor Metrics & Alerts**
    - Prometheus:
        job:http_request_latency_p99

    - Alert(Grafana):
        curl -s 'http://localhost:9090/api/v1/alerts' | jq '.data.alerts[] | select(.labels.alertname == "HighPaymentLatency")'

5. **Remove Latency**
    kubectl exec -n default "$POD" -- \
        tc qdisc del dev eth0 root netem
    echo "Removed latency from $POD"

6. **Validate Recovery**
    - Confirm metrics return to baseline in Prometheus and Grafana
    - Ensure alert resolves to inactive after 1 minute
