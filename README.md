# get_sys_state.sh
A utility script designed to grab pertinent system state information

**Script name** get_sys_state.sh

*Created* 2015-08-10

*Original Author* Andrew Fore [andy.fore@arfore.com](mailto:andy.fore@arfore.com)

**File List**

* get_sys_state.sh - this is the main script file

##Info
Currently the script is designed around grabbing data from a RedHat 6 or less system.

##Usage

Currently the script takes no commandline options

```bash
# get_sys_state.sh
```

##To Do
- Cleanup redundnant header printouts
- Reorganize the code so that it flows better

##What the script gets
- Hostname of the system
- Running system info provided by output of *uname -a*
- Contents of */etc/fstab*
- Output of the current filesystem listing in human readable with partition type
- Runlevels of the iptables and ip6tables services
- Current iptables configuration file contents
- Currently running iptables ruleset
- Contents of the iptables ruleset file on disk
- Contents of */etc/sysconfig/network*
- Currently running ip address state
- Currently running routing table
- Currently running network state of listening ports
- Contents of network interface configuration files
- Contents of network interface routing files
- Currently installed RPMs list
- Contents of the yum config file
- Contents of the yum repository files
- Contents of */etc/passwd*
- Contents of */etc/group*
- Contents of */etc/shadow*
- MPIO rules
- DM permission rules
