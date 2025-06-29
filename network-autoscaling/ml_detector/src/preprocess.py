import pandas as pd

def load_and_clean(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, parse_dates=['timestamp'])
    df = df.set_index('timestamp')
    # Example feature: rolling mean
    df['rolling_mean'] = df['network_in'].rolling(window=5).mean()
    df = df.dropna()
    return df