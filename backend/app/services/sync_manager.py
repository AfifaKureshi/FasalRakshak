import logging
from typing import List, Dict, Any
from datetime import datetime, timezone
from sqlalchemy.orm import Session
from app.models.sync_log import SyncLog

logger = logging.getLogger(__name__)

class SyncManager:
    """
    Handles batch offline synchronization requests from the Flutter client.
    Records sync audits and updates records.
    """

    def process_sync_batch(self, user_id: int, items: List[Dict[str, Any]], db: Session) -> Dict[str, Any]:
        results = []
        synced = 0
        failed = 0

        for item in items:
            client_id = item.get("client_id", "")
            entity_type = item.get("entity_type", "")
            operation = item.get("operation", "CREATE")
            payload = item.get("payload", {})

            try:
                # Record sync log
                log = SyncLog(
                    user_id=user_id,
                    client_sync_id=client_id,
                    entity_type=entity_type,
                    operation=operation,
                    payload_json=str(payload),
                    status="SYNCED",
                    synced_at=datetime.now(timezone.utc)
                )
                db.add(log)
                db.commit()
                db.refresh(log)

                results.append({
                    "client_id": client_id,
                    "server_id": log.id,
                    "status": "SYNCED",
                    "error_message": None
                })
                synced += 1
            except Exception as e:
                db.rollback()
                logger.error(f"Sync failed for item {client_id}: {e}")
                results.append({
                    "client_id": client_id,
                    "server_id": None,
                    "status": "FAILED",
                    "error_message": str(e)
                })
                failed += 1

        return {
            "synced_count": synced,
            "failed_count": failed,
            "results": results,
            "server_timestamp": datetime.now(timezone.utc)
        }

sync_manager = SyncManager()
