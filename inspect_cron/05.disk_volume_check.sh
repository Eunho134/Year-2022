##### 05.Disk Volume Check #####

df -hP|grep -v none > /cron/disk_act1.txt
awk '{print $5, $6}' /cron/disk_act1.txt > /cron/disk_act2.txt
cat /cron/disk_act2.txt | tr -d '%' > /cron/disk_act3.txt
awk '80 < $1' /cron/disk_act3.txt > /cron/disk_act4.txt
check=`cat /cron//disk_act4.txt | wc -l`

if [ 1 -ne $check ]; then
  echo "##### 05 Disk Volume Check [ALERT] #####"
  cat /cron/disk_act4.txt
else
  echo "##### 05 Disk Volume Check [SUCCESS] #####"
  cat /cron/disk_act4.txt
fi

