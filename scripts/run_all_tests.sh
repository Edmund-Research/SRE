#!/usr/bin/env bash
set -euo pipefail

# Configuration
NAMESPACE="default"
APP_LABEL="app=payment"
PROMETHEUS_URL="http://localhost:9090"
ALERT_NAME="PaymentPodRestarted"
LOG_DIR="$(dirname "$0")/../logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/chaos_test_$TIMESTAMP.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Helper to log with timestamp
log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $*" | tee -a "$LOG_FILE"
}

log "==== Starting Chaos Engineering Run: Pod Termination Test ===="

# 1. Identify and kill a payment pod
POD=$(kubectl get pods -n "$NAMESPACE" -l "$APP_LABEL" \
      --field-selector=status.phase=Running \
      -o jsonpath='{.items[0].metadata.name}')
log "Found running pod: $POD. Deleting it now…"
kubectl delete pod "$POD" -n "$NAMESPACE" --grace-period=0 --force | tee -a "$LOG_FILE"

# 2. Wait for the new pod to spin up
log "Waiting for new pod to be ready (timeout: 120s)…"
END=$((SECONDS+120))
while [ $SECONDS -lt $END ]; do
  NEW_POD=$(kubectl get pods -n "$NAMESPACE" -l "$APP_LABEL" \
            --field-selector=status.phase=Running \
            -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
  if [ -n "$NEW_POD" ] && [ "$NEW_POD" != "$POD" ]; then
    STATUS=$(kubectl get pod "$NEW_POD" -n "$NAMESPACE" -o jsonpath='{.status.containerStatuses[0].ready}')
    if [ "$STATUS" == "true" ]; then
      log "New pod $NEW_POD is Running and Ready."
      break
    fi
  fi
  sleep 5
done

if [ "$NEW_POD" == "$POD" ] || [ -z "${STATUS:-}" ] || [ "$STATUS" != "true" ]; then
  log "ERROR: Pod did not recover in time."
  exit 1
fi

# 3. Query Prometheus for the alert state
log "Querying Prometheus for alert '$ALERT_NAME'…"
ALERT_STATE=$(curl -s "$PROMETHEUS_URL/api/v1/alerts" | \
  jq -r --arg NAME "$ALERT_NAME" \
    '.data.alerts[] | select(.labels.alertname==$NAME) | "\(.state) at \(.activeAt)"' || echo "not firing")
log "Prometheus alert state: $ALERT_STATE"

# 4. Results
log "==== Chaos Engineering Run Completed ===="
log "Original Pod:  $POD"
log "Recovered Pod: $NEW_POD"
log "Alert State:   $ALERT_STATE"

echo
log "Full logs available at $LOG_FILE"
