from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Float, Text, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base

class CropDiagnosis(Base):
    __tablename__ = "crop_diagnoses"

    id = Column(Integer, primary_key=True, index=True)
    farm_id = Column(Integer, ForeignKey("farms.id"), nullable=True)
    crop_name = Column(String(50), nullable=False)
    image_url = Column(String(255), nullable=False)
    disease_detected = Column(String(100), nullable=False)
    confidence = Column(Float, nullable=False)
    severity = Column(String(20), default="Moderate")  # Low, Moderate, High, Severe
    explanation = Column(Text, nullable=False)
    recommendations = Column(Text, nullable=False)
    prevention = Column(Text, nullable=False)
    model_version = Column(String(50), default="EfficientNet-B0")
    
    # Confidence thresholding & Expert validation flag
    requires_expert_review = Column(Boolean, default=False)
    expert_status = Column(String(30), default="NOT_REQUIRED")  # NOT_REQUIRED, PENDING, VALIDATED, OVERRIDDEN
    
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    farm = relationship("Farm", back_populates="diagnoses")
    risk_assessment = relationship("RiskAssessment", back_populates="diagnosis", uselist=False, cascade="all, delete-orphan")
    expert_review = relationship("ExpertReview", back_populates="diagnosis", uselist=False, cascade="all, delete-orphan")
