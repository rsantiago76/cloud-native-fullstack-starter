from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_register_login_and_work_items():
    r = client.post("/auth/register", json={"username": "demo", "password": "demo1234"})
    assert r.status_code in (200, 400)

    r = client.post("/auth/login", json={"username": "demo", "password": "demo1234"})
    assert r.status_code == 200
    token = r.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    r = client.post("/work-items", json={"title": "first"}, headers=headers)
    assert r.status_code == 200
    item_id = r.json()["id"]

    r = client.get("/work-items", headers=headers)
    assert r.status_code == 200
    assert any(i["id"] == item_id for i in r.json())

    r = client.post(f"/work-items/{item_id}/toggle", headers=headers)
    assert r.status_code == 200
