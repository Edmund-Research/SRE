import argparse
import joblib
import pandas as pd
from ml_detector.src.preprocess import load_and_clean

def run_inference(model_path: str, data_path: str):
    df = load_and_clean(data_path)
    model = joblib.load(model_path)
    df['anomaly'] = model.predict(df[['network_in', 'rolling_mean']]) == -1
    # Push alerts for anomalies (e.g., via HTTP to Alertmanager)
    anomalies = df[df['anomaly']]
    for ts in anomalies.index:
        print(f"ANOMALY detected at {ts}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--model', required=True)
    parser.add_argument('--data', required=True)
    args = parser.parse_args()
    run_inference(args.model, args.data)