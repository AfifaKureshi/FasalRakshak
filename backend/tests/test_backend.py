import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.core.database import SessionLocal
from app.models.user import User, UserRole
from app.api.auth_routes import login
from app.api.farmer_routes import get_farmer_dashboard
from app.api.diagnosis_routes import analyze_crop
from app.api.expert_routes import get_pending_reviews, submit_expert_review
from app.api.officer_routes import get_officer_stats, generate_officer_report
from app.schemas.all_schemas import ExpertReviewCreate
from fastapi.security import OAuth2PasswordRequestForm

def run_tests():
    print("--- 1. Testing Database & Seed Users ---")
    db = SessionLocal()
    farmer = db.query(User).filter(User.email == "farmer@fasalrakshak.com").first()
    expert = db.query(User).filter(User.email == "expert@fasalrakshak.com").first()
    officer = db.query(User).filter(User.email == "officer@fasalrakshak.com").first()
    print("Found farmer:", farmer.full_name, farmer.role)
    print("Found expert:", expert.full_name, expert.role)
    print("Found officer:", officer.full_name, officer.role)

    print("\n--- 2. Testing Farmer Dashboard ---")
    dash = get_farmer_dashboard(current_user=farmer, db=db)
    print("Farm:", dash["farm_name"], "| Current Risk:", dash["current_risk_level"], "| Score:", dash["current_risk_score"])
    print("Alerts count:", len(dash["alerts"]))

    print("\n--- 3. Testing Crop Disease Analysis ---")
    diag_res = analyze_crop(crop_name="Tomato", force_low_confidence=True, file=None, current_user=farmer, db=db)
    print("Diagnosis Disease:", diag_res["diagnosis"].disease_detected)
    print("Confidence:", diag_res["diagnosis"].confidence)
    print("Requires Expert Review:", diag_res["diagnosis"].requires_expert_review)
    print("Risk Level:", diag_res["risk_assessment"]["risk_level"], "| Score:", diag_res["risk_assessment"]["risk_score"])

    print("\n--- 4. Testing Expert Review Queue & Validation ---")
    pending = get_pending_reviews(current_user=expert, db=db)
    print("Pending reviews count for expert:", len(pending))
    first_pending = pending[0]
    print(f"Reviewing Diagnosis ID #{first_pending.diagnosis_id}: Original = {first_pending.original_disease}")

    # Validate the case
    review_in = ExpertReviewCreate(
        diagnosis_id=first_pending.diagnosis_id,
        action="VALIDATE",
        expert_notes="Concentric target-like zonation on basal foliage is pathognomonic for Alternaria solani. Spores isolated in humid microclimate.",
        expert_recommendations="Prune lower 30cm foliage to eliminate bottom leaf splash. Maintain 4-day interval drip irrigation. Apply Trichoderma formulation."
    )
    rev_res = submit_expert_review(review_in=review_in, current_user=expert, db=db)
    print("Review Submission Result:", rev_res)

    print("\n--- 5. Testing Agriculture Officer Regional Intelligence ---")
    stats = get_officer_stats(current_user=officer, db=db)
    print("Officer Monitored Farms:", stats.monitored_farms)
    print("Active Alerts:", stats.active_alerts)
    print("Hotspots count:", len(stats.hotspots))
    print("Disease Distribution:", stats.disease_distribution)

    report = generate_officer_report(district="Bhavnagar", crop="Tomato", current_user=officer, db=db)
    print("Report ID:", report["report_id"], "| High Priority Interventions:", len(report["high_priority_interventions"]))

    db.close()
    print("\n ALL BACKEND TESTS PASSED SUCCESSFULLY!")

if __name__ == "__main__":
    run_tests()
