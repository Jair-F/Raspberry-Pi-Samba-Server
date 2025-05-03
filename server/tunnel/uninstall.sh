#!/bin/bash

systemctl stop sshtunnel
systemctl disable sshtunnel

rm /etc/systemd/system/sshtunnel.service
rm /usr/bin/start_portmapio_tunnel