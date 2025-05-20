# 🚀 Docker Container Resource Limits and Monitoring Guide

## 📌 Overview
This document covers:
- How to set resource limits on Docker containers.
- How to test these limits.
- How to monitor container resource usage automatically.

---

## 🧱 1. Setting Container Resource Limits

### Memory Limits

```bash
docker run -it --rm --name mem-test --memory=100m ubuntu bash
```
Inside the container:
```sh
apt update && apt install -y stress
stress --vm 2 --vm-bytes 200 --timeout 60
```

### CPU Limits

```bash
docker run -it --rm --name cpu-test --cpus="0.5" ubuntu bash
```
Inside the container:
```sh
apt update && apt install -y stress
stress --cpu 2 --timeout 30
```

### Memory + Swap

```bash
docker run -it --rm --memory=100m --memory-swap=100m ubuntu bash
```
Inside:
```sh
stress --vm 1 --vm-bytes 150M --timeout 10
```

---

## 🧪 2. Testing Resource Limits

Use the `stress` tool to trigger CPU/memory usage and observe container behavior.

---

## 📊 3. Monitoring Container Resource Usage Automatically

### 1. Using `docker stats` Script

```bash
#!/bin/bash
LOGFILE="docker_stats_$(date +%F_%T).log"
INTERVAL=5

echo "Logging container stats every $INTERVAL seconds..."
while true; do
    echo "Timestamp: $(date +%F_%T)" >> "$LOGFILE"
    docker stats --no-stream >> "$LOGFILE"
    echo "----------------------------------" >> "$LOGFILE"
    sleep $INTERVAL
done
```

### 2. Using `cAdvisor`

```bash
docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  gcr.io/cadvisor/cadvisor:latest
```
Access at [http://localhost:8080](http://localhost:8080)

### 3. Prometheus + Grafana Stack

```bash
docker network create monitoring

docker run -d --name=prometheus --network=monitoring -p 9090:9090 \
  -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

docker run -d --name=node-exporter --network=monitoring -p 9100:9100 prom/node-exporter

docker run -d --name=grafana --network=monitoring -p 3000:3000 grafana/grafana
```

### 4. Using Sysdig

```bash
curl -s https://s3.amazonaws.com/download.draios.com/stable/install-sysdig | sudo bash
sudo sysdig container.name=your_container_name
```

### 5. Cloud-native Monitoring

- AWS CloudWatch (ECS, EKS)
- Azure Monitor (AKS)
- Google Cloud Operations Suite

---

## 📈 Key Metrics

| Metric              | Description                      |
|---------------------|----------------------------------|
| CPU %               | CPU utilization                  |
| Memory Usage / Limit| RAM consumed vs. allocated       |
| Network I/O         | Bytes sent/received              |
| Block I/O           | Disk read/write by container     |
| Uptime              | Container running duration       |

---

## 🔔 Alerts & Automation

- Prometheus Alertmanager
- Grafana Alerting
- Falco (Behavior-based security alerts)
