
sudo sysctl -w net.netfilter.nf_conntrack_max=1048576
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w net.ipv4.tcp_rmem='4096 87380 16777216'
sysctl -w net.ipv4.tcp_wmem='4096 65536 16777216'



Next steps:
1. Reboot the system to ensure all changes take effect:
   sudo reboot

2. After reboot, verify the configuration:
   sudo /usr/local/bin/tcp_monitor.sh

3. Monitor during load testing:
   watch -n5 /usr/local/bin/tcp_monitor.sh

4. Log file location: /var/log/tcp_tuning_20250820_142217.log








 /usr/local/bin/tcp_monitor.sh

sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w net.ipv4.tcp_rmem='4096 87380 16777216'
sysctl -w net.ipv4.tcp_wmem='4096 65536 16777216'






sysctl -w net.ipv4.tcp_fastopen=3




https://peterwoods.online/blog/tuning-linux-for-kubernetes



sysctl -w net.core.rmem_max=8388608
sysctl -w net.core.wmem_max=8388608
sysctl -w net.ipv4.tcp_rmem="4096 87380 8388608"
sysctl -w net.ipv4.tcp_wmem="4096 87380 8388608"
To make the changes persistent across reboots, add the corresponding lines to your /etc/sysctl.conf file. Remember to run sysctl -p to reload the configuration from the file.

net.core.rmem_max=8388608
net.core.wmem_max=8388608
net.ipv4.tcp_rmem=4096 87380 8388608
net.ipv4.tcp_wmem=4096 87380 8388608
The ring parameters on a network interface refer to the settings that control the size and behavior of the receive (RX) and transmit (TX) rings. These rings are data structures used by the network driver to buffer incoming and outgoing network packets. The ring parameters can affect network performance and behavior, especially in high-throughput or low-latency scenarios. Use the ethtool command to check the current settings for your network interfaces.

ethtool -g <interface>
For example:

$ ethtool -g eth0
Ring parameters for eth0:
Pre-set maximums:
RX:             18139
RX Mini:        0
RX Jumbo:       0
TX:             2560
Current hardware settings:
RX:             9362
RX Mini:        0
RX Jumbo:       0
TX:             170
To modify the buffer sizes, use the following commands:

ethtool -G <interface> rx <buffersize>
ethtool -G <interface> tx <buffersize>
For example:

ethtool -G eth0 rx 18139 
ethtool -G eth0 tx 2560




Files and Processes
Increase file descriptor limits. Kubernetes uses many file descriptors, so it's beneficial to increase the file descriptor limits to avoid reaching the system limits. A common recommendation is to set the file descriptor limits to at least 102,400 (soft limit) and 102,400 (hard limit). These values should be sufficient for most Kubernetes clusters. However, for larger deployments or clusters with heavy workloads, you may need to further increase these limits.

*         soft    nofile      102400
*         hard    nofile      102400
These lines set the soft and hard limits for the maximum number of open file descriptors (nofile) to 102,400 for all users. After making the changes, you may need to log out and log back in for the changes to take effect. You can verify the new limits using the ulimit -n command.





