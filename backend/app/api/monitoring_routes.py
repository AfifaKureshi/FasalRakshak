from datetime import datetime, timezone
from typing import List, Optional
from uuid import uuid4
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from app.core.config import settings
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.models.farm import Farm
from app.models.monitoring import MonitoringRecord
from app.schemas.all_schemas import MonitoringRecordOut
from app.services.monitoring_service import monitoring_service

router = APIRouter(prefix="/monitoring", tags=["Continuous Monitoring (Day 0 vs Day 7)"])

@router.get("", response_model=List[MonitoringRecordOut])
def get_monitoring_records(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    farm = db.query(Farm).filter(Farm.user_id == current_user.id).first()
    if not farm:
        return []
    return db.query(MonitoringRecord).filter(MonitoringRecord.farm_id == farm.id).order_by(MonitoringRecord.id.desc()).all()

@router.post("/follow-up")
def submit_follow_up(
    monitoring_id: int = Form(...),
    progression: str = Form("IMPROVED"), # IMPROVED, STABLE, WORSENED
    file: Optional[UploadFile] = File(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    record = db.query(MonitoringRecord).filter(MonitoringRecord.id == monitoring_id).first()
    if not record:
        raise HTTPException(status_code=404, detail="Monitoring record not found")

    saved_filename = f"monitor_day7_{uuid4().hex[:8]}.png"
    save_path = settings.UPLOAD_DIR / saved_filename
    if file and file.filename:
        try:
            content = file.file.read()
            with open(save_path, "wb") as f:
                f.write(content)
        except Exception:
            pass
    
    # Run comparative assessment
    comp = monitoring_service.evaluate_follow_up(
        initial_disease=record.initial_disease,
        initial_severity=record.initial_severity,
        follow_up_assessment=progression
    )

    record.follow_up_image_url = f"/uploads/{saved_filename}"
    record.follow_up_date = datetime.now(timezone.utc)
    record.progression_status = comp["progression_status"]
    record.comparative_notes = comp["comparative_notes"]
    record.updated_advisory = comp["updated_advisory"]
    record.is_completed = True

    db.commit()
    db.refresh(record)

    return {
        "message": "Continuous monitoring follow-up recorded",
        "monitoring_record": MonitoringRecordOut.model_validate(record)
    }
