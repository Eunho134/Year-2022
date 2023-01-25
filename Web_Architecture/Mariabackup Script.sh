#!/bin/sh
# mariabackup 

mkdir -p /data/db/;

now="$(date +'%Y%m%d_%H%M%S')"
filename="nia_full_backup.sql"
backupfolder="/data/db/"
backupfile="$backupfolder/$filename"

# Logfile
logfile="$backupfolder/"nia_backup_log_"$(date +'%Y%m')".txt

# Backup
echo "mariabackup started at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"

user=""                     # mariadb user name
password=""                 # mariadb password

db_pass=""                  # mariadb path

##### Full Backup #####
mariabackup --backup --defaults-file=$db_pass --target-dir=$backupfolder --user=$user --password=$password --no-lock > "$backupfile"

echo "mariabackup finished at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"

# remove old backup
find "$backupfolder" -name nia_backup_* -mtime +14 -exec rm {} \;
echo "old files deleted" >> "$logfile"

echo "operation finished at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
exit 0



-----------------------------------------------------------

#!/bin/sh

now="$(date +'%Y%m%d_%H%M%S')"
filename="nia_full_backup.sql"
backupfolder="/data/db/full"
backupfile="$backupfolder/$filename"
backuppath="/data/db"

# Logfile
logfile="$backupfolder/"nia_backup_log_"$(date +'%Y%m')".txt

# Backup
echo "mariabackup started at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"

user=root
password=1234

db_pass=/var/lib/mysql

mv $backupfolder/* 

##### Full Backup #####
mariabackup --backup --defaults-file=$db_pass --target-dir=$backupfolder --user=$user --password=$password --no-lock > "$backupfile"

echo "mariabackup finished at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"

# remove old backup
find "$backuppath" -name nia_backup_* -mtime +14 -exec rm {} \;
echo "old files deleted" >> "$logfile"

echo "operation finished at $(date +'%Y-%m-%d %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
exit 0



