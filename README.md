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
* Alternatives to Render: 
  * Railway.app (最靈活的 PaaS): Railway 是 Render 最強的競爭對手，對於部署 Docker 容器非常友善
    * 費用：採用 "Pay-as-you-go" 模式。每個月提供 $5 USD 的免費額度（如果您通過開發者驗證）
    * 優點：
      * 不休眠：只要額度沒用完，服務就不會像 Render 那樣進入睡眠模式
      * 資源更強：預設提供的 RAM 通常比 Render 慷慨
      * 部署極簡：直接連接 GitHub Repo，偵測到 Dockerfile 就會自動啟動
  * Koyeb (真正的免費層級): Koyeb 提供了一個非常誠實的免費方案，適合小型 Web App
    * 費用：Free Tier 提供一個 Nano 實例
    * 優點：
      * 無休眠 (No Spin-down)：這是它最大的賣點，服務永遠在線
      * 全球部署：可以選擇不同的地區
      * 缺點：實例較小（通常是 256MB 或 512MB RAM），不適合在運行時進行重型 C++ 編譯
  * Fly.io (最適合 Docker 部署): Fly.io 將您的 Docker 容器轉換為運行在物理機上的微型虛擬機（Firecracker VMs）
    * 費用：雖然現在需要綁定信用卡，但只要每月帳單低於 $5 USD，他們通常不會扣款（實質免費）
    * 優點：
      * 極速：因為是底層 VM，性能比一般的 Container 平台更穩定
      * 持久化儲存：提供免費的 Volumes，這解決了 Render 重新啟動後檔案消失的問題
  * Oracle Cloud Always Free (終極「大碗滿意」): 如果您能成功註冊，這是一台真正的虛擬專屬伺服器 (VPS)
    * 規格：24GB RAM 和 4 顆 ARM CPU 核心
    * 優點：這不是 PaaS，而是一台完整的 Linux 機器。您可以安裝 Docker 並同時跑 10 個不同的 Web App，完全不用擔心時數
