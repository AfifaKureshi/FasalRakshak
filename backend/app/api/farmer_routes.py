from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.models.farm import Farm
from app.models.diagnosis import CropDiagnosis
from app.models.risk import RiskAssessment
from app.schemas.all_schemas import FarmOut, FarmUpdate
from app.services.weather_service import get_current_weather

router = APIRouter(prefix="/farmer", tags=["Farmer & Farm"])

@router.get("/farm", response_model=FarmOut)
def get_farmer_farm(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    farm = db.query(Farm).filter(Farm.user_id == current_user.id).first()
    if not farm:
        # Provide default farm for demo convenience
        farm = Farm(user_id=current_user.id, farm_name="Primary Crop Plot")
        db.add(farm)
        db.commit()
        db.refresh(farm)
    return farm

@router.put("/farm", response_model=FarmOut)
def update_farmer_farm(farm_update: FarmUpdate, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    farm = db.query(Farm).filter(Farm.user_id == current_user.id).first()
    if not farm:
        raise HTTPException(status_code=404, detail="Farm not found")

    for field, value in farm_update.model_dump(exclude_unset=True).items():
        setattr(farm, field, value)

    db.commit()
    db.refresh(farm)
    return farm

@router.get("/dashboard")
def get_farmer_dashboard(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    farm = db.query(Farm).filter(Farm.user_id == current_user.id).first()
    if not farm:
        farm = Farm(user_id=current_user.id, farm_name="Primary Crop Plot")
        db.add(farm)
        db.commit()
        db.refresh(farm)

    # Get latest diagnosis & risk
    latest_diag = db.query(CropDiagnosis).filter(CropDiagnosis.farm_id == farm.id).order_by(CropDiagnosis.id.desc()).first()
    latest_risk = None
    if latest_diag:
        latest_risk = db.query(RiskAssessment).filter(RiskAssessment.diagnosis_id == latest_diag.id).first()

    # Weather
    weather = get_current_weather(farm.latitude, farm.longitude)

    # Notifications & alerts
    alerts = []
    if latest_diag and latest_diag.requires_expert_review and latest_diag.expert_status == "PENDING":
        alerts.append({
            "type": "EXPERT_REVIEW",
            "title": "Expert Review in Progress",
            "message": f"AI flagged low confidence for {latest_diag.crop_name} observation. Case forwarded to plant pathologist.",
            "severity": "MODERATE"
        })
    elif latest_diag and latest_diag.expert_status == "VALIDATED":
        alerts.append({
            "type": "EXPERT_VALIDATED",
            "title": "Expert Recommendation Available",
            "message": f"Dr. Meena Sharma verified your {latest_diag.crop_name} diagnosis and updated cultural recommendations.",
            "severity": "LOW"
        })

    if weather.get("relative_humidity_pct", 0) > 75:
        alerts.append({
            "type": "WEATHER_RISK",
            "title": "High Humidity Alert",
            "message": f"Ambient humidity is {weather.get('relative_humidity_pct')}%. Fungal pathogen risk is elevated.",
            "severity": "HIGH"
        })

    alerts.append({
        "type": "MONITORING_REMINDER",
        "title": "7-Day Follow-Up Due",
        "message": "Upload Day 7 comparative leaf image to verify symptom regression.",
        "severity": "LOW"
    })

    return {
        "farmer_name": current_user.full_name,
        "farm_name": farm.farm_name,
        "village": farm.village,
        "district": farm.district,
        "crop": farm.crop,
        "crop_stage": farm.crop_stage,
        "current_risk_level": latest_risk.risk_level if latest_risk else "MODERATE",
        "current_risk_score": latest_risk.risk_score if latest_risk else 65.0,
        "sync_status": "SYNCED",
        "weather": weather,
        "next_monitoring_day": 7,
        "alerts": alerts,
        "soil": {
            "moisture_pct": farm.soil_moisture_pct,
            "ph": farm.soil_ph,
            "temp_c": farm.soil_temperature_c,
            "type": farm.soil_type,
            "source": "Manual / IoT Connected"
        }
    }
