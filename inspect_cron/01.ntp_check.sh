##### 01.NTP Check #####

# ntp 상태체크
ntpstat > ./ntp_act2.txt 2>&1;

# unsychronised 문자열 추가
check1=`grep -E -i "adjust|no|unsynchronised" ./ntp_act2.txt | wc -l`

/usr/bin/chronyc sources > ./chrony_check.txt 2>/dev/null
check2=`head -n 1 ./chrony_check.txt | awk '{print $1}' 2>/dev/null`

if [ 0 -eq $check1 ] || [ 210 -eq $check2 ]; then
  echo "##### 01 NTP Check ##### [SUCCESS] #####"
else
  echo "##### 01 NTP Check ##### [FAIL] #####"
fi


