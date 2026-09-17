import logging
import random
from typing import Dict, Any, Optional
from PIL import Image

logger = logging.getLogger(__name__)

# Realistic agricultural advisory knowledgebase for prototype explainability
DISEASE_KNOWLEDGEBASE = {
    "Tomato___Early_blight": {
        "crop": "Tomato",
        "disease": "Tomato Early Blight (Alternaria solani)",
        "severity": "Moderate",
        "explanation": "Target-like concentric brown rings detected on lower foliage. Fungal pathogen thrives in alternating wet and dry weather with canopy humidity.",
        "recommendations": "1. Manually prune severely affected lower foliage and destroy away from field.\n2. Avoid overhead furrow splashing; transition to drip irrigation to keep canopy dry.\n3. Increase plant row aeration to lower canopy micro-humidity.\n4. Apply Trichoderma harzianum or approved bio-fungicidal copper spray if lesion expansion continues.",
        "prevention": "Rotate crops with non-solanaceous species for at least 2 seasons. Ensure weed-free field borders."
    },
    "Tomato___Late_blight": {
        "crop": "Tomato",
        "disease": "Tomato Late Blight (Phytophthora infestans)",
        "severity": "High",
        "explanation": "Rapid water-soaked dark necrotic lesions with pale margins. Highly contagious under prolonged cool, damp conditions.",
        "recommendations": "1. Immediately isolate affected plants to prevent aerial spore spread.\n2. Cease all sprinkler irrigation.\n3. Apply targeted biological protectant or consultation-approved bio-fungicide.\n4. Clean all pruning tools with 70% alcohol between plots.",
        "prevention": "Plant resistant cultivars, maintain wide spacing, and monitor leaf wetness hours closely."
    },
    "Tomato___healthy": {
        "crop": "Tomato",
        "disease": "Healthy Foliage (No Pathogen Detected)",
        "severity": "None",
        "explanation": "Uniform chlorophyll distribution, crisp leaf margins, and absence of necrotic spotting or chlorotic mottling.",
        "recommendations": "1. Continue balanced nitrogen-potassium fertigation.\n2. Maintain consistent soil moisture (target 60-65%).\n3. Conduct standard weekly scouting for early insect vector presence.",
        "prevention": "Ensure soil drainage and install yellow sticky traps for prophylactic vector surveillance."
    },
    "Potato___Early_blight": {
        "crop": "Potato",
        "disease": "Potato Early Blight (Alternaria solani)",
        "severity": "Moderate",
        "explanation": "Dark brown circular lesions exhibiting classic concentric rings on mature lower potato foliage.",
        "recommendations": "1. Remove diseased lower foliage.\n2. Avoid late-afternoon irrigation.\n3. Maintain optimal potassium nutrition to bolster epidermal resistance.",
        "prevention": "Certified disease-free seed tubers; practice 3-year crop rotation."
    },
    "Corn___Common_rust": {
        "crop": "Corn",
        "disease": "Corn Common Rust (Puccinia sorghi)",
        "severity": "Moderate",
        "explanation": "Golden-brown to cinnamon-colored pustules on upper and lower leaf surfaces containing powdery urediniospores.",
        "recommendations": "1. Monitor rust pustule spread on ear leaf.\n2. Ensure adequate potassium and avoid excessive early nitrogen.\n3. Scout neighboring fields for spore drift.",
        "prevention": "Select rust-resistant hybrid seed varieties."
    }
}

class DiseaseDetectionService:
    def __init__(self):
        self._predictor = None
        self._initialized = False
        self._init_real_model()

    def _init_real_model(self):
        try:
            from app.ml.crop_disease.inference import predictor
            self._predictor = predictor
            self._initialized = True
            logger.info("Real EfficientNet-B0 PyTorch model successfully initialized.")
        except Exception as e:
            logger.warning(f"PyTorch / EfficientNet-B0 model unavailable: {e}. Using structured prototype AI service.")
            self._initialized = False

    def analyze_image(self, image: Image.Image, crop_hint: str = "Tomato", force_low_confidence: bool = False) -> Dict[str, Any]:
        """
        Runs disease classification on leaf image.
        Separates Real EfficientNet-B0 from Mock service cleanly.
        Applies confidence check threshold:
          >= 0.70: High confidence AI result
          < 0.70: Low confidence -> triggers Expert Review
        """
        # If real model is initialized and running
        if self._initialized and self._predictor is not None:
            try:
                from app.ml.crop_disease.image_validation import inspect_image
                quality = inspect_image(image)
                res = self._predictor.predict(image, crop_hint=crop_hint, quality=quality)
                conf = float(res.get("confidence", 0.85))
                if conf > 1.0:
                    conf = conf / 100.0
                if force_low_confidence:
                    conf = 0.54  # Pre-configured low confidence for hackathon demo flow

                disease_name = res.get("disease", "Tomato Early Blight")
                requires_expert = (conf < 0.70) or (disease_name == "Unable to Determine")
                return {
                    "crop": res.get("crop", crop_hint),
                    "disease": disease_name,
                    "confidence": round(conf, 2),
                    "severity": res.get("severity", "Moderate"),
                    "explanation": res.get("explanation", "AI analyzed leaf pattern via EfficientNet-B0 feature maps."),
                    "recommendations": res.get("recommendations", "Prune affected leaves, avoid splash irrigation."),
                    "prevention": res.get("prevention", "Maintain crop rotation and airflow."),
                    "model_used": res.get("model_used", "EfficientNet-B0 (PyTorch)"),
                    "requires_expert_review": requires_expert,
                    "expert_status": "PENDING" if requires_expert else "NOT_REQUIRED"
                }
            except Exception as e:
                logger.error(f"Inference error in real model: {e}. Falling back to prototype service.")

        # Prototype / Mock Disease Service
        return self._mock_analysis(crop_hint, force_low_confidence)

    def _mock_analysis(self, crop_hint: str = "Tomato", force_low_confidence: bool = False) -> Dict[str, Any]:
        crop_clean = (crop_hint or "Tomato").capitalize()
        # Pick relevant key
        key = f"{crop_clean}___Early_blight"
        if key not in DISEASE_KNOWLEDGEBASE:
            key = "Tomato___Early_blight"

        info = DISEASE_KNOWLEDGEBASE[key]
        
        # Hackathon demo flow support:
        # If force_low_confidence is true (or for special demo case), return 54% to show "Expert Review Recommended"
        if force_low_confidence:
            conf = 0.54
        else:
            conf = 0.87  # High confidence demo: 87%

        requires_expert = conf < 0.70

        return {
            "crop": info["crop"],
            "disease": info["disease"],
            "confidence": conf,
            "severity": info["severity"],
            "explanation": info["explanation"],
            "recommendations": info["recommendations"],
            "prevention": info["prevention"],
            "model_used": "EfficientNet-B0 (Prototype Service)",
            "requires_expert_review": requires_expert,
            "expert_status": "PENDING" if requires_expert else "NOT_REQUIRED"
        }

disease_service = DiseaseDetectionService()
