from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Float, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base

class PestTrap(Base):
    __tablename__ = "pest_traps"

    id = Column(Integer, primary_key=True, index=True)
    farm_id = Column(Integer, ForeignKey("farms.id"), nullable=False)
    trap_name = Column(String(100), default="North Plot Sticky Trap #01")
    trap_type = Column(String(50), default="Yellow Sticky Trap")
    target_crop = Column(String(50), default="Tomato")
    latitude = Column(Float, default=21.7052)
    longitude = Column(Float, default=71.9715)
    installed_date = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    farm = relationship("Farm", back_populates="pest_traps")
    observations = relationship("PestTrapObservation", back_populates="trap", cascade="all, delete-orphan")

class PestTrapObservation(Base):
    __tablename__ = "pest_trap_observations"

    id = Column(Integer, primary_key=True, index=True)
    trap_id = Column(Integer, ForeignKey("pest_traps.id"), nullable=False)
    image_url = Column(String(255), nullable=False)
    detected_pest = Column(String(100), default="Whitefly (Bemisia tabaci)")
    estimated_count = Column(Integer, default=18)
    pest_pressure = Column(String(20), default="Moderate")  # Low, Moderate, High, Severe
    risk_level = Column(String(20), default="MODERATE")
    confidence = Column(Float, default=0.82)
    advisory = Column(Text, nullable=False)
    model_version = Column(String(50), default="YOLOv8-Trap-Prototype")
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    trap = relationship("PestTrap", back_populates="observations")
