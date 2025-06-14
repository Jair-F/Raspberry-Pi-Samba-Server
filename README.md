# 🎉 Raspberry Pi Samba + Backup Server

A Docker-based Samba file server for Raspberry Pi (or ARM64/AMD64), with optional Borg backup integration.

[📦 Docker Hub: jairf/samba_server](https://hub.docker.com/repository/docker/jairf/samba_server/general)

---

## 📁 Folder Structure

```
.
├── .devcontainer/          # VS Code DevContainer config
├── .github/workflows/      # CI workflows (e.g., build & push)
├── Samba_Share/            # Sample directory structure for shares
├── data/                   # Volume-mounted persistent data for Samba
├── scripts/                # Utility scripts (e.g., backup.sh)
├── Dockerfile              # Docker build configuration
├── docker-compose.yml      # Docker Compose deployment file
├── smb.conf                # Samba server config
├── backup.sh               # Script to perform Borg backups
└── README.md               # <- This file
```

---

## 🛠 Prerequisites

Make sure your Raspberry Pi or Linux host has:

- Docker and Docker Compose installed
- Optional: BorgBackup for backups

### 🧰 Install required software
```bash
sudo apt update
sudo apt install -y docker.io
# For backups:
sudo apt install -y borgbackup
```

---

## 🚀 Build & Run the Server

### 🔨 Build the container

#### Build for current architecture:
```bash
docker build -t jairf/samba_server:latest .
```

<details>
<summary>📦 Build for arm64 and amd64</summary>

```bash
# Create a multi-arch builder
docker buildx create --name multi-arch-builder --driver docker-container --bootstrap --use

# Build & push multi-arch image
docker buildx build --push \
  --platform linux/amd64,linux/arm64 \
  --network=host \
  -t jairf/samba_server:latest \
  -t jairf/samba_server:latest .
```

</details>

---

### ▶️ Run the container

```bash
docker run -itd --rm --restart unless-stopped \
  --name samba_server \
  -p 139:139 -p 445:445 -p 22:22 \
  -v <path_to_ssd>:/media/Data/Samba_Share_Device \
  jairf/samba_server:latest
```

✅ **Make sure the mounted folder has a structure like `./Samba_Share/`**

---

## 📦 Docker Compose (Alternative)

```bash
docker-compose up -d
```

> Customize `docker-compose.yml` as needed for volumes and ports.

---

## 🔐 Samba Configuration

- Edit `smb.conf` to customize shares
- Add users inside the container:
  ```bash
  docker exec -it samba_server smbpasswd -a <username>
  ```
- Reload config:
  ```bash
  docker exec samba_server smbcontrol all reload-config
  ```

---

## 🧑‍🔧 Permissions

Ensure your host-mounted folders are accessible by the user inside the container. Use `chown` and `chmod` accordingly.

---

## 🗄️ Backup

### 🎯 Manual Execution

You can run the backup manually with:
```bash
sudo ./scripts/backup.sh
```

Or link it into cron.

### 📅 Add Backup to Crontab

#### Option 1: Daily cron job
```bash
sudo cp scripts/backup.sh /etc/cron.daily/
chmod +x /etc/cron.daily/backup.sh
```

#### Option 2: Custom schedule via crontab

```bash
sudo crontab -e
```

Add this line to run daily at 18:00:
```
0 18 * * * /root/scripts/backup.sh
```

### 🧾 Example from `/etc/crontab` (system-wide)
```cron
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12)
# |  |  |  |  .---- day of week (0 - 6)
# |  |  |  |  |          
# *  *  *  *  * user-name command to be executed
30 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
00 18   * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
00 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
00 7    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
```

---

## ⚙️ Configuration You Might Want to Change

| What                  | How to change                                |
|-----------------------|-----------------------------------------------|
| Folder to share       | Edit volume path in `docker run` or Compose  |
| Samba shares          | Edit `smb.conf`                               |
| Users & passwords     | `smbpasswd -a <user>` inside the container   |
| Backup target         | Edit `scripts/backup.sh`                     |
| Cron schedule         | Edit `/etc/crontab` or use `crontab -e`      |

---

## ✅ Quick Checklist

- [ ] Clone this repo
- [ ] Install Docker + Compose
- [ ] (Optional) Install BorgBackup
- [ ] Build container image
- [ ] Mount Samba-compatible folder
- [ ] Run the container
- [ ] Add Samba users
- [ ] Configure backups
