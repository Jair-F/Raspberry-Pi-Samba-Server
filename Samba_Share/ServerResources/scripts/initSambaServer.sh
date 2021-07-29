sudo apt update
sudo apt upgrade -y
sudo apt install samba openssh-server build-essential -y
sudo cp /media/Data/Samba_Share_Device/Samba_Share/ServerResources/Samba/smb.conf /etc/samba/smb.conf
# sudo cp /media/Data/Samba_Share_Device/Samba_Share/ServerResources/ssh/sshd_config /etc/ssh/sshd_config
sudo systemctl enable smbd
sudo systemctl enable sshd

# Fancontrol
# sudo apt install wiringpi -y
# sudo cp /media/Data/Samba_Share_Device/Samba_Share/ServerResources/Fancontrol/fancontrol.service /lib/systemd/system/fancontrol.service
# g++ /media/Data/Samba_Share_Device/Samba_Share/ServerResources/fancontrol.cpp -o /media/Data/Samba_Share_Device/Samba_Share/ServerResources/fancontrol.run -lwiringPi
# systemctl enable fancontrol.service

# Change sudoers file
# sudo cp /media/Data/Samba_Share_Device/Samba_Share/ServerResources/sudo/sudoers /etc/sudoers

sudo echo >> /etc/fstab
sudo echo "# Samba-Share Device" >> /etc/fstab
sudo echo "UUID=9d4cf425-b20b-4965-8eac-669273665f3f       /media/Data/Samba_Share_Device  ext4    defaults,noatime        0       2" >> /etc/fstab
