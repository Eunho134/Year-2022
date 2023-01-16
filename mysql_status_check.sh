# MariaDB Account

user=root
pw="12345678"

###########################################
#               Description               #
###########################################
# If you want to repeat this script       #
# Using 'watch -n [second] [script]       #                                    
###########################################

echo "+-------+-------------------------------+"
current_time=$(date +"%y-%m-%d %H:%M:%S")
printf "|  TIME\t|\t"
echo -e $current_time "\t|"
echo "+-------+-------------------------------+"
echo ""

echo "1. Alive Check"
sudo mysqladmin -u$user -p$pw ping
echo ""

echo "2. CPU, MEM Usage"
echo "+-------+-------+-----------------------+"
echo "|  CPU  |  MEM  |       PROCESS         |"
echo "+-------+-------+-----------------------+"
sudo ps -auxuf | grep mysqld | awk '{print "|  " $3"%\t|  "$4 "%\t| "$12 "\t|"}' | grep mysql
echo "+-------+-------+-----------------------+"
echo ""

echo "3. UPTIME"
echo "+----------+------------+"
sec_time=$(sudo mysql -uroot -p12345678 -N -e "show global status like 'uptime';" -B | awk '{print $2};')
((sec=sec_time%60, sec_time/=60, min=sec_time%60, hrs=sec_time/60))
timestamp=$(sudo printf "%d:%02d:%02d" $hrs $min $sec)
printf "|  UPTIME  | %s\t|\n" $timestamp
echo "+----------+------------+"
echo ""

echo "4. Aborted Clients and Connects"
sudo mysql -u$user -p$pw -t -N -e "show global status like 'Aborted_%';"
echo ""

echo "5. Threads Information"
sudo mysql -u$user -p$pw -t -N -e "show global status like 'Threads_%';"
echo ""

echo "6. Connections Error"
sudo mysql -u$user -p$pw -t -N -e "show global status like 'Connection%';"
echo ""

echo "7. Cluster Status"
sudo mysql -u$user -p$pw -t -N -e "select * from information_schema.GLOBAL_STATUS where VARIABLE_NAME like 'WSREP_CLUSTER%' or VARIABLE_NAME like 'WSREP_CONNECTED' or VARIABLE_NAME like 'WSREP_INCOMING_ADDRESSES' or VARIABLE_NAME like 'WSREP_READY' or VARIABLE_NAME like 'WSREP_LOCAL_STATE%';"
echo ""

echo "--------------------------------------------------------------------------------------"