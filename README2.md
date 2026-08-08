# Flask Application CI/CD Pipeline using GitHub Actions

## Project Overview

This project demonstrates the implementation of a Continuous Integration and Continuous Deployment (CI/CD) pipeline for a Flask-based Python web application using **GitHub Actions**.

The workflow automates the following tasks:

* Source Code Checkout
* Python Environment Setup
* Dependency Installation
* Unit Testing using Pytest
* Docker Image Build
* Deployment to Staging (on `staging` branch)
* Deployment to Production (on GitHub Release)
* Secure Secret Management using GitHub Secrets

---

# CI/CD Architecture

```text
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
GitHub Actions Runner (Ubuntu)
    │
    ├── Checkout Repository
    ├── Setup Python
    ├── Install Dependencies
    ├── Run Unit Tests
    ├── Build Docker Image
    ├── Deploy to Staging
    └── Deploy to Production
```

---

# Technologies Used

| Technology     | Purpose                |
| -------------- | ---------------------- |
| Python 3.12    | Application Runtime    |
| Flask          | Web Framework          |
| Pytest         | Unit Testing           |
| MongoDB Atlas  | Database               |
| Docker         | Containerization       |
| GitHub Actions | CI/CD Pipeline         |
| GitHub         | Source Code Repository |
| Git            | Version Control        |

---

# Repository Structure

```
.
├── .github
│   └── workflows
│       └── ci-cd.yml
├── app.py
├── Dockerfile
├── requirements.txt
├── test_app.py
├── templates/
├── README.md
└── .gitignore
```

---

# Branch Strategy

The repository contains two branches:-

* **main** – Main development branch
* **staging** – Used for staging deployment

Production deployment is triggered using **GitHub Release Tags**.

---

# GitHub Actions Workflow

Workflow file location:

```
.github/workflows/ci-cd.yml
```

The workflow is triggered on:

* Push to `main`
* Push to `staging`
* Pull Request to `main`
* GitHub Release (Production Deployment)

---

# Workflow Stages

## 1. Checkout Repository

Downloads the latest source code.

---

## 2. Setup Python

Installs Python 3.12 on the GitHub-hosted runner.

---

## 3. Install Dependencies

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

---

## 4. Run Unit Tests

```bash
pytest -v
```

If any test fails, the workflow stops immediately.

---

## 5. Build Docker Image

```bash
docker build -t flask-app .
```

Creates a Docker image for the application.

---

## 6. Deploy to Staging

Runs only when code is pushed to the **staging** branch.

A Docker container is started using the generated image.

---

## 7. Deploy to Production

Runs only when a GitHub Release is published.

The production container is started using the same Docker image.

---

# GitHub Secrets

Sensitive information is stored securely using GitHub Secrets.

Navigate to:

```
Repository
↓
Settings
↓
Secrets and Variables
↓
Actions
```

Create the following secrets:

| Secret Name | Description                     |
| ----------- | ------------------------------- |
| MONGO_URI   | MongoDB Atlas Connection String |
| SECRET_KEY  | Flask Secret Key                |

These values are injected into the workflow during execution.

---

# Running the Application Locally

Create a virtual environment:

```bash
python3 -m venv venv
```

Activate it:

### Linux / WSL

```bash
source venv/bin/activate
```

### Windows

```powershell
venv\Scripts\activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the application:

```bash
python app.py
```

Open:

```
http://localhost:5000
```

---

# Testing

## Run Unit Tests

```bash
pytest -v
```

Expected Result:

* All test cases pass successfully.

---

## Test GitHub Actions

### Test Main Branch

```bash
git checkout main
git add .
git commit -m "Testing GitHub Actions"
git push origin main
```

Expected:

* Workflow starts automatically.
* Checkout
* Install Dependencies
* Run Tests
* Build Docker Image

---

### Test Staging Deployment

```bash
git checkout staging
git add .
git commit -m "Testing Staging Deployment"
git push origin staging
```

Expected:

* Staging deployment step executes successfully.

---

### Test Production Deployment

Create a Git tag:

```bash
git tag v1.0
git push origin v1.0
```

Or create a GitHub Release from the repository.

Expected:

* Production deployment step executes.

---

## Test Failure Scenario

Introduce an error in `test_app.py` or `app.py`.

Example:

* Incorrect assertion
* Syntax error

Push the changes.

Expected:

* Workflow fails during the **Run Unit Tests** stage.
* Docker image is not built.
* Deployment is skipped.

---

## Test Success Scenario

Fix the issue and push again.

Expected:

* All workflow stages complete successfully.

---

# GitHub Actions Page

Workflow execution can be monitored under:

```
GitHub Repository
↓
Actions
```

The Actions page displays:

* Running workflows
* Successful builds
* Failed builds
* Execution logs
* Workflow duration

---

# Required Screenshots

Include the following screenshots with your submission:

* GitHub Repository
* Branches (`main` and `staging`)
* GitHub Secrets
* GitHub Actions Workflow
* Successful Workflow Execution
* Failed Workflow Execution
* Docker Build Logs
* Staging Deployment
* Production Deployment
* Flask Application Running

---

# Submission

Submit the following:

* GitHub Repository URL
* Updated README.md
* Workflow File (`.github/workflows/ci-cd.yml`)
* Screenshots of successful workflow execution

---

# Conclusion

This project demonstrates a complete CI/CD implementation using GitHub Actions for a Flask application. The pipeline automatically checks out the latest source code, installs dependencies, runs unit tests, builds a Docker image, deploys the application based on the branch or release event, and securely manages application secrets using GitHub Secrets.
