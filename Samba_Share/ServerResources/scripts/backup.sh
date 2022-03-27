# documentation of borg: https://borgbackup.readthedocs.io/en/stable/

# const vars
BACKUP_FOLDER_PATH='../../Backups'
COMPRESSION_TYPE='lz4'
DATA_TO_BACKUP='../../Homes ../../Public-Shares'
BACKUPS_KEEP_DAILY=1
BACKUPS_KEEP_WEEKLY=1
BACKUPS_KEEP_MONTHLY=4
BACKUPS_KEEP_YEARLY=12


# vars which change
EXIT_CODE=1     # a temp variable used to get the result of commands
TIME_DATE=`date "+%A_%d.%m.%Y_%H:%M:%S"`
BACKUP_NAME="$HOSTNAME $TIME_DATE"  # depends on the date,time. outputs something like: "Saturday_26.03.2022_20:26:54"
echo $BACKUP_NAME

# check if a backup-repository exists - if not create one
borg check --repository-only $BACKUP_FOLDER_PATH
EXIT_CODE=$?
if [[ $EXIT_CODE -neq 0 ]]
then
    echo "IN $BACKUP_FOLDER_PATH does not exist a borg-repository - creating..."
    borg init -e=none .
fi

# creating backup
borg create --progress --compression $COMPRESSION_TYPE $BACKUP_FOLDER_PATH::$BACKUP_NAME $DATA_TO_BACKUP
EXIT_CODE=$?
if [[ $EXIT_CODE -neq 0]]
then
    echo "[ERROR] `date "+%A_%d.%m.%Y_%H:%M:%S"`: Error creating backup $BACKUP_NAME from $DATA_TO_BACKUP to $BACKUP_FOLDER_PATH"
fi

# removing old backups
borg purne -v --list --keep-daily=$BACKUPS_KEEP_DAILY --keep-weekly=$BACKUPS_KEEP_WEEKLY --keep-monthly=$BACKUPS_KEEP_MONTHLY --keep-yearly=$BACKUPS_KEEP_YEARLY --prefix=$HOSTNAME
EXIT_CODE=$?
if [[ $EXIT_CODE -neq 0]]
then
    echo "[ERROR] `date "+%A_%d.%m.%Y_%H:%M:%S"`: Error deleting old backups in $BACKUP_FOLDER_PATH"
fi

# checking the made backup
bor check .
if [[ $EXIT_CODE -neq 0]]
then
    echo "[ERROR] `date "+%A_%d.%m.%Y_%H:%M:%S"`: backup check in $BACKUP_FOLDER_PATH failed"
fi
