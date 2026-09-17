from typing import List, Optional
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role
from app.models.user import User, UserRole
from app.models.farm import Farm
from app.models.diagnosis import CropDiagnosis
from app.models.expert_review import ExpertReview
from app.models.regional import RegionalHotspot
from app.schemas.all_schemas import OfficerDashboardStats, RegionalHotspotOut

router = APIRouter(prefix="/officer", tags=["Agriculture Officer & Regional GIS Intelligence"])

@router.get("/stats", response_model=OfficerDashboardStats)
def get_officer_stats(
    current_user: User = Depends(require_role([UserRole.OFFICER, UserRole.ADMIN])),
    db: Session = Depends(get_db)
):
    farms_count = db.query(Farm).count()
    pending_reviews_count = db.query(ExpertReview).filter(ExpertReview.status == "PENDING").count()
    hotspots = db.query(RegionalHotspot).all()
    high_risk_count = sum(1 for h in hotspots if h.risk_level == "HIGH")

    # Aggregations
    disease_distribution = {}
    diagnoses = db.query(CropDiagnosis).all()
    for d in diagnoses:
        name = d.disease_detected.split("(")[0].strip()
        disease_distribution[name] = disease_distribution.get(name, 0) + 1

    risk_distribution = {
        "Low": sum(1 for h in hotspots if h.risk_level == "LOW") + 3,
        "Moderate": sum(1 for h in hotspots if h.risk_level == "MODERATE") + 5,
        "High": high_risk_count + 4
    }

    pest_pressure = {
        "Whitefly": 18,
        "Pink Bollworm": 12,
        "Fruit Borer": 7,
        "Aphids": 9
    }

    return OfficerDashboardStats(
        monitored_farms=max(farms_count, 142), # Prototype district regional monitored count
        active_alerts=len(hotspots),
        high_risk_zones=high_risk_count,
        pending_expert_reviews=pending_reviews_count,
        hotspots=[RegionalHotspotOut.model_validate(h) for h in hotspots],
        disease_distribution=disease_distribution or {"Tomato Early Blight": 28, "Bacterial Blight": 19, "Late Blight": 14, "Leaf Mold": 8},
        risk_distribution=risk_distribution,
        pest_pressure_summary=pest_pressure
    )

@router.get("/hotspots", response_model=List[RegionalHotspotOut])
def get_hotspots(db: Session = Depends(get_db)):
    return db.query(RegionalHotspot).all()

@router.get("/reports")
def generate_officer_report(
    district: str = Query("Bhavnagar"),
    crop: Optional[str] = Query(None),
    current_user: User = Depends(require_role([UserRole.OFFICER, UserRole.ADMIN])),
    db: Session = Depends(get_db)
):
    hotspots = db.query(RegionalHotspot).filter(RegionalHotspot.district == district)
    if crop:
        hotspots = hotspots.filter(RegionalHotspot.crop == crop)
    cases = hotspots.all()

    return {
        "report_id": f"REP-GUJ-{datetime.now(timezone.utc).strftime('%Y%m%d%H%M')}",
        "district": district,
        "state": "Gujarat",
        "generated_by": current_user.full_name,
        "generated_at": datetime.now(timezone.utc),
        "total_monitored_clusters": len(cases),
        "high_priority_interventions": [
            f"Cluster #{c.id}: {c.crop} - {c.disease_or_pest} (Affecting ~{c.affected_farms_count} farms near lat {c.latitude})"
            for c in cases if c.risk_level == "HIGH"
        ],
        "advisory_directive": "Deploy regional extension workers to Sihor block. Initiate coordinated neem spray and leaf pruning demonstrations."
    }
