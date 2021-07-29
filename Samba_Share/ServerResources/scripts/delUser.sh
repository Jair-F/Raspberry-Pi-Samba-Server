#!/bin/bash

USER=$1
userdel $USER

# Remove home folder on system
rm -rfd /home/$USER

# Remove home folder on Samba Data Device
rm -rfd /media/Data/Samba_Share_Device/Samba_Share/Homes/$USER

# Remove Samba User
smbpasswd -x $USER
