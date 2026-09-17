from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base

class ExpertReview(Base):
    __tablename__ = "expert_reviews"

    id = Column(Integer, primary_key=True, index=True)
    diagnosis_id = Column(Integer, ForeignKey("crop_diagnoses.id"), nullable=False)
    farmer_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    expert_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    
    original_disease = Column(String(100), nullable=False)
    validated_disease = Column(String(100), nullable=True)
    status = Column(String(30), default="PENDING")  # PENDING, VALIDATED, OVERRIDDEN
    
    expert_notes = Column(Text, nullable=True)
    expert_recommendations = Column(Text, nullable=True)
    
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    answered_at = Column(DateTime, nullable=True)

    diagnosis = relationship("CropDiagnosis", back_populates="expert_review")
    expert = relationship("User", back_populates="expert_reviews", foreign_keys=[expert_id])
