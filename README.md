# Raspberry-Pi-Samba-Server

## installing required software
`sudo apt install -y docker.io`

For doing backups I recommend borg backup: `sudo apt install -y borgbackup`

## starting up the server
#### build the continer
`docker build -t jairf/samba_server:0.1 .`
#### run the container
`docker run -itd --rm --restart unless-stopped --name samba_server jairf/samba_server:0.1 -p 139:139 -p 445:445 -p 22:22 -v <path_to_ssd>:/media/Data/Samba_Share_Device`

the folder we mount to the container should have the structure like the **./Samba_Share** folder.

[Docker Hub link](https://hub.docker.com/repository/docker/jairf/samba_server/general)

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
