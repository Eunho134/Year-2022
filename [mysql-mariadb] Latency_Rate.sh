#!/usr/bin/expr
# mysql/mariadb Latency Rate

Latency_log=""      # Latency Rate log path

dbpass=""           # mysql/mariadb path
user=""             # mysql/maraidb user name
password=""         # mysql/maraidb password

sh $dbpass/bin/mysql -u $user -p $password mysql -e "show status where variable_name like 'Table_locks%';" >> $Latency_log/Latency.log

cd $Latency_log;

Table_locks_immediate=awk 'NR == 2 {print $2}' ./Latency.log
Table_locks_waited=awk 'NR == 3 {print $2}' ./Latency.log

var1=$(($Table_locks_waited + $Table_locks_immediate))
var2=expr $Table_locks_immediate \* 100
var3=expr $var2 / $var1

i4=80               # Alarm 임계치

if [ $var3 -lt $i4 ]; then
        echo "[ALERT] Latency Rate = $var3"
fi