from datetime import datetime, timezone
from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role
from app.models.user import User, UserRole
from app.models.diagnosis import CropDiagnosis
from app.models.expert_review import ExpertReview
from app.schemas.all_schemas import ExpertReviewCreate, ExpertReviewOut

router = APIRouter(prefix="/expert", tags=["Agricultural Expert Review"])

@router.get("/pending-reviews", response_model=List[ExpertReviewOut])
def get_pending_reviews(
    current_user: User = Depends(require_role([UserRole.EXPERT, UserRole.ADMIN])),
    db: Session = Depends(get_db)
):
    reviews = db.query(ExpertReview).filter(ExpertReview.status == "PENDING").order_by(ExpertReview.id.desc()).all()
    out = []
    for r in reviews:
        diag = db.query(CropDiagnosis).filter(CropDiagnosis.id == r.diagnosis_id).first()
        farmer = db.query(User).filter(User.id == r.farmer_id).first()
        out.append(ExpertReviewOut(
            id=r.id,
            diagnosis_id=r.diagnosis_id,
            farmer_id=r.farmer_id,
            farmer_name=farmer.full_name if farmer else "Local Farmer",
            crop_name=diag.crop_name if diag else "Tomato",
            image_url=diag.image_url if diag else "/uploads/placeholder.png",
            original_disease=r.original_disease,
            validated_disease=r.validated_disease,
            confidence=diag.confidence if diag else 0.54,
            status=r.status,
            expert_notes=r.expert_notes,
            expert_recommendations=r.expert_recommendations,
            created_at=r.created_at,
            answered_at=r.answered_at
        ))
    return out

@router.post("/review")
def submit_expert_review(
    review_in: ExpertReviewCreate,
    current_user: User = Depends(require_role([UserRole.EXPERT, UserRole.ADMIN])),
    db: Session = Depends(get_db)
):
    review = db.query(ExpertReview).filter(ExpertReview.diagnosis_id == review_in.diagnosis_id).first()
    if not review:
        raise HTTPException(status_code=404, detail="Review case not found for this diagnosis")

    diag = db.query(CropDiagnosis).filter(CropDiagnosis.id == review_in.diagnosis_id).first()
    if not diag:
        raise HTTPException(status_code=404, detail="Associated diagnosis record not found")

    review.expert_id = current_user.id
    review.expert_notes = review_in.expert_notes
    review.expert_recommendations = review_in.expert_recommendations
    review.answered_at = datetime.now(timezone.utc)

    if review_in.action.upper() == "OVERRIDE" and review_in.validated_disease:
        review.status = "OVERRIDDEN"
        review.validated_disease = review_in.validated_disease
        diag.disease_detected = review_in.validated_disease
        diag.expert_status = "OVERRIDDEN"
    else:
        review.status = "VALIDATED"
        review.validated_disease = review.original_disease
        diag.expert_status = "VALIDATED"

    # Update recommendations on diagnosis with expert input
    diag.recommendations = f"[Expert Validated by {current_user.full_name}]: {review_in.expert_recommendations}\n\n[Clinical Notes]: {review_in.expert_notes}"

    db.commit()
    db.refresh(review)
    db.refresh(diag)

    return {
        "message": "Expert validation submitted successfully",
        "review_id": review.id,
        "status": review.status,
        "validated_disease": review.validated_disease,
        "expert_name": current_user.full_name
    }
