#!/usr/bin/env bash
set -euo pipefail

# Configuration
NAMESPACE="default"
APP_LABEL="app=payment"
LATENCY="200ms"
INTERFACE="eth0"
SLEEP_DURATION=60

# Identify a running payment pod
POD=$(kubectl get pods -n "$NAMESPACE" -l "$APP_LABEL" \
      --field-selector=status.phase=Running \
      -o jsonpath='{.items[0].metadata.name}')
echo "Injecting $LATENCY latency into pod $POD on $INTERFACE…"

# Inject latency
kubectl exec -n "$NAMESPACE" "$POD" -- \
  tc qdisc add dev "$INTERFACE" root netem delay "$LATENCY"

echo "Latency injected. Waiting $SLEEP_DURATION seconds to observe effects…"
sleep "$SLEEP_DURATION"

# Remove latency
echo "Removing latency injection from pod $POD…"
kubectl exec -n "$NAMESPACE" "$POD" -- \
  tc qdisc del dev "$INTERFACE" root netem

echo "Latency removed. Experiment complete."
