# Deploying a Simple Python Web Application to Azure App Service

This guide provides step-by-step instructions for deploying a Python-based web application to **Azure App Service**.

---

## 🧰 Prerequisites

- Azure CLI installed (`az` command)
- Python 3.7+ installed
- Git installed
- Azure subscription

---

## 🏗️ Step 1: Create Azure App Service Resources

### 1.1 Login to Azure

```bash
az login
```

### 1.2 Set your subscription (if you have multiple)

```bash
az account set --subscription "<your-subscription-name>"
```

### 1.3 Create a Resource Group

```bash
az group create --name myResourceGroup --location "East US"
```

### 1.4 Create an App Service Plan

```bash
az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku B1 --is-linux
```

### 1.5 Create a Web App

```bash
az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name my-python-webapp --runtime "PYTHON|3.10"
```

> Replace `my-python-webapp` with a globally unique name.

---

## 🐍 Step 2: Create a Python Web App

### 2.1 Create and Navigate to Project Folder

```bash
mkdir my-python-app
cd my-python-app
```

### 2.2 Create a Simple Flask Application

Install Flask if not installed:

```bash
pip install flask
```

Then create `app.py`:

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello, Azure App Service!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000)
```

### 2.3 Create `requirements.txt`

```bash
pip freeze > requirements.txt
```

Ensure Flask is listed in the file.

### 2.4 Create `startup.txt` (startup command)

Create a file named `startup.txt` and add the following:

```
gunicorn --bind=0.0.0.0 --timeout 600 app:app
```

---

## ☁️ Step 3: Deploy to Azure

### 3.1 Initialize Git Repository

```bash
git init
git add .
git commit -m "Initial commit"
```

### 3.2 Set Deployment User (if not set already)

```bash
az webapp deployment user set --user-name <username> --password <password>
```

### 3.3 Configure Local Git Deployment

```bash
az webapp deployment source config-local-git --name my-python-webapp --resource-group myResourceGroup
```

This will return a Git URL. Copy it.

### 3.4 Add Remote and Push Code

```bash
git remote add azure <deployment-git-url>
git push azure master
```

---

## 🧪 Step 4: Test the Application

Open the browser and go to:

```
https://my-python-webapp.azurewebsites.net
```

You should see "Hello, Azure App Service!"

---

## 📦 Optional: Automate with a Deployment Script

You can create a `deploy.sh` script to automate the deployment steps.

---

_Last updated: 2025-06-04_
