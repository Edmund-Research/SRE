"""
ml_detector package initialization
"""

__version__ = "0.1.0"

# Expose core functions
from ml_detector.src.preprocess import load_and_clean
from ml_detector.src.train import train_model
from ml_detector.src.infer import run_inference