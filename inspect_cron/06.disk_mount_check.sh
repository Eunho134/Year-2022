##### 06.Disk Mount Check #####

DF2=`df -hP | grep -E -v "none|tmpfs|Filesystem" | wc -l`
DF1=`cat /cron/disk_num.txt 2>/dev/null`

if [ $DF1 == $DF2 ]; then
  echo "##### 06 Disk Mount Check [SUCCESS] #####"
else
  echo "##### 06 Disk Mount Check [FAIL] #####"
  df -hP | grep -E -v "none|tmpfs|Filesystem" | awk '{print $1, $6}'
fi

echo $DF2 > /cron/disk_num.txt
