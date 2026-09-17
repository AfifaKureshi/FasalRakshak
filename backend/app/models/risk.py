from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Float, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base

class RiskAssessment(Base):
    __tablename__ = "risk_assessments"

    id = Column(Integer, primary_key=True, index=True)
    farm_id = Column(Integer, ForeignKey("farms.id"), nullable=True)
    diagnosis_id = Column(Integer, ForeignKey("crop_diagnoses.id"), nullable=True)
    
    risk_level = Column(String(20), nullable=False)  # LOW, MODERATE, HIGH
    risk_score = Column(Float, nullable=False)        # 0 - 100
    risk_factors = Column(Text, nullable=False)       # JSON string of factors breakdown
    explanation = Column(Text, nullable=False)        # Transparent rationale
    advisory_summary = Column(Text, nullable=False)   # Key immediate action
    
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    diagnosis = relationship("CropDiagnosis", back_populates="risk_assessment")
