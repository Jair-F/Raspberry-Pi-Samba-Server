#!/bin/bash

if [ -e "/samba_server/user_creds.back" ]; then
    echo "samba config exists..."
else
    echo "samba config doesnt exists - setting up default config"
    cp -R /samba_server/default_config/* /samba_server/data
fi

bash -c "cd /samba_pass ; bash ./start.sh" &

/samba_server/scripts/addUsers.sh

service ssh start
service smbd start
service nmbd start

/bin/bash
