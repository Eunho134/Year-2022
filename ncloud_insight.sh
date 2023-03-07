#!/bin/bash

# variable
if [ -f /etc/redhat-release ]; then
    OS=$( cat /etc/redhat-release | awk '{print $1}' )
    OS_MAJOR=$( cat /etc/redhat-release | grep -Po '(?<=release )\d+' )
elif [ $( command -v lsb_release ) ]; then
    OS=$( lsb_release -i 2> /dev/null | awk '{print $3}' )
    OS_MAJOR=$( /bin/cat /etc/lsb-release | grep "DISTRIB_RELEASE" | cut -d '=' -f2 | cut -d '.' -f1 )
fi
VENDOR=$( dmidecode -s system-manufacturer )
if [ "$VENDOR" == "Xen" ]; then
    if [ "$OS_MAJOR" = 12 ] || [ "$OS_MAJOR" = 6 ] || [ "$OS" = "Debian" ] ; then # eol
        AGENT_FILE="agent_controller_linux_ncp_eol_20220830.tar.gz"
    else
        AGENT_FILE="agent_controller_linux_ncp_20220830.tar.gz"
    fi
    AGENT_INSTALL_PARAMETER="gov-classic"
else
    if [ "$OS_MAJOR" = 12 ] || [ "$OS_MAJOR" = 6 ] || [ "$OS" = "Debian" ] ; then # eol
        AGENT_FILE="agent_controller_linux_gov_eol_bm_20220830.tar.gz"
    else
        AGENT_FILE="agent_controller_linux_gov_common_bm_20220830.tar.gz"
    fi
    AGENT_INSTALL_PARAMETER="classic"
fi

AGENT_DIR="/home1/nbpmon"
AGENT_INSTALLER="https://real-repo.nsight.gov-ncloud.com/$AGENT_FILE"

# rc.local modify
function rc_local_remove() {
    RC_LOCAL=$( cat /etc/rc.local | grep nsight )
    if [ -n "$RC_LOCAL" ]; then
        sed --follow-symlinks -i '/nsight/d' /etc/rc.local
        echo
        echo "Delete nsight_updater in /etc/rc.local >> Success"
        echo
    fi
}

# nsight service remove
function nsight_remove() {
    [ -f /home1/nbpmon/noms/nsight/bin/noms_nsight ] && /home1/nbpmon/noms/nsight/bin/noms_nsight -stop
    [ -f /etc/systemd/system/noms_nsight.service ] && systemctl stop noms_nsight.service
    [ -f /etc/systemd/system/noms_nsight.service ] && systemctl disable noms_nsight.service
    rm -rf /home1/nbpmon/noms
    [ -f /home1/nbpmon/nsight_agent_installer.bin ] && rm -f /home1/nbpmon/nsight_agent_installer.bin
    [ -f /home1/nbpmon/nsight_linux_agent_setup.sh ] && rm -f /home1/nbpmon/nsight_linux_agent_setup.sh
    [ -f /home1/nbpmon/nsight_agent_installer.bin.backup ] && rm -f /home1/nbpmon/nsight_agent_installer.bin.backup
    [ -f /home1/nbpmon/nsight_linux_agent_setup.sh.backup ] && rm -f /home1/nbpmon/nsight_linux_agent_setup.sh.backup
    [ -f /etc/init.d/noms_nsight ] && rm -f /etc/init.d/noms_nsight
    [ -f /usr/sbin/nsight_updater ] && rm -f /usr/sbin/nsight_updater
    echo
    echo "Delete NSight Agent(V1) Files >> Success"
    echo
}

# nsight updater cronjob remove
function nsight_updater_remove() {
    if [ $OS == "CentOS" ]; then
        sed -i '/nsight\|MAILTO/d' /var/spool/cron/root
        echo
        echo "Delete nsight_updater in crontab >> Success"
        echo
    elif [ $OS == "Ubuntu" ]; then
        sed -i '/nsight\|MAILTO/d' /var/spool/cron/crontabs/root
        echo
        echo "Delete nsight_updater in crontab >> Success"
        echo
    fi
}


# cloud insight install
function cloud_insight_install() {
   if [ -d /home1/nbpmon/agent_controller_linux ]; then
       systemctl stop nsight-agent
       rm -rf /home1/nbpmon/agent_controller_linux
   fi
   wget -t 1 --timeout=5 --spider ${AGENT_INSTALLER}
   if [[ 0 -eq $? ]]; then
        wget -nv -t 1 --timeout=5 -O ${AGENT_DIR}/${AGENT_FILE} ${AGENT_INSTALLER}
        tar zxvf ${AGENT_DIR}/${AGENT_FILE} -C ${AGENT_DIR}
        bash ${AGENT_DIR}/agent_controller_linux/install_agent.sh ${AGENT_INSTALL_PARAMETER}
        echo
        echo "Install Cloud Insight(V3) Agent Files >> Success"
        echo
   fi
}

function cleansing() {

    local NOMS_NSIGHT="K01noms_nsight"

    REMOVE_FILE_LIST="$AGENT_DIR/$AGENT_FILE"
    for REMOVE_FILE in $REMOVE_FILE_LIST
    do
        rm -f $REMOVE_FILE
    done

    if [ $OS == "CentOS" ]; then
        for ((i=0; i<=6; i++))
        do
            rm -f /etc/rc.d/rc$i.d/$NOMS_NSIGHT
        done
    elif [ $OS == "Ubuntu" ]; then
        for ((i=0; i<=6; i++))
        do
            rm -f /etc/rc$i.d/$NOMS_NSIGHT
        done
    fi
}

# ====================
# | Main Logic Start |
# ====================
rc_local_remove
nsight_remove
nsight_updater_remove
cloud_insight_install
