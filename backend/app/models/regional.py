from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Float, DateTime
from app.core.database import Base

class RegionalHotspot(Base):
    __tablename__ = "regional_hotspots"

    id = Column(Integer, primary_key=True, index=True)
    crop = Column(String(50), nullable=False)
    disease_or_pest = Column(String(100), nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    confidence = Column(Float, default=0.85)
    risk_level = Column(String(20), default="MODERATE")  # LOW, MODERATE, HIGH
    district = Column(String(100), default="Bhavnagar")
    state = Column(String(100), default="Gujarat")
    affected_farms_count = Column(Integer, default=1)
    status = Column(String(30), default="ACTIVE")
    reported_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
