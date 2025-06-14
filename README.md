# 🎉 Raspberry Pi Samba + Backup Server

A Docker-based Samba file server for Raspberry Pi (or ARM64/AMD64), plus optional Borg backup tooling.

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
└── README.md               # <- You are reading it ;)
```

---

## 🚀 What It Does

1. Builds a Docker container housing Samba, exposing ports 139 & 445 for file sharing.
2. Syncs host-mounted folders into `/media/Data/Samba_Share_Device` within the container.
3. Includes `backup.sh` for backing up Samba data via Borg.
4. Optional automated tasks (e.g., cron jobs) to schedule backups.

---

## 🔧 Prerequisites (Before You Begin)

- A Raspberry Pi (ARM64) or any Linux host with Docker & Docker Compose installed.
- For backups: optional **BorgBackup** installed (e.g. `sudo apt install borgbackup`).
- A valid **Samba share folder** structured like `Samba_Share/` (see below).
- Linux user permissions—mounted folder must be owned by your Samba user.

---

## 📦 How to Deploy

### 1. Install Docker
```bash
sudo apt update
sudo apt install -y docker.io docker-compose
```

### 2. Clone & Build
```bash
git clone https://github.com/Jair-F/Raspberry-Pi-Samba-Server.git
cd Raspberry-Pi-Samba-Server
# Single-arch
docker build -t jairf/samba_server:0.1 .
# Multi-arch
docker buildx create --name mb-builder --bootstrap --use
docker buildx build --push \
  --platform linux/amd64,linux/arm64 \
  -t jairf/samba_server:0.1 \
  -t jairf/samba_server:latest .
```

### 3. Start Container

#### Option A: `docker-compose.yml`
Simply run:
```bash
docker-compose up -d
```
Customize volume and ports in the YAML as needed.

#### Option B: `docker run`
```bash
docker run -d \
  --name samba_server \
  --restart unless-stopped \
  -p 139:139 -p 445:445 -p 22:22 \
  -v /path/to/Samba_Share_Device:/media/Data/Samba_Share_Device \
  jairf/samba_server:0.1
```

---

## ⚙️ Configuration — Things to Change

- **Volume path** (`/path/to/...`): point to your actual host share folder.
- **Ports**: default is `139`/`445`. Adjust if another Samba runs elsewhere.
- **Samba config** (`smb.conf`): tweak permissions, users, share names.
- **Container user/password**: setup via `smbpasswd` to secure access.
- **Backup script** (`scripts/backup.sh`):
  - Adjust Borg repo path.
  - Integrate into your cron schedule (see below).
- **Cron timing**: define in `/etc/cron.daily` or your custom schedule.

---

## 🗓 Backup Integration

Automate your backups using a cron job.

### Option 1: Add to `/etc/cron.daily/`
1. Make `backup.sh` executable:
   ```bash
   chmod +x scripts/backup.sh
   ```
2. Move it into the daily cron folder:
   ```bash
   sudo cp scripts/backup.sh /etc/cron.daily/
   ```

### Option 2: Add to root's crontab

If you want more control over the time it runs (e.g., every day at 18:00):

1. Open root's crontab:
   ```bash
   sudo crontab -e
   ```

2. Add the following line at the bottom:
   ```
   0 18 * * * /root/scripts/backup.sh
   ```

📝 Make sure that the `backup.sh` file is at that exact path or adjust accordingly.

---

## 🛠 Customization Tips

- **Add new shares**: Modify `smb.conf`, then restart the container:
  ```bash
  docker exec samba_server smbcontrol all reload-config
  ```
- **Add new Samba users**:
  ```bash
  docker exec -it samba_server smbpasswd -a <username>
  ```
- **File ownership/permissions**: Ensure host folder ownerships match Samba user/group IDs.

---

## ✅ Things to Consider

- **Architecture**: Build for ARM64 on a Raspberry Pi or multi-arch builder.
- **Permissions**: Host-mounted data must be writable by the Samba user inside the container.
- **Backups**: Borg isn’t included in container—install on host or include it.
- **Networking**:
  - Samba over 139/445
  - SSH over port 22
- **Security**:
  - Secure your Samba users with strong passwords.
  - Consider limiting share access to specific subnets.

---

## 🧰 Quick-Start Checklist

- [ ] Clone repository
- [ ] Install Docker & Compose on your host
- [ ] Prepare data folder and ensure correct ownership
- [ ] Edit `docker-compose.yml` or `docker run` command for volumes & ports
- [ ] `docker-compose up -d`
- [ ] Configure Samba users via `smbpasswd`
- [ ] (Optional) Install Borg and schedule `backup.sh`
