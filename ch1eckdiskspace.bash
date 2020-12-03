#!/usr/bin/bash
# That script will (please add some info about the script)
# Script created by: Oleksandr Dubel
# Created at: Вт дек  1 13:29:32 EET 2020
# Modified at:
# The string below will add color output to your messages if needed
. ./colorsforotherfiles.bash

df -h | tail -n+2 | egrep -v "tmpfs|devtmpfs|sr0" | awk '{print $1, $5}' | while read myvar
do
	percentusage=$(echo $myvar | awk '{print $2}' | cut -d'%' -f1 )
	partname=$(echo $myvar | awk '{print $1}' )
	echo -e -n ${yellow}$partname${NC}" uses "
	echo -e ${purple}$percentusage${NC}" of space" at ${green}$(hostname)${NC} as on ${green}$(date)${NC}
done
