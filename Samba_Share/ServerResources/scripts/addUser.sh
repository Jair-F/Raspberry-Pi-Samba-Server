#/bin/bash

USER=$1
read -p "User-Password for $USER: " PASSWORD
useradd $USER

# real home folder on the system
mkdir /home/$USER
cp /etc/skel/.* /home/$USER
chown -R $USER:$USER /home/$USER
chmod -R 770 /home/$USER

# Samba home folder on Samba Data Device
mkdir /media/Data/Samba_Share_Device/Samba_Share/Homes/$USER
chown -R $USER:$USER /media/Data/Samba_Share_Device/Samba_Share/Homes/$USER
chmod -R 770 /media/Data/Samba_Share_Device/Samba_Share/Homes/$USER

echo $PASSWORD > /home/$USER/password

cat /home/$USER/password /home/$USER/password | passwd $USER
cat /home/$USER/password /home/$USER/password | smbpasswd -a $USER

