from sqlalchemy.orm import Session
from ..db.models import WorkItem, User

def list_items(db: Session, user: User) -> list[WorkItem]:
    return db.query(WorkItem).filter(WorkItem.owner_id == user.id).order_by(WorkItem.id.desc()).all()

def create_item(db: Session, user: User, title: str) -> WorkItem:
    item = WorkItem(title=title, owner_id=user.id)
    db.add(item)
    db.commit()
    db.refresh(item)
    return item

def toggle_item(db: Session, user: User, item_id: int) -> WorkItem:
    item = db.query(WorkItem).filter(WorkItem.id == item_id, WorkItem.owner_id == user.id).first()
    if not item:
        raise ValueError("Not found")
    item.status = "done" if item.status != "done" else "open"
    db.add(item)
    db.commit()
    db.refresh(item)
    return item
