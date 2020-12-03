#!/usr/bin/bash

mysubnet="192.168.55."
for i in {1..31}
do
	ping -c1 $mysubnet$i &> /dev/null
#	schostname=nslookup $mysubnet$i | awk '{print  $4}'
#	if [ $? -eq 0 ]; then
#	ll=$schostname
#	fi
nslookuprez=$(nslookup $mysubnet$i | grep name | awk '{print  $4}')
if [ ! -z "${nslookuprez}" ]; then
			if [ $? -eq 0 ]; then
			echo "Ping from host with ipaddr $mysubnet$i and name $nslookuprez is OK"
			else 
			echo "Ping from host with ipaddr $mysubnet$i and name $nslookuprez is not OK"
			fi
		#echo "Ping from $(nslookup 192.168.55.21 | awk '{print  $4}') is OK"
else 
if [ $? -eq 0 ]; then
			echo "Ping from host with ipaddr $mysubnet$i is OK"
			else 
			echo "Ping from host with ipaddr $mysubnet$i is not OK"
			fi
fi
 done	

