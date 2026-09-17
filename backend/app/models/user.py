import enum
from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Enum, ForeignKey, Text, Float
from sqlalchemy.orm import relationship
from app.core.database import Base

class UserRole(str, enum.Enum):
    FARMER = "farmer"
    EXPERT = "expert"
    OFFICER = "officer"
    ADMIN = "admin"

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(100), nullable=False)
    email = Column(String(120), unique=True, index=True, nullable=False)
    phone = Column(String(20), nullable=True)
    hashed_password = Column(String(255), nullable=False)
    role = Column(Enum(UserRole), default=UserRole.FARMER, nullable=False)
    state = Column(String(50), default="Gujarat")
    district = Column(String(50), default="Bhavnagar")
    is_active = Column(Boolean, default=True)
    is_verified = Column(Boolean, default=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    farms = relationship("Farm", back_populates="owner", cascade="all, delete-orphan")
    expert_reviews = relationship("ExpertReview", back_populates="expert", foreign_keys="[ExpertReview.expert_id]")
