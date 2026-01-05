from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from .core.settings import settings
from .db.session import engine, Base
from .api.auth import router as auth_router
from .api.work_items import router as work_items_router
from .api.deps import get_current_user

def create_app() -> FastAPI:
    app = FastAPI(title=settings.app_name)

    # SQLite dev convenience. In real deployments, use Alembic migrations.
    Base.metadata.create_all(bind=engine)

    app.add_middleware(
      CORSMiddleware,
      allow_origins=[o.strip() for o in settings.cors_origins.split(",") if o.strip()],
      allow_credentials=True,
      allow_methods=["*"],
      allow_headers=["*"],
    )

    app.include_router(auth_router)
    app.include_router(work_items_router)

    @app.get("/health")
    def health():
        return {"ok": True}

    @app.get("/me")
    def me(user=Depends(get_current_user)):
        return {"id": user.id, "username": user.username, "role": user.role}

    return app

app = create_app()
