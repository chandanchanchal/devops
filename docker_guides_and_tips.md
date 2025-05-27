
# Docker Resource Limits, Compose Check, and Volume Backup Guide

## ✅ Setting Resource Limits in Docker

### CPU Limit (Upper Only)
```bash
docker run --cpus="1.5" your_image
```
Limits the container to 1.5 CPU cores.

### Memory Limit (Upper Only)
```bash
docker run --memory="512m" your_image
```
Restricts the container to 512MB of RAM.

## ⚠️ CPU and Memory Reservations (Lower Limits)
Not supported directly in `docker run`.

### Use Docker Compose (Swarm Mode) or Kubernetes for reservations:

```yaml
deploy:
  resources:
    limits:
      cpus: '1.5'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 128M
```

Use this with:
```bash
docker stack deploy -c docker-compose.yml mystack
```

---

## ✅ Check if Docker Compose is Installed

### For Docker Compose V2 (plugin):
```bash
docker compose version
```
✅ Example output:
```
Docker Compose version v2.20.2
```

### For Docker Compose V1 (standalone):
```bash
docker-compose version
```
✅ Example output:
```
docker-compose version 1.29.2, build 5becea4c
```

### ❌ If Not Installed
```
docker-compose: command not found
```
or
```
docker: 'compose' is not a docker command.
```

### 🛠️ Install (Ubuntu/Debian):
```bash
sudo apt install docker-compose-plugin
```

---

## 🔐 Backup & Restore MySQL Docker Volumes

### 🔸 Backup MySQL Volume
```bash
docker run --rm   -v mysql_data:/data   -v $(pwd):/backup   alpine   tar czf /backup/mysql_backup.tar.gz -C /data .
```

### 🔸 Restore to a New Volume
```bash
docker volume create mysql_restore

docker run --rm   -v mysql_restore:/data   -v $(pwd):/backup   alpine   tar xzf /backup/mysql_backup.tar.gz -C /data
```

### 🔸 Start MySQL with Restored Data
```bash
docker run -d --name mysql-restored   -e MYSQL_ROOT_PASSWORD=root   -v mysql_restore:/var/lib/mysql   -p 3307:3306   mysql:5.7
```

### 🔸 Verify Restored Data
```bash
docker exec -it mysql-restored mysql -uroot -proot -e "SELECT * FROM testdb.users;"
```

---

## ⌨️ Stop `cat` Command

- Press `Ctrl + D` to send EOF and exit `cat` gracefully.
- Press `Ctrl + C` to force-stop `cat` immediately.
