import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.core.config import settings
from app.core.database import engine, Base, SessionLocal
from app.database.seed_data import seed_database
from app.api.auth_routes import router as auth_router
from app.api.farmer_routes import router as farmer_router
from app.api.diagnosis_routes import router as diagnosis_router
from app.api.pest_routes import router as pest_router
from app.api.expert_routes import router as expert_router
from app.api.monitoring_routes import router as monitoring_router
from app.api.officer_routes import router as officer_router
from app.api.sync_routes import router as sync_router

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(name)s: %(message)s")
logger = logging.getLogger("fasalrakshak")

# Create database tables
Base.metadata.create_all(bind=engine)

# Seed initial prototype data
with SessionLocal() as db:
    seed_database(db)

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="FasalRakshak: AI-Powered Crop Health & Risk Intelligence Platform (Hackathon Prototype)",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static uploads
app.mount("/uploads", StaticFiles(directory=str(settings.UPLOAD_DIR)), name="uploads")

# Include routers
app.include_router(auth_router, prefix=settings.API_V1_STR)
app.include_router(farmer_router, prefix=settings.API_V1_STR)
app.include_router(diagnosis_router, prefix=settings.API_V1_STR)
app.include_router(pest_router, prefix=settings.API_V1_STR)
app.include_router(expert_router, prefix=settings.API_V1_STR)
app.include_router(monitoring_router, prefix=settings.API_V1_STR)
app.include_router(officer_router, prefix=settings.API_V1_STR)
app.include_router(sync_router, prefix=settings.API_V1_STR)

# Serve compiled Flutter Web application directly from FastAPI
from pathlib import Path
from fastapi.responses import FileResponse

WEB_DIR = Path(__file__).resolve().parent.parent.parent / "mobile" / "build" / "web"

if WEB_DIR.exists() and (WEB_DIR / "index.html").exists():
    logger.info(f"Mounting compiled Flutter Web release bundle from {WEB_DIR}")
    if (WEB_DIR / "assets").exists():
        app.mount("/assets", StaticFiles(directory=str(WEB_DIR / "assets")), name="flutter_assets")
    if (WEB_DIR / "canvaskit").exists():
        app.mount("/canvaskit", StaticFiles(directory=str(WEB_DIR / "canvaskit")), name="flutter_canvaskit")
    if (WEB_DIR / "icons").exists():
        app.mount("/icons", StaticFiles(directory=str(WEB_DIR / "icons")), name="flutter_icons")

    @app.get("/{full_path:path}")
    async def serve_spa(full_path: str):
        if full_path.startswith(("api", "uploads", "docs", "redoc", "openapi.json")):
            from fastapi import HTTPException
            raise HTTPException(status_code=404, detail="Not Found")
        if full_path:
            file_path = WEB_DIR / full_path
            if file_path.is_file():
                return FileResponse(file_path)
        return FileResponse(WEB_DIR / "index.html")
else:
    @app.get("/")
    def root():
        return {
            "platform": "FasalRakshak",
            "tagline": "From Crop Detection to Early Action",
            "status": "ONLINE",
            "version": "1.0.0",
            "docs": "/docs"
        }

