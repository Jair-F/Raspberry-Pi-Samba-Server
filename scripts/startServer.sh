#!/bin/bash

bash -c "cd /samba_pass ; bash ./start.sh" &

/server_scripts/addUsers.sh

service ssh start
service smbd start
service nmbd start

/bin/bash
