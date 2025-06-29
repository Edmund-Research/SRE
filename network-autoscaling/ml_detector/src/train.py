import argparse
import joblib
from sklearn.ensemble import IsolationForest
from ml_detector.src.preprocess import load_and_clean

def train_model(input_csv: str, output_model: str):
    df = load_and_clean(input_csv)
    model = IsolationForest(contamination=0.01, random_state=42)
    model.fit(df[['network_in', 'rolling_mean']])
    joblib.dump(model, output_model)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--data', required=True)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    train_model(args.data, args.output)