#!/usr/bin/env bash
set -euo pipefail

# 1. Identify a running payment pod
POD=$(kubectl get pods -l app=payment \
     --field-selector=status.phase=Running \
     -o jsonpath='{.items[0].metadata.name}')

echo "Killing pod $POD …"
# 2. Delete the pod
kubectl delete pod "$POD" --grace-period=0 --force

echo "Pod $POD deleted. Kubernetes should recreate it automatically."
