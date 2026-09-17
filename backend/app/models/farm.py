from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base

class Farm(Base):
    __tablename__ = "farms"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    farm_name = Column(String(100), default="Primary Plot")
    survey_number = Column(String(50), default="GUJ/BHAV/2026/894")
    area_acres = Column(Float, default=4.5)
    village = Column(String(100), default="Sihor")
    district = Column(String(100), default="Bhavnagar")
    state = Column(String(100), default="Gujarat")
    latitude = Column(Float, default=21.7051)
    longitude = Column(Float, default=71.9712)
    crop = Column(String(50), default="Tomato")
    variety = Column(String(50), default="Abhinav Hybrid")
    sowing_date = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    crop_stage = Column(String(50), default="Flowering to Fruit Setting")
    soil_type = Column(String(50), default="Deep Black Cotton Clay")
    soil_moisture_pct = Column(Float, default=64.0)
    soil_ph = Column(Float, default=7.4)
    soil_temperature_c = Column(Float, default=26.5)
    verification_status = Column(String(20), default="VERIFIED")
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    owner = relationship("User", back_populates="farms")
    diagnoses = relationship("CropDiagnosis", back_populates="farm", cascade="all, delete-orphan")
    pest_traps = relationship("PestTrap", back_populates="farm", cascade="all, delete-orphan")
    monitoring_records = relationship("MonitoringRecord", back_populates="farm", cascade="all, delete-orphan")
