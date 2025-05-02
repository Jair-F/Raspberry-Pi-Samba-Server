#!/bin/bash

# autossh - https://superuser.com/questions/37738/how-to-reliably-keep-an-ssh-tunnel-open
ssh -i ~/.ssh/Jaja8373.nextcloud.pem Jaja8373.nextcloud@Jaja8373-24256.portmap.io -N -R 24256:localhost:24256
