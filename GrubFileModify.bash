#!/usr/bin/bash
# That script will make string manipulation with file /media/dvdRW/EFI/BOOT/grub.cfg 
# Script created by: Oleksandr Dubel
# Created at: 	Thu Dec 17 20:29:14 EET 2020
# Modified at: 	Sun Dec 20 10:25:23 EET 2020

# The string below will add color output to your messages if needed
. ./colorsforotherfiles.bash


#FILETOMODIFY="/home/alex/myscripts/bash-ed/grub.cfg.copy"
FILETOMODIFY="/media/dvdRW/EFI/BOOT/grub.cfg"
#OLDTEXT="Install CentOS Linux 8"
#NEWTEXT="Install CentOS Linux 8.3 with file with answers"
FILETOMODIFY1="/media/dvdRW/EFI/BOOT/grub.cfg1"

echo -e ${lred}===Starting script that will add lines to the grub file===${NC}
#chmod a+w ${FILETOMODIFY}
#cp /media/dvdRW/EFI/BOOT/grub.cfg ${FILETOMODIFY} 
#STRMODIFY=$(cat  ${FILETOMODIFY} | grep -A 4 menuentry | head -4)
#sed -i 's/"${OLDTEXT}"/"${NEWTEXT}/' $FILETOMODIFY
#sed -i 's/Install CentOS Linux 8/Install CentOS Linux 8.3 with file with answers/' $FILETOMODIFY
#cat $FILETOMODIFY | grep "${OLDTEXT}"
#echo $OLDTEXT

#Определяем номер строчки после которой необходимо вставить наш текст. 
#Это строчка в которой содержится второй символ '}'
STRNUMBER=`expr 1 + $(awk '/}/{++n; if (n==2) { print NR; exit}}' $FILETOMODIFY)`	
#STRNUMBER=$(grep -n '}' ./grub.cfg.copy | head -n 2 | awk -F\: '{print $1}')
echo string number = $STRNUMBER
# Получили 4-ре строчки после строки содержащей такой текст. ### BEGIN /etc/grub.d/10_linux ###
# Результат положили в переменную LL

#LL=$(cat $FILETOMODIFY | awk '$0 == "### BEGIN /etc/grub.d/10_linux ###" {i=1;next};i && i++ <= 4')
#echo -e ${green}LL=${cyan}$LL${NC}

LL=$(grep -A 4  'BEGIN' $FILETOMODIFY | grep -v 'BEGIN')
#echo LL=$LL
#cat $FILETOMODIFY > $FILETOMODIFY1
# $LL1 >> $FILETOMODIFY1
#exit
# Получаем название дистрибутива (оно заключено в одинарные кавычки)
LLSTR=$(echo $LL | awk -F\' '{print $2}')
echo LLSTR=$LLSTR

#Заменяем строку, которую мы положили в LLSTR (выглядит примерно как "Install CentOS Linux 8")
#На строку с дополнительным текстом, например добавляем ".3 with file with answers" 
#Получаем Install CentOS Linux 8.3 with file with answers
LL=$(printf  "$LL" | sed  "s/${LLSTR}/${LLSTR}.3 with file with answers/")

###sed -i 's/dvd quiet/dvd quiet ks=cdrom\:\/ks.cfg/' $rwMount/EFI/BOOT/BOOT.conf
LL=$(printf  "$LL" | sed  "s/dvd quiet/dvd quiet ks=cdrom\:\/ks.cfg/")


#echo -e ${green}LL=${cyan}$LL${NC}
printf LL="$LL"
#Добавляем строчку из переменной $LL после строки определенной в переменной $STRNUMBER
#sed "${STRNUMBER}a\ ${LL}" < ${FILETOMODYFY}

#echo STRNUMBER=$STRNUMBER

(cat $FILETOMODIFY | awk -v LL="$LL" "NR==${STRNUMBER}{print LL}1") > $FILETOMODIFY1
cat ${FILETOMODIFY1} > ${FILETOMODIFY}
rm -f ${FILETOMODIFY1}
NameForISO=$(cat $FILETOMODIFY | grep '^search --no-floppy' | awk -F\' '{print $2}')
echo -e ${lred}===End file===${NC}
