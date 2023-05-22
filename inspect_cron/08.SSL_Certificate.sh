#!/bin/sh

expire_date="20240108"
warning_date=`date +"%G%m%e"`

check1=$(($expire_date - $warning_date))

echo "##### 08 ssl certificate check #####"

if [ $check1 -le 30 ]; then
        echo "##### SSL Certificate expires one month ago [ALERT] #####"
else
        echo "##### [SUCCESS] #####"
fi

