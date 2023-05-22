#!/bin/sh

Pro1=
check=`ps -ef | grep $Pro1 | wc -l`

echo "##### 07 Process check #####"

if [ $check -lt 1 ]; then
        echo "##### $Pro1 was not runnig! [FAIL] #####"
else
        echo "##### $Pro1 status [SUCCESS] #####"
fi

