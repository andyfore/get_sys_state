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

## Non-Static Variables
# Variable name: os_type
# Purposes: holds the type of OS on the system for use in 
#           determining what commands to run
os_type=""

# Get the OS type
# Currently we can differentiate between AIX, Linux and Solaris
os_type=`uname`

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
case $os_type in
	Linux) echo "Running: $os_type" >> $output_file
           if [ -f /etc/redhat-release ]
           then
               echo "RedHat-Based Distro: `cat /etc/redhat-release`" >> $output_file
           elif [ -f /etc/debian_version ]
           then
               echo "Debian-Based Distro: `cat /etc/debian_version`"  >> $output_file
           elif [ -f /etc/gentoo-release ]
           then
               echo "Gentoo-Based Distro: `cat /etc/gentoo-release`"  >> $output_file
           fi
           echo "Kernel: `uname -a`" >> $output_file
           ;;
    AIX)   echo "Running: $os_type" >> $output_file
           echo "Version: `uname -v`" >> $output_file
           echo "Release: `uname -r`" >> $output_file
           echo "Base System Level: `oslevel`" >> $output_file
           echo "Highest TL: `oslevel -r`" >> $output_file
           echo "Highest Service Pack: `oslevel -s`" >> $output_file
           ;;
    SunOS) echo "Running: $os_type" >> $output_file
           echo "Architecture type: `isainfo -kv`" >> $output_file
           echo "Processor type: `uname -p`" >> $output_file
           echo "Version: `uname -r`" >> $output_file
           if [ `uname -r` == "5.11" ]; then
                pkg info kernel | tee -a $output_file
           else
                echo "Kernel: `uname -v`" >> $output_file
           fi
           ;;
esac
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
case $os_type in
	Linux)   echo "############################################" >> $output_file
           echo "## /etc/fstab" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           cat /etc/fstab >> $output_file
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## /etc/filesystems" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           cat /etc/filesystems >> $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## /etc/vfstab" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           cat /etc/vfstab >> $output_file
           ;;
esac
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## Mounted Filesystems" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
mount | tee -a $output_file
echo "" >> $output_file
echo "" >> $output_file
# Filesystem Usage
case $os_type in
	Linux)   echo "############################################" >> $output_file
           echo "## Filesystem Usage" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           df -hT | tee -a $output_file
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## Filesystem Usage" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           df -Pg | tee -a $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## Filesystem Usage" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           df -h | tee -a $output_file
           ;;
esac
echo "" >> $output_file
echo "" >> $output_file
# Firewall Info
case $os_type in
	Linux)   echo "############################################" >> $output_file
           echo "## Firewall Service State" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           echo `chkconfig iptables --list` >> $output_file
           echo `chkconfig ip6tables --list` >> $output_file
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## Firewall Service State" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           echo `lslpp -l | grep ipf` >> $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## Firewall Service State" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           echo `svcs -a | grep ipfilter` >> $output_file
           ;;
esac
echo "" >> $output_file
echo "" >> $output_file
case $os_type in
	Linux)   echo "" >> $output_file
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
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## Firewall Configuration" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           echo `lsfilt` >> $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## Firewall Configuration" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           cat /etc/ipf/ipf.conf >> $output_file
           ;;
esac
echo "" >> $output_file
echo "" >> $output_file
# Network Configuration
case $os_type in
	Linux)   echo "############################################" >> $output_file
           echo "## Generic Network Info" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           cat /etc/sysconfig/network >> $output_file
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## Generic Network Info" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           netstat -r | grep default >> $output_file
           echo `hostname` >> $output_file
           echo `domainname` >> $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## Generic Network Info" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           netstat -r | grep default >> $output_file
           echo `hostname` >> $output_file
           echo `domainname` >> $output_file
           ;;
esac
echo "" >> $output_file
echo "" >> $output_file
echo "############################################" >> $output_file
echo "## ip address info" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
ifconfig -a | tee -a $output_file
echo "" >> $output_file
echo "" >> $output_file
case $os_type in
	Linux)   echo "############################################" >> $output_file
           echo "## Routing Table" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           ip ro | tee -a $output_file
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## Routing Table" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           netstat -rn >> $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## Routing Table" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           netstat -rn >> $output_file
           ;;
esac
echo "" >> $output_file
echo "" >> $output_file
case $os_type in
	Linux)   echo "############################################" >> $output_file
           echo "## Listening Ports" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           netstat -ntlp | tee -a $output_file
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## Listening Ports" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           netstat -an | grep -i listen >> $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## Listening Ports" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           netstat -an | grep -i listen >> $output_file
           ;;
esac
echo "" >> $output_file
echo "" >> $output_file
case $os_type in
	Linux) echo "############################################" >> $output_file
           echo "## Network Interface Configuration" >> $output_file
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
           echo "## Routing Configuration Files" >> $output_file
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
           echo "" >> $output_file
           echo "" >> $output_file
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## Network Interface Configuration" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           for i in `lsdev -Cc if | grep en | awk '{print $1}'`; do echo "-++- $i -++-"; lsattr -El $i; echo ""; done >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## Interface Files" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           for i in `ls -1 /etc/hostname.*`; do echo "-++- $i -++-"; cat $i; echo ""; done >> $output_file
           echo "-++- /etc/nodename -++-" >> $output_file
           cat /etc/nodename >> $output_file
           echo "-++- /etc/defaultdomain -++-" >> $output_file
           cat /etc/defaultdomain >> $output_file
           echo "-++- /etc/defaultrouter -++-" >> $output_file
           cat /etc/defaultrouter >> $output_file
           echo "-++- /etc/hosts -++-" >> $output_file
           cat /etc/hosts >> $output_file
           echo "-++- /etc/netmasks -++-" >> $output_file
           cat /etc/netmasks >> $output_file
           ;;
esac

case $os_type in
	Linux)   echo "############################################" >> $output_file
           echo "## installed package listing" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           rpm -qa | sort | tee -a $output_file
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## installed package listing" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           lslpp -w >> $output_file
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## installed package listing" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           pkginfo >> $output_file
           ;;
esac
echo "" >> $output_file
echo "" >> $output_file

# Get yum config
case $os_type in
	Linux) echo "############################################" >> $output_file
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
           ;;
esac

# Get the crontabs for all users
case $os_type in
	Linux)   echo "############################################" >> $output_file
           echo "## user crontabs" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           for i in `ls -1 /var/spool/cron/*`
           do
               echo "-++- $i -++-" >> $output_file
               cat $i >> $output_file
               echo "" >> $output_file
               echo "" >> $output_file
           done
           ;;
    AIX)   echo "############################################" >> $output_file
           echo "## user crontabs" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           for i in `ls -1 /var/spool/cron/crontabs/*`
           do
               echo "-++- $i -++-" >> $output_file
               cat $i >> $output_file
               echo "" >> $output_file
               echo "" >> $output_file
           done
           ;;
    SunOS) echo "############################################" >> $output_file
           echo "## user crontabs" >> $output_file
           echo "############################################" >> $output_file
           echo "" >> $output_file
           echo "" >> $output_file
           for i in `ls -1 /var/spool/cron/crontabs/*`
           do
               echo "-++- $i -++-" >> $output_file
               cat $i >> $output_file
               echo "" >> $output_file
               echo "" >> $output_file
           done
           ;;
esac

# Get the MPIO config
echo "############################################" >> $output_file
echo "## /etc/multipath.conf" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
cat /etc/multipath.conf >> $output_file
echo "" >> $output_file
echo "" >> $output_file

# Get the multipath udev rules config
echo "############################################" >> $output_file
echo "## /etc/udev/rules.d/*-multipath.rules" >> $output_file
echo "############################################" >> $output_file
echo "" >> $output_file
echo "" >> $output_file
ls -l /etc/udev/rules.d/*-multipath.rules >> $output_file
cat /etc/udev/rules.d/*-multipath.rules >> $output_file
