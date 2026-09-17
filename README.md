# FASALRAKSHAK: AI-Powered Crop Health & Risk Intelligence Platform

> **"From Crop Detection to Early Action"**
> A hackathon prototype demonstrating the complete agricultural journey:
> Farmer → Crop/Pest Image → AI Analysis → Confidence Check → Risk Assessment → Expert Validation → Advisory → Continuous Monitoring → Regional Intelligence → Agriculture Officer Dashboard.

---

## System Architecture

```
FASALRAKSHAK
├── mobile/                   # Flutter Mobile App (Android/iOS/Web/Windows)
│   ├── lib/
│   │   ├── core/             # Colors (#F3EFE4, #183B32, etc.), Theme, Localization (EN, HI, GU)
│   │   ├── data/             # Local storage, pending_sync table, cached advisories
│   │   ├── services/         # AI Disease, Risk Engine, Weather, Voice, Sync
│   │   └── features/         # Farmer, Expert, Officer, Admin Dashboards, Monitoring, Pest Trap
│   └── pubspec.yaml
│
└── backend/                  # FastAPI REST Backend
    ├── app/
    │   ├── api/              # Auth, Farmer, Diagnosis, Pest, Expert, Monitoring, Officer, Sync
    │   ├── ml/crop_disease/  # Real EfficientNet-B0 weights (plantvillage_38.pth) + Mock fallback
    │   ├── services/         # Multi-factor Risk Engine, Weather, Sync Manager
    │   ├── models/           # SQLAlchemy models (User, Farm, Diagnosis, Risk, Review, Hotspots)
    │   └── database/         # Session & realistic Gujarat seed data (Sihor, Bhavnagar)
    └── requirements.txt
```

---

## 1-Click Demo Accounts (Pre-Seeded)

| Role | Name | Email | Password | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Farmer** | Ramesh Patel | `farmer@fasalrakshak.com` | `farmer123` | Patel Krishi Farm, Sihor, Bhavnagar (Tomato & Cotton) |
| **Expert** | Dr. Meena Sharma | `expert@fasalrakshak.com` | `expert123` | Senior Plant Pathologist (Clinical Validation Queue) |
| **Officer** | K. V. Joshi | `officer@fasalrakshak.com` | `officer123` | District Agriculture Officer (Regional GIS Hotspots) |
| **Admin** | System Admin | `admin@fasalrakshak.com` | `admin123` | Platform Operations & Offline Simulation Controls |

---

## Hackathon Demonstration Walkthrough Flow

1. **Farmer Persona Login**:
   - Tap **"Demo Farmer (Ramesh Patel)"** on the Login screen.
   - Observe the **Farmer Dashboard**: Farm name, Active Crop (Tomato), Multi-Factor Risk Badge (`Moderate Risk`), live/cached Weather, and Sync Status (`✓ Synced`).

2. **Check Crop Health & Image Guidance**:
   - Tap **"Check Crop Health"**.
   - Review image capture guidance checklist (lighting, leaf centered, avoid blur, affected area).
   - Select preset sample leaf: **"Tomato Early Blight (Low Confidence Demo Case)"**.
   - Tap **"Analyze Crop Health"**.

3. **AI Analysis & Confidence Check**:
   - Model: `EfficientNet-B0`.
   - Result: *Tomato Early Blight*.
   - Confidence Check: Confidence is **54%** (<70% threshold).
   - System displays: **"Expert Review Recommended"** banner and automatically routes the case to the Agricultural Specialist.

4. **Explainable Multi-Factor Risk Engine**:
   - Tap **"View Multi-Factor Risk Assessment"**.
   - Inspect **"Why this risk?"** transparent point breakdown:
     - Elevated Humidity (>75%): `+25 pts`
     - Imminent Rain Forecast (65%): `+15 pts`
     - Foliar Pathogen Lesions: `+25 pts`
     - Pest Vector Activity (18 Whiteflies): `+10 pts`
     - Soil Moisture (64%): `+6 pts`
   - Overall Composite Score: `81 / 100` (`HIGH RISK`).
   - Actionable cultural advisory: Prune lower canopy leaves, avoid furrow splashing, apply bio-agent.

5. **Expert Review & Clinical Validation**:
   - Tap the persona switcher icon in the app bar and select **"Expert"** (Dr. Meena Sharma).
   - Open pending review for Ramesh Patel.
   - Tap **"Review & Validate Case"**.
   - Select action (Confirm / Override) and add clinical recommendations. Tap **"Submit Validation"**.
   - Switch back to **"Farmer"**: observe the new notification: *"Expert Recommendation Received"* and diagnosis verified.

6. **Continuous Monitoring (Day 0 vs Day 7)**:
   - Tap **"7-Day Monitoring"**.
   - View Day 0 (Baseline) vs Day 7 (Follow-up) side-by-side.
   - Evaluate outcome: **IMPROVED** (necrotic spot margins halted, new apical flush vibrant green).
   - Receives dynamic updated advisory.

7. **Pest Trap Surveillance**:
   - Open **"Pest Trap"** from dashboard.
   - View sticky trap analysis: 18 Whiteflies detected, Moderate pest pressure, IPM advisory.

8. **Agriculture Officer Regional Intelligence & Hotspots**:
   - Switch persona to **"Officer"** (K. V. Joshi).
   - Inspect Regional GIS Hotspot Map showing active disease clusters across Gujarat (Sihor, Palitana, Mahuva, Bhavnagar) color-coded: Green (Low), Yellow (Moderate), and Red (High).
   - Review disease trend charts.
   - Tap **"Compile Report"** to generate an official district advisory directive.

9. **Offline-First Resilience**:
   - Open Admin / Menu -> Toggle **"Simulate Offline Mode"**.
   - App displays **"OFFLINE MODE"** banner.
   - Perform diagnosis locally -> Sync badge changes to **"↻ Pending Sync (1 item)"**.
   - Toggle offline mode off -> Tap **"Sync Now"** -> Batch pushes to FastAPI backend and marks **"✓ Synced"**.

10. **Voice Commands & Multilingual Support**:
    - Tap the **Mic** button.
    - Select or speak commands in **English**, **Hindi (`हिन्दी`)**, or **Gujarati (`ગુજરાતી`)**.
    - Toggle language via the app bar dropdown (`EN`, `HI`, `GU`).

---

## Running the Prototype Locally

### 1. Backend (FastAPI)
```powershell
cd backend
python run.py
```
Backend runs at `http://127.0.0.1:8000`. Swagger API docs at `http://127.0.0.1:8000/docs`.

### 2. Mobile App (Flutter)
```powershell
cd mobile
flutter run -d chrome
# or for windows desktop:
flutter run -d windows
```
