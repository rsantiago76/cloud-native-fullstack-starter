from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..db.session import get_db
from ..schemas.work_items import WorkItemCreate, WorkItemOut
from ..api.deps import get_current_user
from ..services.work_items import list_items, create_item, toggle_item

router = APIRouter(prefix="/work-items", tags=["work-items"])

@router.get("", response_model=list[WorkItemOut])
def list_my_items(user=Depends(get_current_user), db: Session = Depends(get_db)):
    items = list_items(db, user)
    return [WorkItemOut(id=i.id, title=i.title, status=i.status) for i in items]

@router.post("", response_model=WorkItemOut)
def create_my_item(payload: WorkItemCreate, user=Depends(get_current_user), db: Session = Depends(get_db)):
    item = create_item(db, user, payload.title)
    return WorkItemOut(id=item.id, title=item.title, status=item.status)

@router.post("/{item_id}/toggle", response_model=WorkItemOut)
def toggle(item_id: int, user=Depends(get_current_user), db: Session = Depends(get_db)):
    try:
        item = toggle_item(db, user, item_id)
    except ValueError:
        raise HTTPException(status_code=404, detail="Not found")
    return WorkItemOut(id=item.id, title=item.title, status=item.status)
