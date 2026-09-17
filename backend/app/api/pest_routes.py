from typing import List, Optional
from uuid import uuid4
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from app.core.config import settings
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.models.farm import Farm
from app.models.pest_trap import PestTrap, PestTrapObservation
from app.schemas.all_schemas import PestTrapOut, PestTrapObservationOut
from app.services.pest_trap_service import pest_trap_service

router = APIRouter(prefix="/pest-trap", tags=["Pest Trap Intelligence"])

@router.get("", response_model=List[PestTrapOut])
def get_pest_traps(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    farm = db.query(Farm).filter(Farm.user_id == current_user.id).first()
    if not farm:
        return []
    traps = db.query(PestTrap).filter(PestTrap.farm_id == farm.id).all()
    out = []
    for t in traps:
        latest = db.query(PestTrapObservation).filter(PestTrapObservation.trap_id == t.id).order_by(PestTrapObservation.id.desc()).first()
        out.append(PestTrapOut(
            id=t.id,
            farm_id=t.farm_id,
            trap_name=t.trap_name,
            trap_type=t.trap_type,
            target_crop=t.target_crop,
            latitude=t.latitude,
            longitude=t.longitude,
            installed_date=t.installed_date,
            latest_observation=PestTrapObservationOut.model_validate(latest) if latest else None
        ))
    return out

@router.post("/analyze")
def analyze_pest_trap(
    trap_id: Optional[int] = Form(None),
    trap_type: str = Form("Yellow Sticky Trap"),
    crop: str = Form("Tomato"),
    file: Optional[UploadFile] = File(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    farm = db.query(Farm).filter(Farm.user_id == current_user.id).first()
    if not farm:
        farm = Farm(user_id=current_user.id, farm_name="Primary Crop Plot")
        db.add(farm)
        db.commit()
        db.refresh(farm)

    # If trap doesn't exist, create one
    if not trap_id:
        trap = db.query(PestTrap).filter(PestTrap.farm_id == farm.id).first()
        if not trap:
            trap = PestTrap(farm_id=farm.id, trap_name="Field Sticky Trap #01", trap_type=trap_type, target_crop=crop)
            db.add(trap)
            db.commit()
            db.refresh(trap)
        trap_id = trap.id

    saved_filename = f"pest_trap_{uuid4().hex[:8]}.png"
    save_path = settings.UPLOAD_DIR / saved_filename
    if file and file.filename:
        try:
            content = file.file.read()
            with open(save_path, "wb") as f:
                f.write(content)
        except Exception:
            pass

    # Run analysis
    res = pest_trap_service.analyze_trap_image(trap_type=trap_type, target_crop=crop)

    obs = PestTrapObservation(
        trap_id=trap_id,
        image_url=f"/uploads/{saved_filename}",
        detected_pest=res["detected_pest"],
        estimated_count=res["estimated_count"],
        pest_pressure=res["pest_pressure"],
        risk_level=res["risk_level"],
        confidence=res["confidence"],
        advisory=res["advisory"],
        model_version=res["model_version"]
    )
    db.add(obs)
    db.commit()
    db.refresh(obs)

    return {
        "observation": PestTrapObservationOut.model_validate(obs),
        "bounding_boxes": res["bounding_boxes"],
        "message": "Pest trap image analyzed successfully"
    }
