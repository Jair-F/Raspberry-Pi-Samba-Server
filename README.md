# Raspberry-Pi-Samba-Server

This is only a backup of my scripts, config and directory-structure of my samba server! Some of the scripts, especially the .bat scripts arent secure and I have to develop a better and more secure solution. This is only still here for backup

## Installation Instructions
**Disclaimer**: This script is only runable on a debian based linux-distribution!

* Copy this repository to a place where you want to have it finnaly on your server.
* Then open the terminal and navigate to the folder '*path_to_Samba_Share_directory/ServerResources/scripts*'. Navigate really with 'cd' to this folder! You must to be in this folder while you run the following script to ensure that it works(it takes the actual folder as reference to edit other config-files accordingly).
* Then execute the `initSambaServer.sh` script as root or with sudo
* You will be guided through the script and you can choose what you want to install/configure or not

__After__ executing this script your Samba-Server should be running correctly and you can start creating samba users and use the server.

## Backup
To configure when the backup-script will be executed you have to change the crontab file - the daily-section

Example:
```
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
30 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
00 18   * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )     <--------------
00 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
00 7    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
```
