# Deploy Jupyter with xeus-cpp to Render

Deployed [here](https://legendre.onrender.com). 

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

## Notes

* Deploy a VS Code but will crash on render free tier which only offers 512 MB memory. 

```dockerfile
# Use the official OpenVSCode Server image
FROM gitpod/openvscode-server:latest

# Render uses port 10000 by default for web services
EXPOSE 10000

# Start the server listening on all interfaces at port 10000
CMD ["--host", "0.0.0.0", "--port", "10000", "--without-connection-token"]
```