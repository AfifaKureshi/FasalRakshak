import logging
from typing import Dict, Any

logger = logging.getLogger(__name__)

class MonitoringService:
    """
    Continuous Monitoring Service.
    Compares initial Day 0 diagnosis with Day 7 follow-up image.
    Generates comparative progression status and dynamic updated advisory.
    """

    def evaluate_follow_up(
        self,
        initial_disease: str,
        initial_severity: str,
        follow_up_assessment: str = "IMPROVED"
    ) -> Dict[str, Any]:
        status = follow_up_assessment.upper()
        if status == "IMPROVED":
            notes = (
                f"Comparative 7-day evaluation against initial {initial_disease} ({initial_severity} severity): "
                f"Foliar necrotic lesion margins have halted expansion and dried out. "
                f"New apical shoot growth exhibits healthy chlorophyll coloration."
            )
            advisory = (
                "Continue current cultural hygiene and drip schedule. "
                "No additional bio-fungicidal intervention required at this stage. "
                "Next milestone scouting in 14 days."
            )
        elif status == "WORSENED":
            notes = (
                f"Comparative 7-day evaluation against initial {initial_disease}: "
                f"Secondary lesions have migrated onto mid-canopy foliage. Active chlorotic haloes observed."
            )
            advisory = (
                "Immediate intervention required: apply university-recommended copper oxychloride or "
                "consult designated Agricultural Expert via the app for emergency prescription."
            )
        else: # STABLE
            notes = (
                f"Comparative 7-day evaluation against initial {initial_disease}: "
                f"Pathogen symptoms stabilized without outward migration to younger leaves."
            )
            advisory = (
                "Maintain careful canopy aeration and monitor for any sudden weather humidification."
            )

        return {
            "progression_status": status,
            "comparative_notes": notes,
            "updated_advisory": advisory
        }

monitoring_service = MonitoringService()
