#!/bin/bash

. ./colorsforthefiles.bash
#echo red is $red
#echo -e "That text is in ${red}red${NC}"
echo -e ${yellow}"That script is a template to create other scripts"
echo -e "The file will be created in existing directory"
echo -e ".bash extension will be added"${NC}
echo -e ${green}"Please specify a filename that should be created"${NC}
read filename
(echo -n "#!" && which bash) > ./$filename".bash"
echo "# That script will (please add some info about the script)" >> ./$filename".bash" 
echo "# Script created by: Oleksandr Dubel" >> ./$filename".bash"
echo "# Created at: $(date)" >> ./$filename".bash"
echo "# Modified at:" >> ./$filename".bash"
echo "# The string below will add color output to your messages if needed" >> ./$filename".bash"
echo ". ./colorsforthefiles.bash" >> ./$filename".bash"
echo >> ./$filename".bash"
chmod a+x ./$filename".bash"
if [ $? -eq 0 ]; then 
	echo -e ${green} "File ${filename} was created succesfully"${NC}
fi
