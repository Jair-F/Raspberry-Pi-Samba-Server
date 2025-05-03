#!/bin/bash

systemctl stop sshtunnel.service
systemctl disable sshtunnel.service

rm /etc/systemd/system/sshtunnel.service
rm /usr/bin/start_portmapio_tunnel