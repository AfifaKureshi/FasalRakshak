"""Full-class model scores and explicit abstention. Original weights unchanged."""
import logging
import os
from pathlib import Path
import threading
from time import perf_counter
import torch
from torch import nn
from torchvision import models, transforms
from PIL import Image
from app.ml.crop_disease.labels import DISEASE_METADATA
from app.ml.crop_disease.image_validation import decode_image, inspect_image, ImageValidationError

LOG = logging.getLogger(__name__)
WEIGHTS_DIR = Path(__file__).parent / "weights"
PLANTVILLAGE_CLASSES = [
    "Apple___Apple_scab", "Apple___Black_rot", "Apple___Cedar_apple_rust", "Apple___healthy",
    "Blueberry___healthy", "Cherry___Powdery_mildew", "Cherry___healthy",
    "Corn___Cercospora_leaf_spot Gray_leaf_spot", "Corn___Common_rust", "Corn___Northern_Leaf_Blight", "Corn___healthy",
    "Grape___Black_rot", "Grape___Esca_(Black_Measles)", "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)", "Grape___healthy",
    "Orange___Haunglongbing_(Citrus_greening)", "Peach___Bacterial_spot", "Peach___healthy",
    "Pepper,_bell___Bacterial_spot", "Pepper,_bell___healthy",
    "Potato___Early_blight", "Potato___Late_blight", "Potato___healthy",
    "Raspberry___healthy", "Soybean___healthy", "Squash___Powdery_mildew",
    "Strawberry___Leaf_scorch", "Strawberry___healthy",
    "Tomato___Bacterial_spot", "Tomato___Early_blight", "Tomato___Late_blight", "Tomato___Leaf_Mold",
    "Tomato___Septoria_leaf_spot", "Tomato___Spider_mites Two-spotted_spider_mite", "Tomato___Target_Spot",
    "Tomato___Tomato_Yellow_Leaf_Curl_Virus", "Tomato___Tomato_mosaic_virus", "Tomato___healthy",
]
FGVC7_CLASSES = ["healthy", "multiple_diseases", "rust", "scab"]
SUPPORTED_CROPS = ["Apple", "Blueberry", "Cherry", "Corn", "Grape", "Orange", "Peach", "Pepper", "Potato", "Raspberry", "Soybean", "Squash", "Strawberry", "Tomato"]

# Preserve original preprocessing; no unvalidated sharpening/colour changes.
TRANSFORM = transforms.Compose([
    transforms.Resize((224, 224)), transforms.ToTensor(),
    transforms.Normalize([.485, .456, .406], [.229, .224, .225]),
])

def normalize_crop(crop):
    aliases = {c.lower(): c for c in SUPPORTED_CROPS}
    aliases.update({"corn (maize)": "Corn", "maize": "Corn", "pepper (bell)": "Pepper", "pepper,_bell": "Pepper"})
    return aliases.get((crop or "").strip().lower())

def class_crop(label):
    return normalize_crop(label.split("___")[0])

def canonical_label(label):
    return label.replace("Cherry_(including_sour)___", "Cherry___").replace("Corn_(maize)___", "Corn___").removesuffix("_")

def full_class_scores(logits, crop_hint):
    """Never re-normalize over only the selected crop's classes."""
    probabilities = torch.softmax(logits.float(), dim=-1)
    if not torch.isfinite(probabilities).all():
        raise RuntimeError("The model returned invalid scores.")
    valid = [i for i, name in enumerate(PLANTVILLAGE_CLASSES) if class_crop(name) == crop_hint]
    if not valid:
        raise ImageValidationError("unsupported_crop", "This crop is not supported. Choose a supported crop.")
    index = max(valid, key=lambda i: probabilities[i].item())
    top = torch.topk(probabilities, k=3)
    confidence = float(probabilities[index])
    alternatives = probabilities.clone()
    alternatives[index] = 0
    return {
        "class_index": index, "confidence": confidence,
        "crop_mass": float(probabilities[valid].sum()),
        "margin": confidence - float(alternatives.max()),
        "global_index": int(top.indices[0]), "global_confidence": float(top.values[0]),
        "top_predictions": [{"class_name": PLANTVILLAGE_CLASSES[int(i)], "confidence": round(float(p) * 100, 2)} for p, i in zip(top.values, top.indices)],
    }

class DiseasePredictor:
    def __init__(self):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        if self.device.type == "cpu":
            torch.set_num_threads(max(1, min(int(os.getenv("MODEL_CPU_THREADS", "4")), os.cpu_count() or 1)))
        self._lock = threading.Lock()
        self._loaded = False
        self.plantvillage_model = self.fgvc7_model = None

    def _load(self, name, classes):
        checkpoint = torch.load(WEIGHTS_DIR / name, map_location="cpu", weights_only=True)
        state = checkpoint
        if isinstance(checkpoint, dict):
            state = checkpoint.get("model_state_dict", checkpoint.get("state_dict", checkpoint))
            saved_classes = checkpoint.get("class_names")
            if saved_classes is None:
                saved_classes = checkpoint.get("classes")
            if saved_classes is not None and [canonical_label(c) for c in saved_classes] != classes:
                raise RuntimeError(f"Class order in {name} differs from configured classes.")
        state = {k.removeprefix("module."): v for k, v in state.items()}
        model = models.efficientnet_b0(weights=None)
        model.classifier[1] = nn.Linear(model.classifier[1].in_features, len(classes))
        model.load_state_dict(state, strict=True)
        return model.to(self.device).eval()

    def _ensure_loaded(self):
        if self._loaded:
            return
        self.plantvillage_model = self._load("plantvillage_38.pth", PLANTVILLAGE_CLASSES)
        try:
            self.fgvc7_model = self._load("fgvc7_4class.pth", FGVC7_CLASSES)
        except Exception:
            LOG.warning("Apple cross-check unavailable; using PlantVillage model.", exc_info=True)
        self._loaded = True

    def predict(self, image_path, crop_hint="Apple", quality=None):
        started = perf_counter()
        crop = normalize_crop(crop_hint)
        if crop is None:
            raise ImageValidationError("unsupported_crop", "This crop is not supported. Choose a supported crop.")
        image = image_path if isinstance(image_path, Image.Image) else decode_image(Path(image_path).read_bytes())
        quality = quality if quality is not None else inspect_image(image)
        tensor = TRANSFORM(image).unsqueeze(0).to(self.device)
        with self._lock, torch.inference_mode():
            self._ensure_loaded()
            scores = full_class_scores(self.plantvillage_model(tensor)[0], crop)
            global_crop = class_crop(PLANTVILLAGE_CLASSES[scores["global_index"]])
            if global_crop != crop and scores["global_confidence"] >= .75 and scores["crop_mass"] < .25:
                raise ImageValidationError("crop_mismatch", "The image may not match the selected crop. Check your crop selection or upload another leaf photo.", suggested_crop=global_crop)
            if scores["global_confidence"] < float(os.getenv("MODEL_MIN_GLOBAL_CONF", "0.35")):
                raise ImageValidationError("non_leaf_suspected", "The image does not contain recognizable crop foliage. Please upload a clear photo of a single crop leaf.")
            label = PLANTVILLAGE_CLASSES[scores["class_index"]]
            reasons = list(quality["warnings"])
            if scores["confidence"] < float(os.getenv("MODEL_MIN_CONFIDENCE", "0.65")):
                reasons.append("low_confidence")
            if scores["margin"] < float(os.getenv("MODEL_MIN_MARGIN", "0.15")):
                reasons.append("ambiguous_prediction")
            if global_crop != crop:
                reasons.append("crop_uncertain")
            specialist = None
            if crop == "Apple" and self.fgvc7_model is not None:
                apple_probs = torch.softmax(self.fgvc7_model(tensor)[0].float(), dim=0)
                apple_i = int(apple_probs.argmax())
                apple_label = FGVC7_CLASSES[apple_i]
                specialist = {"label": apple_label, "confidence": round(float(apple_probs[apple_i]) * 100, 2)}
                expected = {"Apple___healthy": "healthy", "Apple___Cedar_apple_rust": "rust", "Apple___Apple_scab": "scab"}.get(label)
                # FGVC7 has no black-rot class; do not force it into scab/rust.
                if expected and apple_label != expected:
                    reasons.append("models_disagree")
        result = self._build_result(label, scores["confidence"] * 100)
        status = "needs_review" if reasons else "preliminary"
        if reasons:
            result.update({
                "disease": "Unable to Determine", "severity": "Unknown",
                "explanation": "The image could not be classified reliably. The candidate scores are not a confirmed diagnosis.",
                "recommendations": "Retake a clear photo of a single leaf and request an agricultural expert review before treatment.",
                "prevention": "Monitor the crop and keep a record of changing symptoms.",
            })
        result["analysis"] = {
            "status": status, "reasons": reasons, "quality": quality,
            "top_predictions": scores["top_predictions"], "apple_cross_check": specialist,
            "model_used": "EfficientNet-B0 PlantVillage 38-class",
            "elapsed_ms": round((perf_counter() - started) * 1000),
            "confidence_note": "Uncalibrated full-class model score; not probability of correctness.",
        }
        return result

    @staticmethod
    def _build_result(label, confidence):
        crop, disease = label.split("___", 1)
        result = DISEASE_METADATA.get(label, {}).copy()
        result.setdefault("crop", normalize_crop(crop) or crop)
        result.setdefault("disease", disease.replace("_", " ").strip())
        result.setdefault("explanation", "The image contains patterns associated with the predicted crop condition.")
        result.setdefault("recommendations", "Ask an agricultural expert to confirm the condition before treatment.")
        result.setdefault("prevention", "Monitor the crop and follow local agricultural guidance.")
        # These weights classify conditions; they do not measure lesion area.
        result["severity"] = "Not assessed"
        result["confidence"] = round(confidence, 2)
        result["model_used"] = "EfficientNet-B0 PlantVillage 38-class"
        result["class_name"] = label
        return result

predictor = DiseasePredictor()
