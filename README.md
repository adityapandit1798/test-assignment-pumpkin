### ✅ **DevOps Engineer Assignment Submission – Aditya Pandit**

I am pleased to submit my completed DevOps assignment, where I successfully deployed a Next.js application on AWS using modern DevOps practices. Below is a detailed summary of the implementation:

---

### 🔧 **1. Infrastructure as Code (Terraform)**

- Provisioned AWS resources using **Terraform**:
  - 1 EC2 instance (Ubuntu, `t2.medium`)
  - 1 S3 bucket
  - Security group allowing SSH (22), HTTP (80), and custom ports (3000, 9090)
- Used **variables and outputs** for reusability and clarity
- Terraform state is managed and infrastructure is version-controlled

---

### 🐳 **2. Containerization (Docker)**

- Created an optimized **multi-stage `Dockerfile`** for the Next.js app
- Used `node:18-alpine` to reduce image size
- Built the app in a builder stage and ran it with a non-root user (`nextjs`) in production
- Ensured `.dockerignore` and proper file copying for efficiency

---

### 🔁 **3. CI/CD Pipeline (Jenkins)**

- Set up **Jenkins on EC2** to automate deployments
- Created a pipeline that:
  - Triggers on every **GitHub commit**
  - Builds the Docker image
  - Pushes to **Docker Hub** (`panditaditya1798/nextjs-app`)
  - Deploys the new container to EC2
- Used **Jenkins credentials store** for secure Docker Hub login
- Configured **GitHub webhook** for automatic triggering

---

### 📊 **4. Monitoring & Logging**

- Deployed **Prometheus + Node Exporter** in Docker containers
- Exposed and visualized key metrics:
  - CPU usage: `rate(node_cpu_seconds_total[1m])`
  - Memory availability: `node_memory_MemAvailable_bytes`
- Configured **simple logging**:
  - Logs stored via Docker’s `local` logging driver
  - Log rotation enabled (`max-size=100m`, `max-file=3`)
  - Logs accessible at `/home/ubuntu/monitoring/logs`


```bash
docker run -d \
  --name node-exporter \
  --restart unless-stopped \
  -p 9100:9100 \
  -v "/proc:/host/proc:ro" \
  -v "/sys:/host/sys:ro" \
  -v "/:/rootfs:ro" \
  quay.io/prometheus/node-exporter:latest \
  --path.procfs=/host/proc \
  --path.sysfs=/host/sys \
  --collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"
```


##  `prometheus.yml` Config File

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['172.31.27.119:9100']  # EC2 private IP
```


## Run Prometheus Container

```bash
docker run -d \
  --name prometheus \
  --restart unless-stopped \
  -p 9090:9090 \
  -v /home/ubuntu/monitoring/prometheus:/etc/prometheus \
  -v /home/ubuntu/monitoring/data:/prometheus \
  --add-host="host.docker.internal:172.31.27.119" \
  --log-driver=local \
  --log-opt max-size=100m \
  prom/prometheus:latest \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.console.libraries=/etc/prometheus/consoles \
  --web.console.templates=/etc/prometheus/consoles
```

---

### 🔐 **5. Security & Best Practices**

- **No hardcoded secrets**: Used Jenkins credentials and Docker Hub access tokens
- **Non-root containers**: App runs as `nextjs` user
- **Minimal attack surface**: Security group restricts access to necessary ports
- **Clean code & config**: All infrastructure, Docker, and monitoring configs are in version control

---

### 📂 **GitHub Repository**

🔗 **Repo**: [https://github.com/adityapandit1798/test-assignment-pumpkin](https://github.com/adityapandit1798/test-assignment-pumpkin)

Includes:
- `main.tf` – Terraform infrastructure
- `Dockerfile` – Optimized container build
- `Jenkinsfile` – Full CI/CD pipeline
- `monitoring/prometheus.yml` – Prometheus configuration
- Screenshots and documentation

---

### 🖼️ **Proof of Work (Screenshots Attached)**

1. `terraform apply` output – Infrastructure provisioned
2. `docker ps` – All containers running (app, Prometheus, Node Exporter)
3. GitHub webhook configured
4. Jenkins pipeline success (green build)
5. Docker Hub image pushed
6. Terraform state list
7. Next.js app running in browser (`http://<ec2-ip>:3000`)
8. Prometheus targets page – Node Exporter UP
9. Prometheus graph – CPU/Memory metrics visible

---

### 🚀 Summary

This project demonstrates a **production-ready DevOps workflow** covering:
- Infrastructure automation
- Secure containerization
- Automated CI/CD
- Observability & logging
- Security best practices

All components are working in real-time on AWS.

---

Let me know if you'd like the **live IP address**, **Jenkins login details**, or to **walk through the setup**.

Thank you for the opportunity — I look forward to discussing this further!

## 🖼️ Screenshots

| Description | Screenshot |
|-----------|------------|
| 1| ![Terraform Apply](screenshots/Screenshot_from_2025-08-26_14-04-27.png) |
| 2 | ![Docker PS](screenshots/Screenshot_from_2025-08-26_14-05-44.png) |
| 3| ![GitHub Webhook](screenshots/Screenshot_from_2025-08-26_14-06-50.png) |
| 4 | ![Jenkins Build](screenshots/Screenshot_from_2025-08-26_14-07-34.png) |
| 5 | ![Docker Hub](screenshots/Screenshot_from_2025-08-26_14-08-23.png) |
| 6 | ![Terraform State](screenshots/Screenshot_from_2025-08-26_14-09-07.png) |
| 7 | ![Next.js App](screenshots/Screenshot_from_2025-08-26_14-09-28.png) |
| 8 | ![Prometheus Targets](screenshots/Screenshot_from_2025-08-26_14-10-14.png) |

Best regards,  
**Aditya Pandit**  

