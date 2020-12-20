#!/usr/bin/bash
# That script will (add info)
# Script created by Oleksandr Dubel
# Created at Сб ноя 28 17:31:44 EET 2020
# Modified

#Black        0;30     Dark Gray     1;90
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;90     White         1;37
#And then use them like this in your script:

#    .---------- constant part!
#    vvvv vvvv-- the code from above
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
orange='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
lgrey='\033[0;30m'
dgrey='\033[1;30m'
lred='\033[1;31m'
lgreen='\033[1;32m'
yellow='\033[1;33m'
lblue='\033[1;34m'
lpurple='\033[1;35m'
lcyan='\033[1;36m'
white='\033[1;37m'
NC='\033[0m' # No Color
for color in black red green orange blue purple cyan lgrey dgrey lred lgreen yellow lblue lpurple lcyan white
do
case $color in
	black) 	echo -e $black That text is in 		$color 	color${NC}#Black color;;
	red)   	echo -e $red That text is in 		$color 	color${NC};;
	green) 	echo -e $green That text is in 		$color 	color${NC};;
	orange)	echo -e $orange That text is in		$color 	color${NC};;
	blue) 	echo -e $blue That text is in 		$color 	color${NC};;
	purple)	echo -e $purple That text is in 	$color	color${NC};;
	cyan)	echo -e $cyan That text is in		$color 	color${NC};;
	lgrey)	echo -e $lgrey That text is in  	$color  color${NC};;
        dgrey)	echo -e $dgrey That text is in		$color  color${NC};;
        lred)	echo -e $lred That text is in		$color 	color${NC};;
        lgreen)	echo -e $lgreen That text is in 	$color  color${NC};;
        yellow)	echo -e $yellow That text is in		$color  color${NC};;
        lblue)	echo -e $lblue That text is in 		$color  color${NC};;
	lpurple)echo -e $lpurple That text is in  	$color  color${NC};;
	lcyan)	echo -e $lcyan That text is in		$color  color${NC};;
        white)  echo -e $white That text is in  	$color  color${NC};;


#	*) echo 333;;
	esac
#	echo -e That text is in ${color} color${NC}
done
echo "If you can see one string only with part text it is mean that text is in black :)"
#printf "I ${red}love${NC} Stack Overflow\n"
#echo - "${yellow}That also work with echo command${NC}"
