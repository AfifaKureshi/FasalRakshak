"""Conservative image-quality / non-leaf screening, not a trained OOD detector.

Thresholds are configurable prototype defaults, not calibrated probabilities.
An accepted image is NOT proof that it is a supported crop or disease.
"""
from functools import lru_cache
from io import BytesIO
import os
import threading
import warnings

try:
    import cv2
    HAS_CV2 = True
except ImportError:
    cv2 = None
    HAS_CV2 = False

import numpy as np
from PIL import Image, ImageOps, UnidentifiedImageError, ImageFilter, ImageStat

MAX_UPLOAD_BYTES = 10 * 1024 * 1024
MAX_PIXELS = 20_000_000
FACE_LOCK = threading.Lock()



class ImageValidationError(ValueError):
    def __init__(self, code, message, status_code=422, **context):
        super().__init__(message)
        self.code, self.message, self.status_code = code, message, status_code
        self.context = context

    def detail(self):
        return {"code": self.code, "message": self.message, **self.context}


def decode_image(data):
    if not data:
        raise ImageValidationError("invalid_image", "The file is empty or is not a readable image.")
    if len(data) > MAX_UPLOAD_BYTES:
        raise ImageValidationError("file_too_large", "Choose an image smaller than 10 MB.", 413)
    try:
        with warnings.catch_warnings():
            warnings.simplefilter("error", Image.DecompressionBombWarning)
            with Image.open(BytesIO(data)) as probe:
                if probe.format not in {"JPEG", "PNG", "WEBP"}:
                    raise ImageValidationError("unsupported_format", "Choose a JPEG, PNG or WebP image.")
                if probe.width * probe.height > MAX_PIXELS:
                    raise ImageValidationError("image_too_large", "Choose an image with fewer than 20 million pixels.")
                if min(probe.size) < 128:
                    raise ImageValidationError("image_too_small", "Use an image at least 128 pixels wide and high.")
                probe.verify()
            with Image.open(BytesIO(data)) as source:
                source = ImageOps.exif_transpose(source)
                # Composite transparent backgrounds before RGB conversion.
                rgba = source.convert("RGBA")
                image = Image.new("RGBA", rgba.size, "white")
                image.alpha_composite(rgba)
                return image.convert("RGB")
    except ImageValidationError:
        raise
    except (UnidentifiedImageError, OSError, ValueError, Image.DecompressionBombError,
            Image.DecompressionBombWarning) as exc:
        raise ImageValidationError("invalid_image", "The file is damaged or is not a readable image.") from exc


@lru_cache(maxsize=1)
def _face_detector():
    if not HAS_CV2:
        return None
    detector = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
    if detector.empty():
        raise RuntimeError("Face screening could not be loaded. Reinstall opencv-python-headless.")
    return detector


def inspect_image(image):
    """Reject obvious bad inputs; return measurements for accepted images."""
    if not HAS_CV2:
        preview = image.copy()
        preview.thumbnail((256, 256))
        arr = np.asarray(preview.convert("RGB"), dtype=np.float32)
        mean_brightness = float(np.mean(arr))
        if mean_brightness < 20:
            raise ImageValidationError("too_dark", "The photo is too dark. Retake it in natural light.")
        if mean_brightness > 248:
            raise ImageValidationError("too_bright", "The photo is overexposed. Avoid flash and retake it.")

        # Plant foliage color mask:
        # 1. Excess Green Index (ExG = 2G - R - B) identifies true foliage chlorophyllic pigments:
        r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
        exg = 2.0 * g - r - b
        is_green = (exg > 12.0) & (g > 38.0)
        # 2. Chlorotic foliar yellow (e.g. mosaic or deficiency): high R & G, low B
        is_yellow = (r > 80.0) & (g > 80.0) & (b < 85.0) & (np.abs(r - g) < 45.0) & ((r + g) > 2.2 * b)
        # 3. Necrotic lesions on foliage (dark brown/tan spots)
        is_lesion_brown = (r > 45.0) & (g > 30.0) & (b < 75.0) & (r > (b + 18.0)) & (g < 140.0)

        foliage_core = is_green | is_yellow
        plant_mask = foliage_core | is_lesion_brown
        plant_fraction = float(np.mean(plant_mask))
        green_fraction = float(np.mean(foliage_core))

        if plant_fraction < float(os.getenv("LEAF_COLOR_MIN_FRACTION", "0.15")) or green_fraction < 0.08:
            raise ImageValidationError(
                "non_leaf_suspected",
                "The uploaded image does not contain recognizable crop leaf foliage. Please upload a clear photo of a plant leaf."
            )

        return {
            "screening": "pillow_numpy_guard",
            "sharpness": 50.0,
            "plant_color_fraction": round(plant_fraction, 3),
            "warnings": [],
            "width": image.width,
            "height": image.height,
        }

    preview = image.copy()
    preview.thumbnail((768, 768))
    rgb = np.asarray(preview)
    gray = cv2.cvtColor(rgb, cv2.COLOR_RGB2GRAY)
    with FACE_LOCK:
        det = _face_detector()
        if det is not None:
            faces = det.detectMultiScale(
                cv2.equalizeHist(gray), scaleFactor=1.1, minNeighbors=6, minSize=(40, 40)
            )
            if len(faces):
                raise ImageValidationError("person_detected", "A face was detected. Upload a photo of one crop leaf only.")

    # Use fixed resolution so pixel-scale blur thresholds are comparable.
    small = cv2.resize(rgb, (256, 256), interpolation=cv2.INTER_AREA)
    hsv = cv2.cvtColor(small, cv2.COLOR_RGB2HSV)
    hue, sat, val = hsv[:, :, 0], hsv[:, :, 1], hsv[:, :, 2]
    # Include yellow/brown leaves, not only green healthy leaves.
    plant_mask = ((hue >= 8) & (hue <= 95) & (sat >= 35) & (val >= 30)).astype(np.uint8)
    plant_mask = cv2.morphologyEx(plant_mask, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
    plant_fraction = float(plant_mask.mean())
    gray_small = cv2.cvtColor(small, cv2.COLOR_RGB2GRAY)
    if np.mean(gray_small < 20) > .9:
        raise ImageValidationError("too_dark", "The photo is too dark. Retake it in natural light.")
    if np.mean(gray_small > 245) > .9:
        raise ImageValidationError("too_bright", "The photo is overexposed. Avoid flash and retake it.")
    if plant_fraction < float(os.getenv("LEAF_COLOR_MIN_FRACTION", "0.15")):
        raise ImageValidationError("non_leaf_suspected", "A crop leaf could not be identified. Place one leaf on a plain background and retake the photo.")

    lap = cv2.Laplacian(gray_small, cv2.CV_32F)
    interior = cv2.erode(plant_mask, np.ones((5, 5), np.uint8)).astype(bool)
    sharpness = float(np.var(lap[interior])) if interior.sum() >= 256 else float(np.var(lap))
    if sharpness < float(os.getenv("BLUR_REJECT_THRESHOLD", "12")):
        raise ImageValidationError("too_blurry", "The leaf details are too blurry. Hold the camera steady, tap the leaf to focus and retake the photo.", sharpness=round(sharpness, 2))
    caution = []
    if sharpness < float(os.getenv("BLUR_WARN_THRESHOLD", "45")):
        caution.append("slightly_blurry")
    return {
        "screening": "heuristic_v1", "sharpness": round(sharpness, 2),
        "plant_color_fraction": round(plant_fraction, 3), "warnings": caution,
        "width": image.width, "height": image.height,
    }

