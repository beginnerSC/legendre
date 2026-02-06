# Deploy Jupyter with xeus-cpp to Render

## Prerequisites
* A Render account

## Deployment Steps

### 1. Push to GitHub
1. Initialize a Git repository and push your code (including the Dockerfile) to GitHub

### 2. Deploy on Render
1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **New** > **Web Service**
3. Select **Build and deploy from a Git repository**
4. Connect your GitHub account and select your repository
5. Choose a **Name** and **Region**
6. Render will auto-detect the Dockerfile and build the image
7. Set **Environment Variables**:
   * `JUPYTER_TOKEN`: YOUR_PASSWORD (for JupyterLab authentication)
   * `PORT`: 8888
8. Click **Create Web Service**

Render will automatically build and store your Docker image!

### 3. Access Your JupyterLab Instance
Once deployed, your JupyterLab will be available at:
```
https://YOUR_SERVICE_NAME.onrender.com/lab
```

Enter your `JUPYTER_TOKEN` password when prompted.

## Features
* JupyterLab with xeus-cpp kernel for C++ notebook support
* Python kernel included
* Ready-to-use computing environment