#!/bin/sh

# Time (sec) for waite a pulselink
waitetime=120

# Pulse count need for reboot
pulsecount=10

# State IFACE log file:
state_eth_count_file=/var/log/state_eth5_count_file.log

# UnixTime Now
timenow=`date +%s`

if [ -f $state_eth_count_file ] ; then
	# Read count lines in file
	countlines=`sed -n '$=' $state_eth_count_file`
	
	if [ "$countlines" -ge "$pulsecount" ] ; then
		# Read state IFACE log file
		#firsttime=`cat $state_eth_count_file | tail -n +$pulsecount | head -n 1`
		firsttime=`cat $state_eth_count_file | tail -$pulsecount | head -n 1`
		
		if [ -n $firsttime ] ; then
			if [ $[$timenow-$firsttime] -le "$waitetime" ] ; then
				sudo /sbin/reboot
			else
				echo $timenow >> $state_eth_count_file
			fi
		else
			echo $timenow  >> $state_eth_count_file
		fi
	else
		echo $timenow >> $state_eth_count_file
	fi
else
	touch $state_eth_count_file
fi

