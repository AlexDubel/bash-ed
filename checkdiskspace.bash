#!/usr/bin/bash
# That script will (please add some info about the script)
# Script created by: Oleksandr Dubel
# Created at: Вт дек  1 13:29:32 EET 2020
# Modified at:
# The string below will add color output to your messages if needed
. ./colorsforthefiles.bash

diskusage=`df -h | tail -n+2 | egrep -v "tmpfs|devtmpfs|sr0" | awk '{print $1, $5}'`
diskname=`df -h | tail -n+2 | egrep -v "tmpfs|devtmpfs|sr0" | awk '{print $1, $5}'`
echo -e ${yellow}diskusage=${NC}$diskusage
exit
diskusagenumber=`echo $diskusage | awk '{print $2}' | cut -d'%' -f1`
echo -e ${yellow}diskusage=${NC}$diskusage
echo -e ${yellow}diskusagenumber=${NC}$diskusagenumber
exit
for usage in `$diskusagenumber | awk '{print $2}' | cut -d'%' -f1`
do
	if [ $usage -ge 50 ]; then
	echo check disk space of 
	fi
done
