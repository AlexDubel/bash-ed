#!/usr/bin/bash
# That script will test who case statemnt works
# Script created by: Oleksandr Dubel
# Created at: Sun Dec 27 10:48:17 EET 2020
# Modified at:
# The string below will add color output to your messages if needed
. ./colorsforthefiles.bash


case "${1}" in 
	[sS][tT]?[rR]t|St?rt) 	echo "Starting" ;;
	stop|Stop|STOP)		echo "Stoping"	;;
	status|Status|STATUS)	echo "Status"	;;
	*) 
	echo "${1}" is invalid option; exit 1 ;;
esac

