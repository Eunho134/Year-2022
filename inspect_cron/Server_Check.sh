#!bin/bash
today=`date +%y-%m-%d`

echo "$today Server inspecting..."
sh /cron/inspect_cron/01.ntp_check.sh

sh /cron/inspect_cron/02.sys_check.sh

sh /cron/inspect_cron/03.account_check.sh

sh /cron/inspect_cron/04.uptime_check.sh

sh /cron/inspect_cron/05.disk_volume_check.sh

sh /cron/inspect_cron/06.disk_mount_check.sh 2>/dev/null

sh /cron/inspect_cron/07.process_check.sh

sh /cron/inspect_cron/08.SSL_Certificate.sh

echo "Inspect Done "
