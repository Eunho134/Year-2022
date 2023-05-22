##### 04.uptime Check #####

day=`uptime |awk '{printf $3}' 2>/dev/null`

if [ 1 -gt $day ]; then
  echo "##### 04 uptime Check [Alert] Uptime= $day #####"
else
  echo "##### 04 uptime Check [SUCCESS] #####"
fi

