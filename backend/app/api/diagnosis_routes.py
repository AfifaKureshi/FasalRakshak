import io
import json
import logging
from uuid import uuid4
from typing import List, Optional
from pathlib import Path
from PIL import Image
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from app.core.config import settings
from app.core.database import get_db
from app.core.dependencies import get_current_user, get_current_user_or_demo
from app.models.user import User
from app.models.farm import Farm
from app.models.diagnosis import CropDiagnosis
from app.models.risk import RiskAssessment
from app.models.expert_review import ExpertReview
from app.schemas.all_schemas import DiagnosisOut, RiskAssessmentOut
from app.services.disease_detection_service import disease_service
from app.services.risk_assessment_engine import risk_engine
from app.services.weather_service import get_current_weather

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/diagnosis", tags=["Crop Health & Diagnosis"])

@router.post("/analyze")
def analyze_crop(
    crop_name: str = Form("Tomato"),
    force_low_confidence: bool = Form(False),
    file: Optional[UploadFile] = File(None),
    current_user: User = Depends(get_current_user_or_demo),
    db: Session = Depends(get_db)
):
    if current_user is None:
        current_user = get_current_user_or_demo(None, db)
    farm = db.query(Farm).filter(Farm.user_id == current_user.id).first()
    if not farm:
        farm = Farm(user_id=current_user.id, farm_name="Primary Crop Plot", crop=crop_name)
        db.add(farm)
        db.commit()
        db.refresh(farm)

    # Process image
    image = None
    saved_filename = f"crop_{uuid4().hex[:10]}.png"
    save_path = settings.UPLOAD_DIR / saved_filename

    if file and file.filename:
        try:
            content = file.file.read()
            image = Image.open(io.BytesIO(content)).convert("RGB")
            image.save(save_path)
        except Exception as e:
            logger.warning(f"Failed to read uploaded image: {e}. Generating placeholder.")
            image = Image.new("RGB", (224, 224), color=(73, 109, 137))
            image.save(save_path)
    else:
        # Demo placeholder image
        image = Image.new("RGB", (224, 224), color=(73, 109, 137))
        image.save(save_path)

    # 1. Run AI Disease Detection (EfficientNet-B0 or Mock)
    ai_result = disease_service.analyze_image(image, crop_hint=crop_name, force_low_confidence=force_low_confidence)

    # 2. Persist Diagnosis
    diagnosis = CropDiagnosis(
        farm_id=farm.id,
        crop_name=ai_result["crop"],
        image_url=f"/uploads/{saved_filename}",
        disease_detected=ai_result["disease"],
        confidence=ai_result["confidence"],
        severity=ai_result["severity"],
        explanation=ai_result["explanation"],
        recommendations=ai_result["recommendations"],
        prevention=ai_result["prevention"],
        model_version=ai_result["model_used"],
        requires_expert_review=ai_result["requires_expert_review"],
        expert_status=ai_result["expert_status"]
    )
    db.add(diagnosis)
    db.commit()
    db.refresh(diagnosis)

    # 3. Create Expert Review entry if confidence check triggered
    if diagnosis.requires_expert_review:
        expert_rev = ExpertReview(
            diagnosis_id=diagnosis.id,
            farmer_id=current_user.id,
            original_disease=diagnosis.disease_detected,
            status="PENDING"
        )
        db.add(expert_rev)
        db.commit()

    # 4. Fetch Weather & Calculate Multi-Factor Risk
    weather = get_current_weather(farm.latitude, farm.longitude)
    risk_data = risk_engine.calculate_risk(
        crop=diagnosis.crop_name,
        disease=diagnosis.disease_detected,
        severity=diagnosis.severity,
        confidence=diagnosis.confidence,
        temperature_c=weather.get("temperature_c", 28.0),
        humidity_pct=weather.get("relative_humidity_pct", 78.0),
        rain_chance_pct=weather.get("rainfall_chance_pct", 65.0),
        soil_moisture_pct=farm.soil_moisture_pct,
        crop_stage=farm.crop_stage,
        pest_count=18,
        nearby_hotspot_count=2
    )

    risk_assessment = RiskAssessment(
        farm_id=farm.id,
        diagnosis_id=diagnosis.id,
        risk_level=risk_data["risk_level"],
        risk_score=risk_data["risk_score"],
        risk_factors=json.dumps(risk_data["risk_factors"]),
        explanation=risk_data["explanation"],
        advisory_summary=risk_data["advisory_summary"]
    )
    db.add(risk_assessment)
    db.commit()
    db.refresh(risk_assessment)

    return {
        "diagnosis": DiagnosisOut.model_validate(diagnosis),
        "risk_assessment": {
            "id": risk_assessment.id,
            "risk_level": risk_assessment.risk_level,
            "risk_score": risk_assessment.risk_score,
            "risk_factors": risk_data["risk_factors"],
            "explanation": risk_assessment.explanation,
            "advisory_summary": risk_assessment.advisory_summary,
            "created_at": risk_assessment.created_at
        },
        "weather": weather,
        "is_mismatch": ai_result.get("is_mismatch", False),
        "suggested_crop": ai_result.get("suggested_crop"),
        "top_predictions": ai_result.get("top_predictions", [])
    }

@router.get("/history", response_model=List[DiagnosisOut])
def get_diagnosis_history(current_user: User = Depends(get_current_user_or_demo), db: Session = Depends(get_db)):
    farm = db.query(Farm).filter(Farm.user_id == current_user.id).first()
    if not farm:
        return []
    records = db.query(CropDiagnosis).filter(CropDiagnosis.farm_id == farm.id).order_by(CropDiagnosis.id.desc()).limit(30).all()
    return records

@router.get("/{diagnosis_id}")
def get_diagnosis_detail(diagnosis_id: int, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    diag = db.query(CropDiagnosis).filter(CropDiagnosis.id == diagnosis_id).first()
    if not diag:
        raise HTTPException(status_code=404, detail="Diagnosis record not found")
    risk = db.query(RiskAssessment).filter(RiskAssessment.diagnosis_id == diag.id).first()
    review = db.query(ExpertReview).filter(ExpertReview.diagnosis_id == diag.id).first()

    risk_factors = []
    if risk and risk.risk_factors:
        try:
            risk_factors = json.loads(risk.risk_factors)
        except Exception:
            risk_factors = []

    return {
        "diagnosis": DiagnosisOut.model_validate(diag),
        "risk_assessment": {
            "risk_level": risk.risk_level if risk else "MODERATE",
            "risk_score": risk.risk_score if risk else 50.0,
            "risk_factors": risk_factors,
            "explanation": risk.explanation if risk else "",
            "advisory_summary": risk.advisory_summary if risk else ""
        } if risk else None,
        "expert_review": {
            "status": review.status if review else "NOT_REQUIRED",
            "notes": review.expert_notes if review else None,
            "recommendations": review.expert_recommendations if review else None,
            "answered_at": review.answered_at if review else None
        } if review else None
    }
