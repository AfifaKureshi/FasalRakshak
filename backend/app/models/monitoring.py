from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Float, Text, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from app.core.database import Base

class MonitoringRecord(Base):
    __tablename__ = "monitoring_records"

    id = Column(Integer, primary_key=True, index=True)
    farm_id = Column(Integer, ForeignKey("farms.id"), nullable=False)
    crop_name = Column(String(50), nullable=False)
    
    # Day 0 Initial Diagnosis
    initial_diagnosis_id = Column(Integer, ForeignKey("crop_diagnoses.id"), nullable=True)
    initial_image_url = Column(String(255), nullable=False)
    initial_disease = Column(String(100), nullable=False)
    initial_severity = Column(String(20), default="Moderate")
    initial_date = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    # Day 7 Follow-up Observation
    follow_up_image_url = Column(String(255), nullable=True)
    follow_up_date = Column(DateTime, nullable=True)
    
    # Comparative Assessment
    progression_status = Column(String(20), default="PENDING")  # PENDING, IMPROVED, STABLE, WORSENED
    comparative_notes = Column(Text, nullable=True)
    updated_advisory = Column(Text, nullable=True)
    is_completed = Column(Boolean, default=False)
    
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    farm = relationship("Farm", back_populates="monitoring_records")
