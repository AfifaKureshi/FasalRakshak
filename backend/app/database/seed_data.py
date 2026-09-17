import json
import logging
from datetime import datetime, timezone, timedelta
from sqlalchemy.orm import Session
from app.core.security import get_password_hash
from app.models.user import User, UserRole
from app.models.farm import Farm
from app.models.diagnosis import CropDiagnosis
from app.models.risk import RiskAssessment
from app.models.expert_review import ExpertReview
from app.models.pest_trap import PestTrap, PestTrapObservation
from app.models.monitoring import MonitoringRecord
from app.models.regional import RegionalHotspot

logger = logging.getLogger(__name__)

def seed_database(db: Session):
    # Check if already seeded
    if db.query(User).filter(User.email == "farmer@fasalrakshak.com").first():
        logger.info("Database already seeded with demo data.")
        return

    logger.info("Seeding FasalRakshak database with realistic demo data...")

    # 1. Users
    farmer = User(
        full_name="Ramesh Patel",
        email="farmer@fasalrakshak.com",
        phone="+91 98250 12345",
        hashed_password=get_password_hash("farmer123"),
        role=UserRole.FARMER,
        state="Gujarat",
        district="Bhavnagar",
        is_active=True,
        is_verified=True
    )
    expert = User(
        full_name="Dr. Meena Sharma",
        email="expert@fasalrakshak.com",
        phone="+91 94260 54321",
        hashed_password=get_password_hash("expert123"),
        role=UserRole.EXPERT,
        state="Gujarat",
        district="Bhavnagar",
        is_active=True,
        is_verified=True
    )
    officer = User(
        full_name="K. V. Joshi",
        email="officer@fasalrakshak.com",
        phone="+91 98790 67890",
        hashed_password=get_password_hash("officer123"),
        role=UserRole.OFFICER,
        state="Gujarat",
        district="Bhavnagar",
        is_active=True,
        is_verified=True
    )
    admin = User(
        full_name="System Administrator",
        email="admin@fasalrakshak.com",
        phone="+91 90000 00000",
        hashed_password=get_password_hash("admin123"),
        role=UserRole.ADMIN,
        state="Gujarat",
        district="Gandhinagar",
        is_active=True,
        is_verified=True
    )

    db.add_all([farmer, expert, officer, admin])
    db.commit()
    db.refresh(farmer)
    db.refresh(expert)
    db.refresh(officer)
    db.refresh(admin)

    # 2. Farmer's Farm
    farm = Farm(
        user_id=farmer.id,
        farm_name="Patel Krishi Farm (Sihor)",
        survey_number="GUJ/BHAV/2026/894",
        area_acres=4.5,
        village="Sihor",
        district="Bhavnagar",
        state="Gujarat",
        latitude=21.7051,
        longitude=71.9712,
        crop="Tomato",
        variety="Abhinav Hybrid",
        sowing_date=datetime.now(timezone.utc) - timedelta(days=45),
        crop_stage="Flowering to Fruit Setting",
        soil_type="Deep Black Cotton Clay",
        soil_moisture_pct=64.0,
        soil_ph=7.4,
        soil_temperature_c=26.5,
        verification_status="VERIFIED"
    )
    db.add(farm)
    db.commit()
    db.refresh(farm)

    # 3. Diagnoses
    # Case 1: Low-confidence case needing expert review (for hackathon demo flow!)
    diag_low = CropDiagnosis(
        farm_id=farm.id,
        crop_name="Tomato",
        image_url="/uploads/demo_tomato_early_blight.png",
        disease_detected="Tomato Early Blight",
        confidence=0.54, # < 70% threshold!
        severity="Moderate",
        explanation="Preliminary AI feature map matches early foliar necrotic spots with 54% confidence. Target-like ring pattern is partially obscured.",
        recommendations="Prune affected leaves, avoid overhead furrow splash, await senior expert validation.",
        prevention="Practice 2-season crop rotation away from solanaceous plants.",
        model_version="EfficientNet-B0",
        requires_expert_review=True,
        expert_status="PENDING",
        created_at=datetime.now(timezone.utc) - timedelta(hours=2)
    )

    # Case 2: Historical high confidence case (7 days ago)
    diag_history = CropDiagnosis(
        farm_id=farm.id,
        crop_name="Tomato",
        image_url="/uploads/demo_tomato_day0.png",
        disease_detected="Tomato Early Blight",
        confidence=0.87,
        severity="Moderate",
        explanation="Classic concentric concentric rings detected on lower leaf canopy.",
        recommendations="Prune affected lower leaves, apply Trichoderma harzianum bio-agent.",
        prevention="Ensure adequate plant spacing for airflow.",
        model_version="EfficientNet-B0",
        requires_expert_review=False,
        expert_status="NOT_REQUIRED",
        created_at=datetime.now(timezone.utc) - timedelta(days=7)
    )

    db.add_all([diag_low, diag_history])
    db.commit()
    db.refresh(diag_low)
    db.refresh(diag_history)

    # 4. Risk Assessment for the low-confidence case
    risk_factors = [
        {"factor": "Disease Pathogen", "impact": "Moderate", "points": 25, "description": "Early Blight foliar symptoms detected with 54% AI confidence."},
        {"factor": "Elevated Humidity", "impact": "High", "points": 25, "description": "Sustained ambient humidity at 78% accelerates fungal conidial spore germination."},
        {"factor": "Imminent Rain & Moisture", "impact": "High", "points": 15, "description": "65% precipitation probability in 24h forecast increases leaf wetness duration."},
        {"factor": "Soil Moisture", "impact": "Moderate", "points": 6, "description": "Soil moisture is 64% in black cotton soil."},
        {"factor": "Pest Vector Activity", "impact": "Moderate", "points": 10, "description": "Sticky trap indicates 18 Whiteflies in proximity plot."}
    ]
    risk = RiskAssessment(
        farm_id=farm.id,
        diagnosis_id=diag_low.id,
        risk_level="HIGH",
        risk_score=81.0,
        risk_factors=json.dumps(risk_factors),
        explanation="High atmospheric humidity (78%) coupled with 65% precipitation probability and active foliar lesion detection substantially elevates pathogen vulnerability.",
        advisory_summary="Initiate lower canopy leaf pruning, avoid furrow water splashing, and consult expert recommendation."
    )
    db.add(risk)

    # 5. Pending Expert Review for Case 1
    review = ExpertReview(
        diagnosis_id=diag_low.id,
        farmer_id=farmer.id,
        expert_id=expert.id,
        original_disease="Tomato Early Blight",
        status="PENDING",
        created_at=datetime.now(timezone.utc) - timedelta(hours=2)
    )
    db.add(review)

    # 6. Pest Trap and Observation
    trap = PestTrap(
        farm_id=farm.id,
        trap_name="South Block Sticky Trap #01",
        trap_type="Yellow Sticky Trap",
        target_crop="Tomato",
        latitude=21.7053,
        longitude=71.9716,
        installed_date=datetime.now(timezone.utc) - timedelta(days=14)
    )
    db.add(trap)
    db.commit()
    db.refresh(trap)

    obs = PestTrapObservation(
        trap_id=trap.id,
        image_url="/uploads/demo_trap_yellow.png",
        detected_pest="Whitefly (Bemisia tabaci)",
        estimated_count=18,
        pest_pressure="Moderate",
        risk_level="MODERATE",
        confidence=0.84,
        advisory="Observed 18 Whiteflies on trap. Moderate pressure. Recommend 5% Neem Seed Kernel Extract (NSKE) spray.",
        model_version="YOLOv8-Trap-Prototype",
        created_at=datetime.now(timezone.utc) - timedelta(days=1)
    )
    db.add(obs)

    # 7. Continuous Monitoring Record (Day 0 vs Day 7)
    monitor = MonitoringRecord(
        farm_id=farm.id,
        crop_name="Tomato",
        initial_diagnosis_id=diag_history.id,
        initial_image_url="/uploads/demo_tomato_day0.png",
        initial_disease="Tomato Early Blight",
        initial_severity="Moderate",
        initial_date=datetime.now(timezone.utc) - timedelta(days=7),
        follow_up_image_url="/uploads/demo_tomato_day7.png",
        follow_up_date=datetime.now(timezone.utc),
        progression_status="IMPROVED",
        comparative_notes="Comparative 7-day evaluation against initial Early Blight: Necrotic spot margins have dried up following lower leaf pruning and Trichoderma application. New apical flush is vibrant green.",
        updated_advisory="Foliar condition is improving. Continue standard drip fertigation. Next check in 7 days.",
        is_completed=True,
        created_at=datetime.now(timezone.utc) - timedelta(days=7)
    )
    db.add(monitor)

    # 8. Regional Hotspots for Agriculture Officer GIS Dashboard
    hotspots = [
        RegionalHotspot(crop="Tomato", disease_or_pest="Tomato Early Blight", latitude=21.7051, longitude=71.9712, confidence=0.87, risk_level="HIGH", district="Bhavnagar", affected_farms_count=8, status="ACTIVE"),
        RegionalHotspot(crop="Cotton", disease_or_pest="Bacterial Blight", latitude=21.7600, longitude=72.0100, confidence=0.91, risk_level="HIGH", district="Bhavnagar", affected_farms_count=14, status="ACTIVE"),
        RegionalHotspot(crop="Cotton", disease_or_pest="Pink Bollworm", latitude=21.6800, longitude=71.9300, confidence=0.82, risk_level="MODERATE", district="Bhavnagar", affected_farms_count=6, status="ACTIVE"),
        RegionalHotspot(crop="Groundnut", disease_or_pest="Tikka Disease", latitude=21.5222, longitude=70.4579, confidence=0.88, risk_level="MODERATE", district="Junagadh", affected_farms_count=5, status="ACTIVE"),
        RegionalHotspot(crop="Castor", disease_or_pest="Semilooper", latitude=22.3039, longitude=70.8022, confidence=0.79, risk_level="LOW", district="Rajkot", affected_farms_count=3, status="MONITORING"),
        RegionalHotspot(crop="Tomato", disease_or_pest="Leaf Mold", latitude=21.6032, longitude=71.2221, confidence=0.85, risk_level="MODERATE", district="Amreli", affected_farms_count=4, status="ACTIVE"),
    ]
    db.add_all(hotspots)
    db.commit()

    logger.info("Demo data successfully seeded!")
