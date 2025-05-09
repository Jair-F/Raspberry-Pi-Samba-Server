#!/bin/bash

curl -sSL https://get.docker.com | sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io #qemu-system

sudo usermod -aG docker $USER

# VPN
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install -y tailscale


# tools for user
sudo apt install -y dnsutils git autossh
sudo apt install -y vim tmux