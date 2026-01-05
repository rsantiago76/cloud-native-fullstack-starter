from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..db.session import get_db
from ..schemas.auth import RegisterIn, LoginIn, TokenOut
from ..services.users import create_user, get_by_username, authenticate
from ..core.security import create_access_token

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/register", response_model=dict)
def register(payload: RegisterIn, db: Session = Depends(get_db)):
    if get_by_username(db, payload.username):
        raise HTTPException(status_code=400, detail="Username already exists")
    create_user(db, payload.username, payload.password, role="user")
    return {"ok": True}

@router.post("/login", response_model=TokenOut)
def login(payload: LoginIn, db: Session = Depends(get_db)):
    user = authenticate(db, payload.username, payload.password)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = create_access_token(subject=user.username, role=user.role)
    return TokenOut(access_token=token)
