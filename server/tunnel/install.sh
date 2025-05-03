#!/bin/bash

cp ./sshtunnel.service /etc/systemd/system/
cp ./start_portmapio_tunnel /usr/bin

chmod +x /usr/bin/start_portmapio_tunnel

echo "pace the file: /root/.ssh/Jaja8373.nextcloud.pem"
echo "enable the tunnel with systemctl enable sshtunnel"
systemctl start sshtunnel.service
