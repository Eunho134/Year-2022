#!/bin/bash --login
# Daily Check 


##### 01.NTP Check #####

/usr/sbin/ntpdate time.bora.net > ./ntp_act1.txt 2>&1;
check1=`grep -E "adjust|no" ./ntp_act1.txt | wc -l`
chronyc sources > ./chrony_check.txt
check2=`head -n 1 ./chrony_check.txt | awk '{print $1}' 2>/dev/null`

function do_ntp_Check() {
  if [ 0 -eq $check1 -o 210 -eq $check2 ]; then
    echo "##### 01.NTP Check ##### [SUCCESS]"
  else
    echo "##### 01.NTP Check ##### [FAIL]"
  fi
}

do_ntp_Check

##### 02.Sys Log Check #####

TODAY=`date '+%b  %-d'`

PATTERN="grep -ve rtc_cmos -ve ACPI -ve nagios -ve Failed.*to.*change.*password -ve unable.*to.*open.*console -ve procheader.*error -ve gnome-keyring-daemon -ve seahorse-daemon -ve ERST -ve rpc.statd -ve .*error.*in.*address.*'::.*' -ve sd.forwarder -ve sd.collector -ve pts/1i -ve sd_journal_get_cursor -ve avast -ve rtvscand.*Could.*not.*scan -ve authentication.*failure -ve rtvscand.*Scan.*could.*not.*open.*file -ve *error.*retrieving.*information.*about.*user -ve sd.forwarder -ve sd.collector" -ve FAILED.*SU
ERR_COUNT=`cat /var/log/messages | egrep -i 'error|fail' | ${PATTERN} | egrep "${TODAY}" | wc -l`

if [ ${ERR_COUNT} -eq 0 ]; then
  echo "##### 02.Sys Log Check ##### [SUCCESS]"
else
  echo "##### 02.Sys Log Check ##### [FAIL]"
fi

##### 03.Check Account Expire Date #####

# Input User Name
user=centos

# Alert Expire Time left (days)
alert_expire_time=7

var1=`cat /etc/shadow | grep $user | cut -d ':' -f3`
var2=`cat /etc/shadow | grep $user | cut -d ':' -f5`
var3=`date -d "1970-01-01 + $var1 day + $var2 day" "+%s"  2>/dev/null`
var4=99999
today=`date "+%s"`

if [ $var2 -eq $var4 ]; then
  echo "##### 03 Check Account Expire Date ##### [SUCCESS] '$user' Password Never Expire"
else
  var5=$(($var3-$today))
  var5=`eval "echo $(date -ud "@$var5" +'$((%s/3600/24))')"`

  if [ $var5 -le $alert_expire_time ]; then
    echo "##### 03 Check Account Expire Date ##### [FAIL] '$user' password expire $var5 days left "
  else
    echo "##### 03 Check Account Expire Date ##### [SUCCESS]"
  fi
fi

##### 04.uptime Check #####

uptime |awk '{printf $3}'
if (( uptime |awk '{print $3}' < 1 )); then
echo "day 01.uptime Check [FAIL]"
else
echo "day 01.uptime Check [SUCCESS]"
fi

##### 05.Disk Volume Check #####

df -hP|grep -v tmpfs > ./disk_act1.txt
awk '{print $5, $6}' ./disk_act1.txt > ./disk_act2.txt
awk '$1 >80' ./disk_act2.txt > ./disk_act3.txt
check=cat ./disk_act3.txt | grep -i "%" | wc -l

function do_Disk_Volume_Check() {
if [ 1 -ne $check ]; then
echo "##### 04.Disk Volume Check ##### [ALERT]"
cat ./disk_act3.txt
else
echo "##### 04.Disk Volume Check ##### [SUCCESS]"
cat ./disk_act2.txt
fi
}
do_Disk_Volume_Check

##### 06.Disk Mount Check #####

DF2=df -hP|grep -v tmpfs | wc -l
if [ "$DF1" == "$DF2" ]; then
echo "##### 07 Disk Mount Check ##### [SUCCESS]"
elif [ "$DF1" != "$DF2" ]; then
echo "##### 07 Disk Mount Check ##### [FAIL]"
fi
touch /etc/profile.d/test.sh
echo "export DF1=$DF2" > /etc/profile.d/test.sh
source /etc/profile.d/test.sh

##### 07.Filesystem I/O Check #####

DATE=date +"%Y%m%d%H%M%S"
for i in $(cat /proc/mounts  | egrep 'ext3|ext4|xfs' |awk '{print $2}')
do
var1=$(dd if=/dev/zero of=${i}/write_test_${DATE}.txt bs=4k conv=fsync,sync count=1 2>&1)
ifA=$?

cat ${i}/write_test_${DATE}.txt 2>/dev/null

ifB=$?
rm -f ${i}/write_test_${DATE}.txt

if [ "$ifA" == 0 ]&&[ "$ifB" == 0 ]; then
printf "##### 08 Filesystem I/O Check ##### ${i}[Success]\n"
elif [ "$ifA" != 0 ]&&[ "ifB" != 0 ]; then
printf "##### 08 Filesystem I/O Check ##### ${i}[FAIL]\n"
fi
done