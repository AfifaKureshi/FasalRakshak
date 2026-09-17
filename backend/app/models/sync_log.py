from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from app.core.database import Base

class SyncLog(Base):
    __tablename__ = "sync_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    client_sync_id = Column(String(64), nullable=False)
    entity_type = Column(String(50), nullable=False)  # diagnosis, monitoring, pest_trap
    operation = Column(String(20), nullable=False)    # CREATE, UPDATE
    payload_json = Column(Text, nullable=False)
    status = Column(String(20), default="SYNCED")     # SYNCED, FAILED
    synced_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
