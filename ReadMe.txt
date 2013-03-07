This script sets up a tunnel between Two machines on different network and an virtual interface between two machines on the same network. It makes all the appropriate routing table enteries so a connection can be established between the first machine and the last machine.


Instructions and Assumptions
Assumptions:
1.	Script will be run as root
2.	Script Assumes that cluster_info file is present at /etc and it contains the public IP addresses 	of all three machines namely in the format
	Parent=152.x.x.x
	Child=152.x.x.x
	Child=152.x.x.x 
3.	Root login available on B and C through public network using public keys
4.	Instead of conventional tunnel IP addresses mentioned in the HW, different IP addresses have been used to avoid confusion.
They are:
Tunnel IP A: 192.168.25.11
Tunnel IP B: 192.168.25.12
Vinrtual Interface IP A 	     : 192.168.30.11
Virtual Interface IP B		:192.168.30.12
Virttual Interface eth0:25

Instructions:
1.	Unzip SCRIPTSjdmehta at home
2.	Run the command bash SCRIPTjdmehta
3.	The script intermittently pings for sanity so it might appear that code has stopped but it is not so. Please wait for the code to terminate.

PS: Instead of root we could use $USER to make this script more generalized