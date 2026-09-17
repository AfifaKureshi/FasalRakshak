from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.all_schemas import SyncPushRequest, SyncPushResponse
from app.services.sync_manager import sync_manager

router = APIRouter(prefix="/sync", tags=["Offline Sync Engine"])

@router.post("/push", response_model=SyncPushResponse)
def sync_push(
    request: SyncPushRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    items = [item.model_dump() for item in request.items]
    result = sync_manager.process_sync_batch(current_user.id, items, db)
    return SyncPushResponse(**result)

@router.get("/status")
def sync_status(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return {
        "status": "ONLINE",
        "user_id": current_user.id,
        "server_time": "Synchronized"
    }
