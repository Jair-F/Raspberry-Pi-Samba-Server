# 🎉 Raspberry Pi Samba + Backup Server

A Docker-based Samba file server for Raspberry Pi (or ARM64/AMD64), with optional Borg backup integration.

[📦 Docker Hub: jairf/samba_server](https://hub.docker.com/repository/docker/jairf/samba_server/general)

---

## 📁 Folder Structure

```
.
├── .devcontainer/          # VS Code DevContainer config
├── .github/workflows/      # CI workflows (e.g., build & push)
├── data/                   # Volume-mounted persistent data for Samba (mounted as /samba_server/data in container)
├── default_config/         # Default config copied to /samba_server/data if missing
├── scripts/                # Utility scripts (e.g., addUsers.sh, createFolderTree.sh, startServer.sh)
├── samba_pass/             # Submodule for Samba password management
├── Dockerfile              # Docker build configuration
├── docker-compose.yml      # Docker Compose deployment file
├── smb.conf                # Samba server config
├── backup.sh               # Script to perform Borg backups
└── README.md               # <- This file
```

---

## 🚀 Build & Run the Server

### ▶️ Run the container

```bash
docker run -itd --rm --restart unless-stopped \
  --name samba_server \
  -p 139:139 -p 445:445 -p 80:80 \
  -v /media/server/Samba_Share:/samba_server/data \
  jairf/samba_server:latest
```

- The container expects the Samba data at `/samba_server/data/`.
- On first run, if `/samba_server/data/user_creds.bak` does not exist, it copies everything from `/samba_server/default_config/` into `/samba_server/data/`.

---

## 📦 Docker Compose (Alternative)

```bash
docker-compose up -d
```

- The volume mapping in `docker-compose.yml` is:
  ```
  - /media/server/Samba_Share:/samba_server/data
  ```

---

## 🔐 Samba Configuration

- The Samba config file is copied to `/etc/samba/smb.conf` from your workspace.
- User credentials are managed in `/samba_server/data/user_creds.bak`.
- Users are created by `scripts/addUsers.sh` using the credentials file.
- Folder structure is created by `scripts/createFolderTree.sh` for both default config and data.

---

## 🗄️ Backup

- The backup script expects data at `/samba_server/data/Samba_Share/Homes` and `/samba_server/data/Samba_Share/PublicShares` (see `backup.sh`).
- Adjust paths in `backup.sh` if your data is elsewhere.

---

## ⚙️ Configuration You Might Want to Change

| What                  | How to change                                |
|-----------------------|-----------------------------------------------|
| Folder to share       | Edit volume path in `docker run` or Compose  |
| Samba shares          | Edit `smb.conf`                               |
| Users & passwords     | Edit `/samba_server/data/user_creds.bak` and rerun container |
| Backup target         | Edit `backup.sh`                              |
| Cron schedule         | Edit `/etc/crontab` or use `crontab -e`      |

---

## ✅ Quick Checklist

- [ ] Clone this repo
- [ ] Install Docker + Compose
- [ ] (Optional) Install BorgBackup
- [ ] Build container image
- [ ] Mount Samba-compatible folder at `/media/server/Samba_Share`
- [ ] Run the container
- [ ] Add Samba users via `/samba_server/data/user_creds.bak`
- [ ] Configure backups

---

**Note:**  
All internal paths in scripts and configs use `/samba_server/data/` for persistent Samba data.  
Default configuration is copied from `/samba_server/default_config/` if no credentials file is present.  
Update your host volume mapping to `/media/server/Samba_Share:/samba_server/data` for correct operation.
