# Predictive Network Autoscaling & Resilience

## Overview
- ML-driven anomaly detection with Isolation Forest
- Terraform-managed AWS Auto Scaling Group
- Ansible automation for provisioning
- Chaos Toolkit for fault injection
- Grafana dashboard for real-time monitoring


Quickstart

1. Provision Infra:
    ```bash
    cd terraform && terraform init && terraform apply -auto-approve

2. Configure & Scale:
    ```bash
    ansible-playbook ansible/playbooks/provision.yml

3. Train ML model
    ```bash
    python ml_detector/src/train.py --data ml_detector/data/synthetic_network.csv --output ml_detector/models/isolation_forest.pkl

4. Run 
    ```bash
    python ml_detector/src/infer.py --model ml_detector/models/isolation_forest.pkl --data ml_detector/data/synthetic_network.csv

5. Execute Chaos Test:
    ```bash
    chaos run chaos/experiment.json

6. Import Grafana Dashboard: Upload grafana/dashboard.json in Grafana UI.
