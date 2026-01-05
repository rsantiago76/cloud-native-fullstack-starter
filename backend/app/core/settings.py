from pydantic import BaseModel
import os

class Settings(BaseModel):
    app_name: str = "cloud-native-fullstack-starter"
    env: str = os.getenv("ENV", "dev")
    database_url: str = os.getenv("DATABASE_URL", "sqlite:///./app.db")
    jwt_secret: str = os.getenv("JWT_SECRET", "change_me")
    jwt_access_ttl_min: int = int(os.getenv("JWT_ACCESS_TTL_MIN", "30"))
    cors_origins: str = os.getenv("CORS_ORIGINS", "http://localhost:5173")

settings = Settings()
