#!/bin/bash

# Bash operations: https://devhints.io/bash

SAMBA_SERVER_DIR=`cd ../.. && pwd`

# Terminal text output formatting: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# !!! ---------------------- use 'echo -e' for formatted text output ---------------------- !!!
FOREGROUND_BLACK="\e[30m"
FOREGROUND_WHITE="\e[97m"
FOREGROUND_RED="\e[31m"
FOREGROUND_GREEN="\e[32m"
FOREGROUND_BLUE="\e[34m"
FOREGROUND_MAGENTA="\e[35m"
FOREGROUND_DEFAULT_COLOR="\e[39m"
FOREGROUND_CYAN="\e[36m"

RESET_ALL_ATTRIBUTES="\e[0m"
RESET_BOLD_BRIGHT="\e[21m"
# End text formatting section


USER_INPUT="null"

if [ $UID -ne 0 ]	# ensure we are running this as sudo/root
then
	echo "Execute this script as root/with sudo!"
	exit
fi

# Start-Warning
echo -e "$FOREGROUND_RED Clone this repository / copy the 'Samba_Share' folder to the place/Device, where the Data-Directory finally should be and$FOREGROUND_WHITE only then$FOREGROUND_RED execute this script!!"
echo -e "$FOREGROUND_MAGENTA"
read -p "If you read the warning above and want to type 'CONTINUE': " USER_INPUT
if [ $USER_INPUT != "CONTINUE" ]
then
	echo -e "$FOREGROUND_GREEN exiting $FOREGROUND_DEFAULT_COLOR"
	exit
fi
echo -e "$FOREGROUND_DEFAULT_COLOR"




# Upgrading System
echo
echo -e "$FOREGROUND_CYAN Upgrading the system $FOREGROUND_DEFAULT_COLOR"
echo
sudo apt update
sudo apt upgrade -y




# Install necessarily pacakges
echo
echo -e "$FOREGROUND_CYAN Installing necessarily packages $FOREGROUND_DEFAULT_COLOR"
echo
sudo apt install openssh-server build-essential samba  -y

sudo systemctl enable smbd
sudo systemctl enalbe nmbd

sudo systemctl enable sshd




# Configuring samba service
echo
echo -e "$FOREGROUND_CYAN  configuring the Samba service $FOREGROUND_DEFAULT_COLOR"
echo

read -p "Configure samba service with preconfigured config-file y/n: " USER_INPUT
# True if input is 'y' or 'Y' or ''(empty input!)
if [ $USER_INPUT == "y" ] || [ $USER_INPUT == "Y" ] || [ -z $USER_INPUT ]
then
	sudo cp ../Samba/smb.conf /etc/samba/smb.conf
	sudo systemctl reload smbd
	sudo systemctl reload nmbd
else
	echo "Skipping configure samba service!"
fi




# SSH-Service
echo
echo -e "$FOREGROUND_CYAN  configuring the ssh service $FOREGROUND_DEFAULT_COLOR"
echo

read -p "Configure ssh service with preconfigured config-file y/n: " USER_INPUT
# True if input is 'y' or 'Y' or ''(empty input!)
if [ $USER_INPUT == "y" ] || [ $USER_INPUT == "Y" ] || [ -z $USER_INPUT ]
then
	sudo cp../ssh/sshd_config /etc/ssh/sshd_config
	sudo systemctl reload sshd
else
	echo "Skipping configure ssh service!"
fi




# Fancontrol
echo
echo -e "$FOREGROUND_CYAN Installing and configuring fancontroll service $FOREGROUND_DEFAULT_COLOR"
echo

read -p "Install fancontroll service y/n: " USER_INPUT
# True if input is 'y' or 'Y' or ''(empty input!)
if [ $USER_INPUT == "y" ] || [ $USER_INPUT == "Y" ] || [ -z $USER_INPUT ]
then
	sudo apt install wiringpi -y
	sudo cp ../Fancontrol/fancontrol.service /lib/systemd/system/fancontrol.service
	g++ ../Fancontrol/fancontrol.cpp -o ../Fancontrol/fancontrol.run -lwiringPi
	systemctl enable fancontrol.service
else
	echo "Skipping install fancontroll service!"
fi




# Change sudoers file
echo
echo -e "$FOREGROUND_CYAN configuring the sudo service $FOREGROUND_DEFAULT_COLOR"
echo

read -p "configure sudo service y/n: " USER_INPUT
# True if input is 'y' or 'Y' or ''(empty input!)
if [ $USER_INPUT == "y" ] || [ $USER_INPUT == "Y" ] || [ -z $USER_INPUT ]
then
	sudo cp ../sudo/sudoers /etc/sudoers
else
	echo "Skipp configure sudo service!"
fi




# Automatic-Upgrades
echo
echo -e "$FOREGROUND_CYAN Setting up automatic-updates $FOREGROUND_DEFAULT_COLOR"
echo

read -p "Install automatic update/upgrade service y/n: " USER_INPUT
# True if input is 'y' or 'Y' or ''(empty input!)
if [ $USER_INPUT == "y" ] || [ $USER_INPUT == "Y" ] || [ -z $USER_INPUT ]
then
	sudo apt install unattended-upgrades -y
	sudo systemctl start unattended-upgrades.service
	sudo cp ../unattended-upgrades/* /etc/apt/apt.conf.d/
	sudo systemctl reload unattended-upgrades.service
else
	echo "Skipping install automaitc update/upgrade service!"
fi




# Samba-Share Device/Disk
echo
echo -e "$FOREGROUND_CYAN Configuring automount at start of Samba-Share Device/Disk $FOREGROUND_DEFAULT_COLOR"
echo

read -p "Do you want to Configure automount of the Samba-Share-Data-Disk at system-start(only relevent if you have a externl drive where you want to store this data on) y/n: " USER_INPUT
if [ $USER_INPUT == "y" ] || [ $USER_INPUT == "Y" ] || [ -z $USER_INPUT ]
then
	echo -e "$FOREGROUND_MAGENTA Connect the Disk to the Server and then continue(press ENTER) $FOREGROUND_DEFAULT_COLOR"
	read

	echo -e "$FOREGROUND_RED!!!! WARNING !!!!"
	echo -e "The Disk UUID is not checked for validness or availability of the associated disk so check that by yourself!$FOREGROUND_DEFAULT_COLOR"
	read -p "Samba-Share-Data-Disk UUID: " USER_INPUT
	
	sudo echo >> /etc/fstab
	sudo echo "# Samba-Share Device" >> /etc/fstab
	sudo echo "UUID=$USER_INPUT       /media/Data/Samba_Share_Device  ext4    defaults,noatime        0       2" >> /etc/fstab
else
	echo "Skipping Samba-Share-Device/Disk configuration"
fi





echo
echo -e "$FOREGROUND_GREEN All operations executed successfully $FOREGROUND_DEFAULT_COLOR"
