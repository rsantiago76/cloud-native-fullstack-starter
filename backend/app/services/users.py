from sqlalchemy.orm import Session
from ..db.models import User
from ..core.security import hash_password, verify_password

def get_by_username(db: Session, username: str) -> User | None:
    return db.query(User).filter(User.username == username).first()

def create_user(db: Session, username: str, password: str, role: str = "user") -> User:
    u = User(username=username, password_hash=hash_password(password), role=role)
    db.add(u)
    db.commit()
    db.refresh(u)
    return u

def authenticate(db: Session, username: str, password: str) -> User | None:
    u = get_by_username(db, username)
    if not u:
        return None
    if not verify_password(password, u.password_hash):
        return None
    return u
