# MySQL Docker Backup and Restore Guide

This guide demonstrates how to run MySQL in Docker and safely perform backups and restores, including volume-level and logical backup methods.

## ✅ Step 1: Run MySQL 5.7 Container

```bash
docker run -d --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=root \
  -v mysql_data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:5.7
```

## ✅ Step 2: Backup MySQL Database

### Backup All Databases
```bash
docker exec mysql-db \
  sh -c 'exec mysqldump -u root -proot --all-databases' \
  > all_databases_backup.sql
```

### Backup a Specific Database
```bash
docker exec mysql-db \
  sh -c 'exec mysqldump -u root -proot your_database_name' \
  > your_database_name_backup.sql
```

## ✅ Step 3: Restore Backup to a New Container

### Create New MySQL 5.7 Container
```bash
docker run -d --name mysql-restore \
  -e MYSQL_ROOT_PASSWORD=root \
  -v mysql_restore_data:/var/lib/mysql \
  -p 3307:3306 \
  mysql:5.7
```

### Restore the Backup
```bash
docker cp all_databases_backup.sql mysql-restore:/all_databases_backup.sql

docker exec -i mysql-restore \
  sh -c 'exec mysql -u root -proot' \
  < all_databases_backup.sql
```

## ✅ Optional: Named Volume Backup/Restore

### Backup Volume Directly
```bash
docker run --rm \
  -v mysql_data:/volume \
  -v $(pwd):/backup \
  alpine \
  tar czf /backup/mysql_data.tar.gz -C /volume .
```

### Restore to New Volume
```bash
docker volume create mysql_restore_data

docker run --rm \
  -v mysql_restore_data:/volume \
  -v $(pwd):/backup \
  alpine \
  tar xzf /backup/mysql_data.tar.gz -C /volume
```

## 🔍 Risks of Volume-Level Backup and Restore

### ⚠️ 1. Inconsistent or Corrupt Data
If you back up the MySQL volume while the MySQL server is running and writing data, you may capture an inconsistent state—leading to corruption or restore failure.

### ⚠️ 2. MySQL Version Mismatch
Restoring volume data from MySQL 5.7 into a container running a different version (e.g., 8.0) can cause data format incompatibilities or crashes.

### ⚠️ 3. User/Permission Issues
Backed-up files may have different UID/GID or file permissions when restored, making MySQL unable to read its own data.

### ⚠️ 4. Data Overwrite
Restoring a volume backup over an existing volume will overwrite all data without warning.

### ⚠️ 5. Incompatible Volume Mount Paths
The container must mount the volume to exactly `/var/lib/mysql`. Mounting elsewhere will not work for MySQL's data directory.

---

*Generated on 2025-05-19*
