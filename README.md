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

* Deploy a VS Code but will crash on render free tier which only offers 512 MB memory

```dockerfile
# Use the official OpenVSCode Server image
FROM gitpod/openvscode-server:latest

# Render uses port 10000 by default for web services
EXPOSE 10000

# Start the server listening on all interfaces at port 10000
CMD ["--host", "0.0.0.0", "--port", "10000", "--without-connection-token"]
```

* Deploy a throwaray browser on Fly.io
  * See `fly.toml` below
  * Kasm 支援與本地電腦同步剪貼簿
  * 建議配置 2GB RAM，如果每天只用 1-2 小時，月費不會超過 $5
  * 安全警示：這類服務極易被掃描器發現並用來刷流量（做為 Proxy），務必設定密碼 (TOKEN)，否則你的額度會在一夜之間噴光
  * 加密 zip file 並把檔名改成如 notes.docx，不要超過 20 MB，不要用剪貼簿
  * fly.dev and onrender.com 本身就很可疑，用 Custom Domain（例如 my-personal-notes.com）+ Cloudflare Proxy
  * Binder 更可疑。Jupyter 連線長時間保持開啟，流量特徵非常像隱藏的後門或跳板
  * 筆記頁上的一個隱藏連結連到 my-personal-notes.com/static/lib/min.js + iframe trick，網址列只看到 my-personal-notes.com

```bash
fly secrets set VNC_PW='YOUR_PASSWORD'
```

```toml
app = "my-private-browser"
primary_region = "ewr" # 建議選離你近的

[build]
  image = "kasmweb/chrome:1.15.0" # 預設 6901，改成奇怪的數字能避開 90% 的駭客自動化掃描

[[services]]
  internal_port = 18427 
  protocol = "tcp"
  
  # 省錢核心：自動開關機
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 0

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443

[vm]
  # 效能核心：1GB 是流暢底線，2GB 最穩
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 2048

[env]
  VNC_PW = "暫不填寫" # 密碼我們稍後用 Secrets 設定，不寫在檔案裡
  VNC_PORT = "18427" # 必須與 internal_port 一致
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
