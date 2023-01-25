#!/bin/bash
# Apache Tomcat Source backup

YESTERDAY=`date -d yesterday '+%Y%m%d'`

mkdir -p /data/tomcat/current;

# Apache Tomcat
TOMCAT_ORIGINAL_DIR=$CATALINA_HOME
TOMCAT_BACKUP_DIR=/data/tomcat
TOMCAT_CURRENT_DIR=/data/tomcat/current

mkdir -p ${TOMCAT_BACKUP_DIR}/backup_$YESTERDAY;
sleep 1;

cp -r ${TOMCAT_ORIGINAL_DIR}/ ${TOMCAT_CURRENT_DIR}
sleep 1;

tar czvfp ${TOMCAT_BACKUP_DIR}/backup_$YESTERDAY/tomcat-log-backup.tar.gz $TOMCAT_CURRENT_DIR > ${TOMCAT_BACKUP_DIR}/backup_$YESTERDAY/tomcat-log-backup.list
sleep 1;

rm -rf ${TOMCAT_CURRENT_DIR}/*
sleep 1;

find ${TOMCAT_BACKUP_DIR} -mtime +13 -exec rm -rf {} \;

########### Backup Check ##############

echo "##### Backup Report #####"
TT1=`cat ${TOMCAT_BACKUP_DIR}/backup_$YESTERDAY/tomcat-log-backup.list | wc -l`

if [ 1 -eq ${TT1} ]; then
  echo "##### [FAIL] Tomcat Source Backup list is empty #####"
else
  echo "##### [SUCCESS] Tomcat Source Backup is Done #####"
fi
