# Jenkins CI/CD Pipeline for Flask Application

## Project Overview

This project demonstrates a complete Continuous Integration and Continuous Deployment (CI/CD) pipeline for a Flask-based Python web application using Jenkins.

The pipeline automates the following tasks:

* Source Code Checkout from GitHub
* Dependency Installation
* Unit Testing using Pytest
* Docker Image Build
* Docker Image Deployment
* Automatic Trigger using GitHub Webhook
* Email Notification on Build Success/Failure

---

# Project Architecture

```
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    │ Webhook
    ▼
Jenkins (Docker Container)
    │
    ├── Checkout Source Code
    ├── Install Dependencies
    ├── Run Unit Tests
    ├── Build Docker Image
    ├── Deploy Docker Container
    └── Send Email Notification
    │
    ▼
Flask Application
```

---

# Technologies Used

| Technology    | Purpose                |
| ------------- | ---------------------- |
| Python 3      | Application Runtime    |
| Flask         | Web Framework          |
| Pytest        | Unit Testing           |
| MongoDB Atlas | Database               |
| Docker        | Containerization       |
| Jenkins       | CI/CD Automation       |
| GitHub        | Source Code Repository |
| ngrok         | Expose Local Jenkins   |
| Git           | Version Control        |

---

# Project Structure

```
.
├── app.py
├── Dockerfile
├── Jenkinsfile
├── requirements.txt
├── test_app.py
├── start_flask.sh
├── templates
│   ├── add_student.html
│   ├── base.html
│   ├── index.html
│   └── update_student.html
├── README.md
└── LICENSE
```

---

# Prerequisites

Install the following:

* Docker Desktop
* Jenkins (Docker Container)
* Git
* Python 3
* MongoDB Atlas Account
* GitHub Account
* ngrok

---

# Jenkins Setup

## Pull Jenkins Image

```bash
docker pull jenkins/jenkins:lts
```

---

## Create Jenkins Volume

```bash
docker volume create jenkins_home
```

---

## Run Jenkins Container

```bash
docker run -d \
--name jenkins \
-p 8080:8080 \
-p 50000:50000 \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
jenkins/jenkins:lts
```

---

## Access Jenkins

```
http://localhost:8080
```

---

# Install Required Jenkins Plugins

* Git
* Docker Pipeline
* Pipeline
* GitHub
* Email Extension
* Credentials Binding

---

# Install Required Packages inside Jenkins Container

Enter Jenkins container

```bash
docker exec -it jenkins bash
```

Update packages

```bash
apt update
```

Install Python

```bash
apt install -y python3 python3-pip python3-venv
```

Verify

```bash
python3 --version
pip3 --version
```

---

# Configure Docker in Jenkins

Install Docker CLI inside Jenkins container.

Verify Docker:

```bash
docker version
```

---

# Clone Repository

```bash
git clone <your-github-fork-url>
```

---

# Jenkins Credentials

Create the following credentials.

## Secret Text

ID

```
mongo-uri
```

Value

```
MongoDB Atlas Connection String
```

---

## Secret Text

ID

```
secret-key
```

Value

```
Flask Secret Key
```

---

# Jenkins Pipeline Stages

## Stage 1

Checkout Source Code

```
checkout scm
```

Downloads the latest code from GitHub.

---

## Stage 2

Install Dependencies

```
python3 -m venv venv

source venv/bin/activate

pip install -r requirements.txt
```

---

## Stage 3

Run Unit Tests

```
pytest -v
```

The pipeline stops immediately if any test fails.

---

## Stage 4

Build Docker Image

```
docker build -t flask-app .
```

---

## Stage 5

Deploy Docker Container

Stop old container

```bash
docker rm -f flask-container
```

Run new container

```bash
docker run -d \
--name flask-container \
-p 5000:5000 \
flask-app
```

---

## Stage 6

Email Notification

Email notifications are sent automatically for

* Successful Builds
* Failed Builds

---

# Docker Commands

Build image

```bash
docker build -t flask-app .
```

Run container

```bash
docker run -d --name flask-container -p 5000:5000 flask-app
```

List containers

```bash
docker ps
```

Stop container

```bash
docker stop flask-container
```

Remove container

```bash
docker rm flask-container
```

List images

```bash
docker images
```

---

# GitHub Webhook Configuration

Repository

```
Settings

↓

Webhooks

↓

Add Webhook
```

Payload URL

```
https://<ngrok-url>/github-webhook/
```

Content Type

```
application/json
```

Events

```
Just the push event
```

---

# ngrok Setup

Download ngrok.

Authenticate

```bash
ngrok config add-authtoken <YOUR_AUTH_TOKEN>
```

Expose Jenkins

```bash
ngrok http 8080
```

Copy the generated HTTPS URL into GitHub Webhooks.

---


# Email Notifications

To receive email notifications for every successful or failed pipeline execution, Jenkins Email Extension Plugin was configured with Gmail SMTP.

### Prerequisites

* Install the following Jenkins plugins:

  * Email Extension Plugin
  * Mailer Plugin
* Enable **2-Step Verification** on the Gmail account.
* Generate a **Google App Password** from the Google Account security settings.
* Configure SMTP settings in **Manage Jenkins → System → Extended E-mail Notification**.

### SMTP Configuration

| Setting        | Value                                |
| -------------- | ------------------------------------ |
| SMTP Server    | smtp.gmail.com                       |
| SMTP Port      | 587                                  |
| Authentication | Gmail Username + Google App Password |
| Security       | TLS Enabled                          |

### Jenkins Credentials

The following credentials were added securely in Jenkins:

| Credential ID | Purpose                      |
| ------------- | ---------------------------- |
| `gmail-smtp`  | Gmail SMTP authentication    |
| `mongo-uri`   | MongoDB connection string    |
| `secret-key`  | Flask application secret key |

Sensitive information is stored using Jenkins Credentials and is not hardcoded in the repository.

### Pipeline Notifications

A `post` section was added to the `Jenkinsfile` to send email notifications after every pipeline execution.

* **Success Notification**

  * Sent when all stages (Checkout, Install Dependencies, Unit Tests, Docker Build, and Deploy) complete successfully.
  * Includes:

    * Job Name
    * Build Number
    * Build Status
    * Build URL

* **Failure Notification**

  * Sent when any stage fails.
  * Includes:

    * Job Name
    * Build Number
    * Failure Status
    * Build URL for troubleshooting

### Jenkinsfile Post Section

The notification logic is implemented using the `emailext` step provided by the Jenkins Email Extension Plugin.

### Verification

1. Push changes to the GitHub repository.
2. GitHub Webhook triggers the Jenkins pipeline.
3. Pipeline executes all stages.
4. Upon completion:

   * A **SUCCESS** email is sent if all stages pass.
   * A **FAILED** email is sent if any stage fails.
5. Verify the notification in the configured Gmail inbox.

This implementation satisfies the assignment requirement of sending automated email notifications for both successful and failed CI/CD pipeline executions.


---



# Running the Application Locally

Create virtual environment

```bash
python3 -m venv venv
```

Activate

```bash
source venv/bin/activate
```

Install dependencies

```bash
pip install -r requirements.txt
```

Run

```bash
python app.py
```

Application URL

```
http://localhost:5000
```

---

# Running Tests

```bash
pytest -v
```

---

# Environment Variables

The application requires:

```
MONGO_URI

SECRET_KEY
```

For local development, these values are stored in a `.env` file.

For Jenkins, the values are securely managed using Jenkins Credentials and injected as environment variables during pipeline execution.

---



# Testing the CI/CD Pipeline

The following tests were performed to verify that the Jenkins CI/CD pipeline works correctly.

---

## Test 1: Verify Flask Application Locally

Activate the virtual environment:

```bash
source venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the Flask application:

```bash
python app.py
```

Open the application in a browser:

```text
http://localhost:5000
```

**Expected Result**

* Flask application starts successfully.
* Home page is displayed.
* CRUD operations work correctly.

---

## Test 2: Run Unit Tests Locally

Execute:

```bash
pytest -v
```

**Expected Result**

* All test cases pass successfully.
* Pytest displays a summary with all tests marked as PASSED.

---

## Test 3: Build Docker Image

Build the Docker image:

```bash
docker build -t flask-app .
```

Verify the image:

```bash
docker images
```

**Expected Result**

* Docker image named `flask-app` is created successfully.

---

## Test 4: Run Docker Container

Run the container:

```bash
docker run -d \
--name flask-container \
-p 5000:5000 \
flask-app
```

Verify:

```bash
docker ps
```

Open:

```text
http://localhost:5000
```

**Expected Result**

* Flask application is accessible from the browser.
* Container status is **Up**.

---

## Test 5: Verify Jenkins Pipeline Manually

Open Jenkins.

Select the pipeline job.

Click:

```text
Build Now
```

Monitor the Console Output.

**Expected Result**

All stages execute successfully.

```
✓ Checkout Source Code

✓ Install Dependencies

✓ Run Unit Tests

✓ Build Docker Image

✓ Deploy Docker Container

✓ Email Notification
```

Build status should be **SUCCESS**.

---

## Test 6: Verify GitHub Webhook Trigger

Modify any source file.

Example:

```text
README.md
```

Commit the changes:

```bash
git add .
git commit -m "Testing Jenkins Webhook"
git push origin main
```

Open Jenkins Dashboard.

**Expected Result**

* GitHub sends a webhook request.
* Jenkins automatically starts a new build.
* No manual intervention is required.

---

## Test 7: Verify ngrok Tunnel

Start ngrok:

```bash
ngrok http 8080
```

Copy the HTTPS URL.

Configure the same URL in the GitHub Webhook.

Verify webhook delivery under:

```text
GitHub Repository

↓

Settings

↓

Webhooks

↓

Recent Deliveries
```

**Expected Result**

* Delivery status should be **200 OK**.
* Jenkins pipeline starts automatically.

---

## Test 8: Verify Docker Deployment

Check running containers:

```bash
docker ps
```

View logs:

```bash
docker logs flask-container
```

**Expected Result**

* Flask container is running.
* No runtime errors are present.
* Application is accessible at `http://localhost:5000`.

---

## Test 9: Verify MongoDB Atlas Connectivity

Ensure the current public IP address is added to the MongoDB Atlas **Network Access** list.

Run the Flask application or trigger the Jenkins pipeline.

**Expected Result**

* Application connects successfully to MongoDB Atlas.
* Student records are created, updated, retrieved, and deleted successfully.

---

## Test 10: Verify Jenkins Credentials

Confirm that the following credentials are configured in Jenkins:

* `mongo-uri`
* `secret-key`

Trigger a pipeline build.

**Expected Result**

* Environment variables are injected successfully.
* Application starts without `.env` being present in the GitHub repository.
* No `MONGO_URI` or `SECRET_KEY` related errors occur.

---

## Test 11: Verify Pipeline Failure

Introduce a deliberate error.

Examples:

* Add an incorrect assertion in `test_app.py`
* Introduce a syntax error in `app.py`

Commit and push the changes:

```bash
git add .
git commit -m "Testing pipeline failure"
git push origin main
```

**Expected Result**

* Jenkins stops at the **Run Unit Tests** stage.
* Docker image is **not** built.
* Deployment stage is skipped.
* Build status is **FAILED**.
* Failure notification email is sent.

---

## Test 12: Verify Successful Pipeline After Fix

Remove the intentional error.

Commit and push the fix:

```bash
git add .
git commit -m "Fixed unit test"
git push origin main
```

**Expected Result**

* All pipeline stages complete successfully.
* Docker image is rebuilt.
* Application is redeployed.
* Success notification email is sent.

---

# Expected Pipeline Execution Flow

```text
Developer
     │
     │ git push
     ▼
GitHub Repository
     │
     │ Webhook
     ▼
Jenkins Pipeline
     │
     ├── Checkout Source Code
     ├── Install Dependencies
     ├── Run Unit Tests
     ├── Build Docker Image
     ├── Deploy Docker Container
     └── Send Email Notification
     │
     ▼
Flask Application Running Successfully
```


---

# Screenshots

Include the following screenshots in the repository:

* Jenkins Dashboard
* Jenkins Pipeline Stages
* Successful Build
* Failed Build
* GitHub Webhook Configuration
* ngrok Tunnel
* Running Flask Application
* Docker Containers
* Jenkins Console Output

---

# Repository

Forked Repository:

```
https://github.com/<your-username>/flask_Practice
```

---

# Conclusion

This project demonstrates the implementation of a complete CI/CD pipeline using Jenkins for a Flask web application. The pipeline automatically checks out code from GitHub, installs dependencies, executes unit tests, builds a Docker image, deploys the application as a Docker container, and sends build notifications. GitHub Webhooks and ngrok are used to automate pipeline execution on every push to the main branch.
