#!/usr/bin/bash
# That script will (add info)
# Script created by Oleksandr Dubel
# Created at Сб ноя 28 17:31:44 EET 2020
# Modified

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
#And then use them like this in your script:

#    .---------- constant part!
#    vvvv vvvv-- the code from above
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
lgrey='\033[0;37m'
dgrey='\033[1;30m'
lred='\033[1;31m'
lgreen='\033[1;32m'
yellow='\033[1;33m'
lblue='\033[1;34m'
lpurple='\033[1;35m'
lcyan='\033[1;36m'
white='\033[1;37m'
NC='\033[0m' # No Color
for color in black red green brown blue purple cyan lgrey dgrey lred lgreen yellow lblue lpurple lcyan white
do
case $color in
	black) echo -e That text is in $black ${color} color${NC};;
	red)   echo -e That text is in $red ${color}  color${NC};;
	green) echo -e That Text is in $green $color color${NC};;
	brown) echo -e That Text is in $brown $color color${NC};;
#	*) echo 333;;
	esac
#	echo -e That text is in ${color} color${NC}
done
echo "if you can see one string only with part text it is mean that text is in black :)"
#printf "I ${red}love${NC} Stack Overflow\n"
#echo -e "${yellow}That also work with echo command${NC}"
