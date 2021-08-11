# Raspberry-Pi-Samba-Server

This is only a backup of my scripts, config and directory-structure of my samba server! Some of the scripts, especially the .bat scripts arent secure and I have to develop a better and more secure solution. This is only still here for backup

## Installation Instructions
**Disclaimer**: This script is only runable on a debian based linux-distribution!

* Copy this repository to a place where you want to have it finnaly on your server.
* Then open the terminal and navigate to the folder '*path_to_Samba_Share_directory/ServerResources/scripts*'. Navigate really with 'cd' to this folder! You must to be in this folder while you run the following script to ensure that it works(it takes the actual folder as reference to edit other config-files accordingly).
* Then execute the 'initSambaServer.sh' script as root or with sudo
* You will be guided through the script and you can choose what you want to install/configure or not

After executing this script your Samba-Server should be running correctly and you can start creating samba users and use the server.
