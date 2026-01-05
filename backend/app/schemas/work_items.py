from pydantic import BaseModel, Field

class WorkItemCreate(BaseModel):
    title: str = Field(min_length=1, max_length=255)

class WorkItemOut(BaseModel):
    id: int
    title: str
    status: str
