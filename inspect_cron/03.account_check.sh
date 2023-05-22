##### 03.Check Account Expire Date #####

# Input User Name
user1=root

# Alert Expire Time left (days)
alert_expire_time=7

var1=`cat /etc/shadow | grep $user1 | cut -d ':' -f3`
var2=`cat /etc/shadow | grep $user1 | cut -d ':' -f5`
var3=`date -d "1970-01-01 + $var1 day + $var2 day" "+%s"  2>/dev/null`
var4=99999
today=`date "+%s"`

if [ $var2 -eq $var4 ]; then
  echo "##### 03 Check Account Expire Date [SUCCESS] '$user1' Password Never Expire #####"
else
  var5=$(($var3-$today))
  var5=`eval "echo $(date -ud "@$var5" +'$((%s/3600/24))')"`

  if [ $var5 -le $alert_expire_time ]; then
    echo "##### 03 Check Account Expire Date [FAIL] '$user1' password expire $var5 days left #####"
  else
    echo "##### 03 Check Account Expire Date [SUCCESS] '$user1' password expire $var5 days left #####"
  fi
fi

# Input User Name
user2=ncloud

# Alert Expire Time left (days)
alert_expire_time=7

var1=`cat /etc/shadow | grep $user2 | cut -d ':' -f3`
var2=`cat /etc/shadow | grep $user2 | cut -d ':' -f5`
var3=`date -d "1970-01-01 + $var1 day + $var2 day" "+%s"  2>/dev/null`
var4=99999
today=`date "+%s"`

if [ $var2 -eq $var4 ]; then
  echo "##### 03 Check Account Expire Date [SUCCESS] '$user2' Password Never Expire #####"
else
  var5=$(($var3-$today))
  var5=`eval "echo $(date -ud "@$var5" +'$((%s/3600/24))')"`

  if [ $var5 -le $alert_expire_time ]; then
    echo "##### 03 Check Account Expire Date [FAIL] '$user2' password expire $var5 days left #####"
  else
    echo "##### 03 Check Account Expire Date [SUCCESS] '$user2' password expire $var5 days left #####"
  fi
fi

# Input User Name
user3=nec01

# Alert Expire Time left (days)
alert_expire_time=7

var1=`cat /etc/shadow | grep $user3 | cut -d ':' -f3`
var2=`cat /etc/shadow | grep $user3 | cut -d ':' -f5`
var3=`date -d "1970-01-01 + $var1 day + $var2 day" "+%s"  2>/dev/null`
var4=99999
today=`date "+%s"`

if [ $var2 -eq $var4 ]; then
  echo "##### 03 Check Account Expire Date [SUCCESS] '$user3' Password Never Expire #####"
else
  var5=$(($var3-$today))
  var5=`eval "echo $(date -ud "@$var5" +'$((%s/3600/24))')"`

  if [ $var5 -le $alert_expire_time ]; then
    echo "##### 03 Check Account Expire Date [FAIL] '$user3' password expire $var5 days left #####"
  else
    echo "##### 03 Check Account Expire Date [SUCCESS] '$user3' password expire $var5 days left #####"
  fi
fi


