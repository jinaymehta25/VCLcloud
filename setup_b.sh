#!/bin/bash
#setup_b
#Jinay Mehta
#


echo "reading file /etc/cluster_info"
a=`cat /etc/cluster_info | grep parent | cut -f2 -d'='`
b=`cat /etc/cluster_info | grep child | head -1 | cut -f2 -d'='` 
c=`cat /etc/cluster_info | grep child | tail -1 | cut -f2 -d'='` 

echo "Loading tunneling and gre modules"
/sbin/modprobe tun
/sbin/modprobe ip_gre

echo "Creating ifcfg-gre1 file on B"
rm -f /etc/sysconfig/network-scripts/ifcfg-gre1
echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "DEVICE=gre1" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "TYPE=GRE" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "MY_INNER_IPADDR=192.168.25.12" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "MY_OUTER_IPADDDR="$b >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "PEER_INNER_IPADDR=192.168.25.11" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "PEER_OUTER_IPADDR="$a >> /etc/sysconfig/network-scripts/ifcfg-gre1

echo "Creating a Tunnel on B"
/sbin/ip tunnel add gre1 mode gre remote $a local $b
/sbin/ip addr del 192.168.25.12 dev gre1 peer 192.168.25.11 2> /dev/null
/sbin/ip addr add 192.168.25.12 dev gre1 peer 192.168.25.11
/sbin/ip link set gre1 up

echo 1 > /proc/sys/net/ipv4/ip_forward

echo "Disabling firewalls"
/etc/init.d/iptables stop

echo "Creating Virtual Interface"
/sbin/ifconfig eth0:25 192.168.30.11

echo "Starting SSH Daemon on 192.168.30.x network"
/usr/sbin/sshd -f /etc/ssh/b_tunnel_sshd_config


echo "Sanity Testing on B"
ping -c 4 192.168.25.11