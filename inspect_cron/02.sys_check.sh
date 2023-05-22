##### 02.Sys Log Check #####

TODAY=`LANG=C date "+%b %-d"`
sys_log="/var/log/messages"
sys_path="/cron/sys"
DATE=`date +"%G%m%e"`

PATTERN="grep -ve rtc_cmos -ve ACPI -ve nagios -ve Failed.*to.*change.*password -ve unable.*to.*open.*console -ve procheader.*error -ve gnome-keyring-daemon -ve seahorse-daemon -ve ERST -ve rpc.statd -ve .*error.*in.*address.*'::.*' -ve sd.forwarder -ve sd.collector -ve pts/1i -ve sd_journal_get_cursor -ve avast -ve rtvscand.*Could.*not.*scan -ve authentication.*failure -ve rtvscand.*Scan.*could.*not.*open.*file -ve *error.*retrieving.*information.*about.*user -ve sd.forwarder -ve sd.collector -ve FAILED.*SU"
ERR_COUNT=`cat $sys_log | egrep -i 'error|fail' | ${PATTERN} | egrep "${TODAY}" | wc -l`
OOM_COUNT=`cat $sys_log | egrep -i 'Out of memory' | ${PATTERN} | egrep "${TODAY}" | wc -l`

if [ ${ERR_COUNT} -eq 0 ] && [ ${OOM_COUNT} -eq 0 ]; then
  echo "##### 02 Sys Log Check [SUCCESS] #####"
else
  echo "##### 02.Sys Log Check [FAIL] ######"
  sleep 1;
  cat $sys_log | egrep -i 'error|fail' | ${PATTERN} | egrep "${TODAY}" > $sys_path/error.log 2>/dev/null
  cat $sys_log | egrep -i 'Out of memory' | ${PATTERN} | egrep "${TODAY}" $sys_path/error.log 2>/dev/null
fi

