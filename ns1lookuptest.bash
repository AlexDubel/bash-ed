#!/usr/bin/bash
# That script will get nslookup info from file 
# Script created by: Oleksandr Dubel
# Created at: Пн ноя 30 21:27:16 EET 2020
# Modified at:
# The string below will add color output to your messages if needed
. ./colorsforotherfiles.bash

while read ADDR
do
	nslookup ${ADDR} | tee -a mylookup.log
done < list-ip.txt
