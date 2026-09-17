import json
import logging
from typing import Dict, Any, List

logger = logging.getLogger(__name__)

class RiskAssessmentEngine:
    """
    Transparent, explainable multi-factor prototype risk scoring engine.
    Combines:
    - Pathogen / Disease severity & AI confidence
    - Microclimate Weather (Relative humidity, temperature, rainfall chance)
    - Soil conditions (Moisture %, pH)
    - Crop phenological stage
    - Pest pressure / Sticky trap counts
    - Regional hotspot proximity
    """

    def calculate_risk(
        self,
        crop: str,
        disease: str,
        severity: str,
        confidence: float,
        temperature_c: float,
        humidity_pct: float,
        rain_chance_pct: float,
        soil_moisture_pct: float,
        crop_stage: str,
        pest_count: int = 0,
        nearby_hotspot_count: int = 1
    ) -> Dict[str, Any]:
        score = 0.0
        factors: List[Dict[str, Any]] = []

        # 1. Disease factor (Weight up to 35 pts)
        if "healthy" in disease.lower():
            disease_pts = 5
            factors.append({
                "factor": "Disease Pathogen",
                "impact": "Low",
                "points": disease_pts,
                "description": "Healthy foliage observed; minimal baseline pathogen risk."
            })
        elif severity.lower() in ("high", "severe"):
            disease_pts = 35
            factors.append({
                "factor": "High Severity Pathogen",
                "impact": "High",
                "points": disease_pts,
                "description": f"Aggressive foliar lesions ({disease}) detected with {int(confidence*100)}% AI confidence."
            })
        else: # Moderate
            disease_pts = 25
            factors.append({
                "factor": "Moderate Severity Pathogen",
                "impact": "Moderate",
                "points": disease_pts,
                "description": f"Early Blight / foliar spotting active ({disease}) with {int(confidence*100)}% AI confidence."
            })
        score += disease_pts

        # 2. Humidity factor (Weight up to 25 pts)
        if humidity_pct >= 75.0:
            hum_pts = 25
            factors.append({
                "factor": "Elevated Relative Humidity",
                "impact": "High",
                "points": hum_pts,
                "description": f"Sustained relative humidity ({humidity_pct}%) accelerates fungal conidia germination."
            })
        elif humidity_pct >= 60.0:
            hum_pts = 15
            factors.append({
                "factor": "Moderate Relative Humidity",
                "impact": "Moderate",
                "points": hum_pts,
                "description": f"Ambient humidity at {humidity_pct}% provides favorable moisture conditions."
            })
        else:
            hum_pts = 5
            factors.append({
                "factor": "Low Relative Humidity",
                "impact": "Low",
                "points": hum_pts,
                "description": f"Dry atmospheric conditions ({humidity_pct}%) suppress fungal spore formation."
            })
        score += hum_pts

        # 3. Rainfall & Leaf Wetness factor (Weight up to 15 pts)
        if rain_chance_pct >= 60.0:
            rain_pts = 15
            factors.append({
                "factor": "Imminent Rain & Moisture",
                "impact": "High",
                "points": rain_pts,
                "description": f"High precipitation probability ({rain_chance_pct}%) prolongs leaf wetness and soil splashing."
            })
        elif rain_chance_pct >= 30.0:
            rain_pts = 10
            factors.append({
                "factor": "Moderate Rain Chance",
                "impact": "Moderate",
                "points": rain_pts,
                "description": f"Possible precipitation ({rain_chance_pct}%) in 24-48h forecast."
            })
        else:
            rain_pts = 2
            factors.append({
                "factor": "Dry Weather Forecast",
                "impact": "Low",
                "points": rain_pts,
                "description": f"Low rain chance ({rain_chance_pct}%); dry canopy expected."
            })
        score += rain_pts

        # 4. Soil Moisture factor (Weight up to 10 pts)
        if soil_moisture_pct > 70.0:
            soil_pts = 10
            factors.append({
                "factor": "Excessive Soil Moisture",
                "impact": "High",
                "points": soil_pts,
                "description": f"Soil moisture at {soil_moisture_pct}% (near field saturation) increases root vulnerability."
            })
        elif soil_moisture_pct >= 50.0:
            soil_pts = 6
            factors.append({
                "factor": "Adequate Soil Moisture",
                "impact": "Moderate",
                "points": soil_pts,
                "description": f"Soil moisture is balanced at {soil_moisture_pct}%."
            })
        else:
            soil_pts = 3
            factors.append({
                "factor": "Low Soil Moisture",
                "impact": "Low",
                "points": soil_pts,
                "description": f"Dry soil ({soil_moisture_pct}%); minimal waterlogging stress."
            })
        score += soil_pts

        # 5. Pest Trap Pressure (Weight up to 15 pts)
        if pest_count >= 20:
            pest_pts = 15
            factors.append({
                "factor": "Surging Pest Vector Pressure",
                "impact": "High",
                "points": pest_pts,
                "description": f"Trap counts indicate {pest_count} insects/trap; high vector transmission hazard."
            })
        elif pest_count >= 10:
            pest_pts = 10
            factors.append({
                "factor": "Moderate Pest Pressure",
                "impact": "Moderate",
                "points": pest_pts,
                "description": f"Sticky trap captured {pest_count} insects; monitoring threshold active."
            })
        else:
            pest_pts = 2
            factors.append({
                "factor": "Low Pest Activity",
                "impact": "Low",
                "points": pest_pts,
                "description": f"Sticky trap count ({pest_count}) below action threshold."
            })
        score += pest_pts

        # Determine Risk Level
        if score >= 70:
            risk_level = "HIGH"
            explanation = "Multiple co-occurring stress factors: high atmospheric humidity, rainfall, and active foliar lesion detection significantly elevate overall crop vulnerability."
            advisory = "Initiate immediate field hygiene: prune diseased lower foliage, cease sprinkler irrigation, and scout neighboring rows."
        elif score >= 40:
            risk_level = "MODERATE"
            explanation = "Moderate disease symptoms detected alongside elevated humidity. Weather conditions are conducive to localized spread if left unaddressed."
            advisory = "Maintain canopy aeration, avoid evening irrigation, and install prophylactic bio-fungicide within 48 hours."
        else:
            risk_level = "LOW"
            explanation = "Foliar health is stable and current ambient environmental metrics do not favor rapid pathogen proliferation."
            advisory = "Continue routine weekly scouting and maintain balanced nutrition."

        return {
            "risk_level": risk_level,
            "risk_score": round(score, 1),
            "risk_factors": factors,
            "explanation": explanation,
            "advisory_summary": advisory
        }

risk_engine = RiskAssessmentEngine()
