#!/bin/bash

curl -sSL https://get.docker.com | sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io qemu-system

sudo apt install -y dnsutils git autossh


sudo apt install -y vim tmux