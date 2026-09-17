from datetime import datetime
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, EmailStr, Field
from app.models.user import UserRole

# --- AUTH SCHEMAS ---
class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserRegister(BaseModel):
    full_name: str
    email: EmailStr
    password: str
    phone: Optional[str] = None
    role: UserRole = UserRole.FARMER
    state: Optional[str] = "Gujarat"
    district: Optional[str] = "Bhavnagar"

class UserOut(BaseModel):
    id: int
    full_name: str
    email: str
    phone: Optional[str] = None
    role: UserRole
    state: str
    district: str
    is_active: bool
    is_verified: bool
    created_at: datetime

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str
    user_name: str
    user_id: int

# --- FARM SCHEMAS ---
class FarmOut(BaseModel):
    id: int
    user_id: int
    farm_name: str
    survey_number: str
    area_acres: float
    village: str
    district: str
    state: str
    latitude: float
    longitude: float
    crop: str
    variety: str
    sowing_date: datetime
    crop_stage: str
    soil_type: str
    soil_moisture_pct: float
    soil_ph: float
    soil_temperature_c: float
    verification_status: str

    class Config:
        from_attributes = True

class FarmUpdate(BaseModel):
    farm_name: Optional[str] = None
    crop: Optional[str] = None
    variety: Optional[str] = None
    crop_stage: Optional[str] = None
    soil_moisture_pct: Optional[float] = None
    soil_ph: Optional[float] = None

# --- DIAGNOSIS SCHEMAS ---
class DiagnosisOut(BaseModel):
    id: int
    farm_id: Optional[int]
    crop_name: str
    image_url: str
    disease_detected: str
    confidence: float
    severity: str
    explanation: str
    recommendations: str
    prevention: str
    model_version: str
    requires_expert_review: bool
    expert_status: str
    created_at: datetime

    class Config:
        from_attributes = True

# --- RISK ASSESSMENT SCHEMAS ---
class RiskFactor(BaseModel):
    factor: str
    impact: str  # High, Moderate, Low
    points: int
    description: str

class RiskAssessmentOut(BaseModel):
    id: Optional[int] = None
    risk_level: str
    risk_score: float
    risk_factors: List[RiskFactor]
    explanation: str
    advisory_summary: str
    created_at: Optional[datetime] = None

# --- PEST TRAP SCHEMAS ---
class PestTrapObservationOut(BaseModel):
    id: int
    trap_id: int
    image_url: str
    detected_pest: str
    estimated_count: int
    pest_pressure: str
    risk_level: str
    confidence: float
    advisory: str
    model_version: str
    created_at: datetime

    class Config:
        from_attributes = True

class PestTrapOut(BaseModel):
    id: int
    farm_id: int
    trap_name: str
    trap_type: str
    target_crop: str
    latitude: float
    longitude: float
    installed_date: datetime
    latest_observation: Optional[PestTrapObservationOut] = None

    class Config:
        from_attributes = True

# --- EXPERT REVIEW SCHEMAS ---
class ExpertReviewCreate(BaseModel):
    diagnosis_id: int
    action: str = "VALIDATE"  # VALIDATE or OVERRIDE
    validated_disease: Optional[str] = None
    expert_notes: str
    expert_recommendations: str

class ExpertReviewOut(BaseModel):
    id: int
    diagnosis_id: int
    farmer_id: int
    farmer_name: Optional[str] = None
    crop_name: Optional[str] = None
    image_url: Optional[str] = None
    original_disease: str
    validated_disease: Optional[str] = None
    confidence: Optional[float] = None
    status: str
    expert_notes: Optional[str] = None
    expert_recommendations: Optional[str] = None
    created_at: datetime
    answered_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# --- CONTINUOUS MONITORING SCHEMAS ---
class MonitoringRecordOut(BaseModel):
    id: int
    farm_id: int
    crop_name: str
    initial_diagnosis_id: Optional[int]
    initial_image_url: str
    initial_disease: str
    initial_severity: str
    initial_date: datetime
    follow_up_image_url: Optional[str] = None
    follow_up_date: Optional[datetime] = None
    progression_status: str
    comparative_notes: Optional[str] = None
    updated_advisory: Optional[str] = None
    is_completed: bool
    created_at: datetime

    class Config:
        from_attributes = True

class MonitoringFollowUpRequest(BaseModel):
    monitoring_id: int
    progression_assessment: Optional[str] = "IMPROVED"  # IMPROVED, STABLE, WORSENED

# --- REGIONAL INTELLIGENCE & OFFICER SCHEMAS ---
class RegionalHotspotOut(BaseModel):
    id: int
    crop: str
    disease_or_pest: str
    latitude: float
    longitude: float
    confidence: float
    risk_level: str
    district: str
    state: str
    affected_farms_count: int
    status: str
    reported_at: datetime

    class Config:
        from_attributes = True

class OfficerDashboardStats(BaseModel):
    monitored_farms: int
    active_alerts: int
    high_risk_zones: int
    pending_expert_reviews: int
    hotspots: List[RegionalHotspotOut]
    disease_distribution: Dict[str, int]
    risk_distribution: Dict[str, int]
    pest_pressure_summary: Dict[str, int]

# --- SYNC SCHEMAS ---
class SyncItem(BaseModel):
    client_id: str
    entity_type: str  # diagnosis, pest_trap, monitoring
    operation: str    # CREATE, UPDATE
    payload: Dict[str, Any]
    created_at: str

class SyncPushRequest(BaseModel):
    items: List[SyncItem]

class SyncItemResult(BaseModel):
    client_id: str
    server_id: Optional[int] = None
    status: str  # SYNCED, FAILED
    error_message: Optional[str] = None

class SyncPushResponse(BaseModel):
    synced_count: int
    failed_count: int
    results: List[SyncItemResult]
    server_timestamp: datetime
