#!/bin/bash
#
# Jinay Mehta
# HW 2 Q28
# Main Script

echo "reading file /etc/cluster_info"
a=`cat /etc/cluster_info | grep parent | cut -f2 -d'='` 
b=`cat /etc/cluster_info | grep child | head -1 | cut -f2 -d'='` 
c=`cat /etc/cluster_info | grep child | tail -1 | cut -f2 -d'='` 


echo "Loading tunneling and gre modules"
/sbin/modprobe tun
/sbin/modprobe ip_gre

echo "Creating ifcfg-gre1 file on A"
rm -f /etc/sysconfig/network-scripts/ifcfg-gre1
echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "DEVICE=gre1" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "TYPE=GRE" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "MY_INNER_IPADDR=192.168.25.11" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "MY_OUTER_IPADDDR="$a >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "PEER_INNER_IPADDR=192.168.25.12" >> /etc/sysconfig/network-scripts/ifcfg-gre1
echo "PEER_OUTER_IPADDR="$b >> /etc/sysconfig/network-scripts/ifcfg-gre1

echo "Creating a Tunnel on A"
sudo /sbin/ip tunnel add gre1 mode gre remote $b local $a
sudo /sbin/ip addr del 192.168.25.11 dev gre1 peer 192.168.25.12 2> /dev/null
sudo /sbin/ip addr add 192.168.25.11 dev gre1 peer 192.168.25.12
sudo /sbin/ip link set gre1 up

sudo /sbin/ip route add 192.168.30.0/24 dev gre1

echo "Setting up B machine"
scp -o "StrictHostKeyChecking no" /etc/cluster_info root@$b:/etc/cluster_info 
scp -o "StrictHostKeyChecking no" setup_b.sh root@$b:~/
ssh -o "StrictHostKeyChecking no" root@$b "dos2unix /root/setup_b.sh"
scp -o "StrictHostKeyChecking no" b_tunnel_sshd_config root@$b:/etc/ssh/b_tunnel_sshd_config
ssh -o "StrictHostKeyChecking no" root@$b "bash /root/setup_b.sh"

echo "Setting up C machine"
scp -o "StrictHostKeyChecking no" setup_c.sh root@$c:~/
ssh -o "StrictHostKeyChecking no" root@$c "dos2unix /root/setup_c.sh"
scp -o "StrictHostKeyChecking no" c_tunnel_sshd_config root@$c:/etc/ssh/c_tunnel_sshd_config
ssh -o "StrictHostKeyChecking no" root@$c "bash /root/setup_c.sh"

echo "Sanity testing on A"
ping -c 4 192.168.25.12
ping -c 4 192.168.30.11
ping -c 4 192.168.30.12

echo "End"
#exit 0
