# cloud-native-fullstack-starter

A production-minded **ALL-in-one** repository that demonstrates **Frontend + Full-Stack + Cloud + DevSecOps** skills using modern, real-world tooling and workflows.

This project shows how to design, build, test, deploy, and operate a cloud-native application end-to-end using **React**, **FastAPI**, **GitHub Actions**, and **AWS (S3, CloudFront, ECS Fargate)** — all provisioned via **Terraform** and secured with **OIDC (no static AWS credentials)**.

---

## 🧭 Architecture Overview

![Cloud-Native Full-Stack Architecture](./docs/cloud_native_fullstack_architecture.png)

**At a glance:**
- **Frontend:** React SPA hosted on S3 and delivered globally via CloudFront
- **Backend:** FastAPI API running on ECS Fargate behind an Application Load Balancer
- **Auth:** JWT-based authentication
- **CI/CD:** GitHub Actions for linting, testing, builds, releases, and deployments
- **IaC:** Terraform for AWS infrastructure (SNS, IAM OIDC, S3, CloudFront, ECS)

---

## 🔁 Request → Auth → Response Flow

![Request → Auth → Response](./docs/cloud_native_fullstack_sequence.png)

**Flow summary:**
1. Browser loads the React app from CloudFront
2. React makes API calls to the backend via ALB
3. FastAPI validates JWT tokens
4. Backend reads/writes data
5. JSON response is returned to the frontend

---

## 🧱 Tech Stack

### Frontend
- React
- Vite
- TypeScript
- Tailwind CSS

### Backend
- FastAPI
- JWT Authentication
- SQLAlchemy
- Pytest / Ruff / Mypy

### CI/CD & DevSecOps
- GitHub Actions (CI, CD, Releases)
- Semantic Versioning (semantic-release)
- OIDC-based AWS access (no long-lived keys)
- SNS notifications on pipeline status

### Cloud & Infrastructure
- AWS S3 + CloudFront (frontend hosting)
- AWS ECS Fargate + ALB (backend API)
- AWS ECR (container images)
- Terraform (Infrastructure as Code)

---

## 🚀 Quick Start (Local Development)

### Backend (dev)
```bash
cd backend
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS / Linux
source .venv/bin/activate

pip install -r requirements.txt
uvicorn app.main:app --reload


