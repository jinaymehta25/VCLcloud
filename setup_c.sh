#!/bin/bash
#setup_b
#Jinay Mehta
#


echo "Creating Virtual Interface"
/sbin/ifconfig eth0:25 192.168.30.12
/sbin/route add -net 192.168.25.0 netmask 255.255.255.0  gw 192.168.30.11 dev eth0

echo "Starting SSH Daemon on 192.168.30.x network"
/usr/sbin/sshd -f /etc/ssh/c_tunnel_sshd_config

echo "Sanity Testing on C"
ping -c 4 192.168.30.11
ping -c 4 192.168.25.11