#!/bin/sh

now="$(date +'%Y%m%d_%H%M%S')"
yesterday=`date -d yesterday '+%Y%m%d'`
filename="nia_backup.sql"
backupfolder="/data/db"

mkdir -p $backupfolder/$yesterday;

fullpathbackupfile="$backupfolder/$yesterday/$filename"

# Logfile
logfile="$backupfolder/$yesterday/"nia_backup_log_"$(date +'%Y%m')".txt

# Backup
echo "mysqldump started at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"

user=""                     # mysql user name
password=""                 # mysql password 
mysql_log_path=""           # mysql mysql_config_editor path name

dbpass=/var/lib/mysql       # mysql 경로

##### DB Backup #####
sh /$dbpass/bin/mysql_config_editor set --login-path=$mysql_log_path --host=localhost --user=$user --password << EOF
$password
EOF
sleep 1;

sh /$dbpass/bin/mysqldump --login-path=$mysql_log_path --single-transaction --default-character-set=utf8 --all-databases --no-tablespaces --log-error=$dbpass/mysqldump_error.log > "$fullpathbackupfile"
sleep 1;

cp /etc/my.cnf $backupfolder/$yesterday/        # mysql config backup
sleep 1;

echo "mysqldump finished at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"

# remove old backup
find "$backupfolder" -name nia_backup_* -mtime +13 -exec rm {} \;
echo "old files deleted" >> "$logfile"

echo "operation finished at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
exit 0
