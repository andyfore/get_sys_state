#!/bin/bash
#
# Script name: get_sys_state.sh
# Purpose: utility script designed to grab pertinent system state information
# Author: Andrew Fore, andy.fore@arfore.com
# Date originated: 2015-08-10

## Static variables
# Variable name: output_file
# Purpose: stores the preset full path to the output file
output_file="/opt/system_state_`date +%Y%m%d`"

# Create system state file
touch $output_file

echo `date` > $output_file
echo "" >> $output_file
echo "" >> $output_file

# Machine info
echo "############################################" >> $output_file
echo "## Basic System Info" >> $output_file
echo "############################################" >> $output_file
echo "Hostname: `hostname`" >> $output_file
echo "Distribution: `cat /etc/redhat-release`" >> $output_file
echo "Kernel: `uname -a`" >> $output_file
echo "" >> $output_file
echo "" >> $output_file

# User information
echo "############################################" >> $output_file
echo "## User Information" >> $output_file
echo "############################################" >> $output_file
cat /etc/passwd >> $output_file
echo "" >> $output_file
echo "" >> $output_file

# Group information
echo "############################################" >> $output_file
echo "## Group Information" >> $output_file
echo "############################################" >> $output_file
cat /etc/group >> $output_file
echo "" >> $output_file
echo "" >> $output_file

# Shadow information
echo "############################################" >> $output_file
echo "## Shadow file" >> $output_file
echo "############################################" >> $output_file
cat /etc/shadow >> $output_file
echo "" >> $output_file
echo "" >> $output_file

# Filesystem Information
echo "############################################" >> $output_file
echo "## /etc/fstab" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
cat /etc/fstab >> $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## mounted filesystems" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
df -hT | tee -a $output_file
echo "" >> $output_file
echo "" >> $output_file

# Firewall Info
echo "############################################" >> $output_file
echo "## Firewall Service State" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
echo `chkconfig iptables --list` >> $output_file
echo `chkconfig ip6tables --list` >> $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## running iptables configuration" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
/sbin/iptables -L -v -n | tee -a $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## iptables config file" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
cat /etc/sysconfig/iptables-config >> $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## iptables file" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
cat /etc/sysconfig/iptables >> $output_file
echo "" >> $output_file
echo "" >> $output_file

# Network Configuration
echo "############################################" >> $output_file
echo "## /etc/sysconfig/network" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
cat /etc/sysconfig/network >> $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## ip address info" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
ip addr | tee -a $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## running routing table" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
ip ro | tee -a $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## listening ports" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
netstat -ntlp | tee -a $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## start network interface configs" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
for i in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`
do
    echo "-++- $i -++-" >> $output_file
    cat $i >> $output_file
    echo "" >> $output_file
    echo "" >> $output_file
done
echo "############################################" >> $output_file
echo "## routing configs" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
for i in `ls -1 /etc/sysconfig/network-scripts/route-*`
do
    echo "-++- $i -++-" >> $output_file
    cat $i >> $output_file
    echo "" >> $output_file
    echo "" >> $output_file
done

# Get installed package listing
echo "############################################" >> $output_file
echo "## installed package listing" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
rpm -qa | tee -a $output_file
echo "" >> $output_file
echo "" >> $output_file

# Get yum config
echo "############################################" >> $output_file
echo "## YUM config file - /etc/yum.conf" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
cat /etc/yum.conf >> $output_file
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## YUM Repos - /etc/yum.repos.d/" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
for i in `ls -1 /etc/yum.repos.d/*`
do
    echo "-++- $i -++-" >> $output_file
    cat $i >> $output_file
    echo "" >> $output_file
    echo "" >> $output_file
done
