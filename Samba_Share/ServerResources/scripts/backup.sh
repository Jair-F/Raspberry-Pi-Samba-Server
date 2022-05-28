#!/bin/bash

# documentation of borg: https://borgbackup.readthedocs.io/en/stable/

# const vars
BACKUP_FOLDER_PATH='/media/Data/Samba_Share_Device/Samba_Share/Backups'
COMPRESSION_TYPE='lz4'
DATA_TO_BACKUP='/media/Data/Samba_Share_Device/Samba_Share/Homes /media/Data/Samba_Share_Device/Samba_Share/PublicShares'
BACKUPS_KEEP_DAILY=1
BACKUPS_KEEP_WEEKLY=1
BACKUPS_KEEP_MONTHLY=4
BACKUPS_KEEP_YEARLY=12


# vars which change
EXIT_CODE=1     # a temp variable used to get the result of commands
START_TIME_DATE=`date "+%A_%d.%m.%Y_%H:%M:%S"`
BACKUP_NAME="$HOSTNAME $START_TIME_DATE"  # depends on the date,time. outputs something like: "Saturday_26.03.2022_20:26:54"
echo $BACKUP_NAME

# check if a backup-repository exists - if not create one
borg check --repository-only $BACKUP_FOLDER_PATH
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ];
then
    echo "IN $BACKUP_FOLDER_PATH does not exist a borg-repository - creating..."
    #borg init -e=none $BACKUP_FOLDER_PATH
else
    echo "A borg-repository already exists..."
fi

# creating backup
borg create -v --progress --compression "$COMPRESSION_TYPE" "$BACKUP_FOLDER_PATH::$BACKUP_NAME" $DATA_TO_BACKUP
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ];
then
    TIME_DATE=`date "+%A_%d.%m.%Y_%H:%M:%S"`
    echo $TIME_DATE
    echo "[ERROR] $TIME_DATE: Error creating backup $BACKUP_NAME from $DATA_TO_BACKUP to $BACKUP_FOLDER_PATH"
fi

# removing old backups
borg prune -v --list --keep-daily=$BACKUPS_KEEP_DAILY --keep-weekly=$BACKUPS_KEEP_WEEKLY --keep-monthly=$BACKUPS_KEEP_MONTHLY --keep-yearly=$BACKUPS_KEEP_YEARLY --prefix=$HOSTNAME $BACKUP_FOLDER_PATH
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ];
then
    echo "[ERROR] `date "+%A_%d.%m.%Y_%H:%M:%S"`: Error deleting old backups in $BACKUP_FOLDER_PATH"
fi

# checking the made backup
borg check $BACKUP_FOLDER_PATH
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ];
then
    echo "[ERROR] `date "+%A_%d.%m.%Y_%H:%M:%S"`: backup check in $BACKUP_FOLDER_PATH failed"
fi
