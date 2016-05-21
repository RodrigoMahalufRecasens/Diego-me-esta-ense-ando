#!/bin/sh

###########################################################
# Net configuration
# 
# recordar setear red en cada pc:
#  - connection name: "bendernet"
#  - (general) conectar automaticamente
#  - (ipv4): Method: Manual
#  - (ipv4): address: 192.168.0.X
#  - (ipv4): address: 255.255.255.X
#  - (ipv4): address: 192.168.1.1
#  - (ipv4-routes): Use this connection only for 
#                   resources on this network
###########################################################
 
export BENDER_NET_IP_CHEST="192.168.0.10"
export BENDER_NET_IP_VISION="192.168.0.20"
export BENDER_NET_IP_NAV="192.168.0.30"

_bender_net_parse_ip ()
{
	local ipname
	ipname="$1"
	if [ "$ipname" = "chest" ]; then
		printf "%s" "$BENDER_NET_IP_CHEST"
	elif [ "$ipname" = "vision" ]; then
		printf "%s" "$BENDER_NET_IP_VISION"
	elif [ "$ipname" = "nav" ]; then
		printf "%s" "$BENDER_NET_IP_NAV"
	else
		printf "%s" "$ipname"
	fi
}


# utilizados por ros
export ROS_MASTER_URI="http://$(_bender_net_parse_ip "$BENDER_NET_MASTER"):11311"
export ROS_IP="$(_bender_net_parse_ip "$BENDER_NET_IP")"
export ROSLAUNCH_SSH_UNKNOWN="1"
