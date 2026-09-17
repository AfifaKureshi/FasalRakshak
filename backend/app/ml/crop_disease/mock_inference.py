import random
from app.ml.crop_disease.labels import DISEASE_METADATA

def run_mock_inference(crop_hint: str = "Cotton") -> dict:
    options = list(DISEASE_METADATA.keys())
    selected_key = random.choice(options)
    data = DISEASE_METADATA[selected_key].copy()
    data["confidence"] = round(random.uniform(89.4, 98.6), 2)
    data["model_used"] = "EfficientNet-B0 (Mocked Weights Fallback)"
    return data