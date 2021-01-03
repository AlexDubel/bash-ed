#!/usr/bin/bash

# That script will add submenu with config file (ks.cfg) to iso with CENTOS 8.3 installation  
# Script created by: Oleksandr Dubel

# Created at: 	Wed Dec  2 15:41:44 EET 2020
# First version of script was areated for 8.2 version of CentOS

# Modified at: 	Sun Dec 20 10:25:23 EET 2020
# All modification to the file are described via -m key during git commit. 

#. ./colorsforthefiles.bash
#source $(pwd)/myscripts/bash-ed/colorsforthefiles.bash
DIRTOINCLUDE="${BASH_SOURCE%/*}"
if [[ ! -d "$DIRTOINCLUDE" ]]; then DIRTOINCLUDE="$PWD"; fi
# The string below will add color output to your messages if needed
. "$DIRTOINCLUDE/colorsforthefiles.bash"

readonly media="/media"
readonly roMount="${media}/dvdRO"
readonly rwMount="${media}/dvdRW"
# you should modify grub.cfg file is you are using SecureBoot under MS Hyper-V
#kstocfg="/EFI/BOOT/grub.cfg"
#kstocfg="isolinux/isolinux.cfg"
#addks="ks=cdrom:/ks.cfg"
#Name from file /media/dvdRW/isolinux/isolinux.cfg is CentOS-8-2-2004-x86_64-dvd string begins with append initrd=
#NameForISO="CentOS-8-3-2011-x86_64-dvd"

if [[ "$EUID" -ne 0 ]]; then
echo -e ${red}"That script should be run as root"
echo -e Exiting...${NC}
exit 1
fi

MediaMountAndCopyFiles ()
# Cleaning up; Removing calatogs if exist
	{
	umount $roMount
	rm -rf "${media:?}/"*
	#rm -Rf /media/*
	for catalog in $roMount $rwMount
	do
	# Creating catalog if it is not exist
		if [ ! -d "$catalog" ]; then
			echo -e ${cyan}Catalog $catalog does not exist.
			echo -e Creating...${NC}
			mkdir $catalog
			if [ $? -eq 0 ]; then
				echo -e ${green}"Catalog $catalog successfully created"${NC}
			else
				echo -e ${red}"Catalog $catalog was not created."
				echo -e Exiting...${NC}
				exit 100
			fi
		fi
	done

	echo -e ${cyan}Read-only mounting dvd to $roMount
	mount /dev/sr0 $roMount -o ro
	if [ $? -eq 0 ]; then
		a=$?
		echo -e ${green}Mounted successfully ${NC}
		else
		echo -e ${red} Can not mount DVD to $roMount catalog error code $a
		echo -e Exiting${NC}
		exit 101
	fi

	echo -e ${cyan}Copying data from $roMount to $rwMount${NC}
	shopt -s dotglob
	cp -aRf $roMount/* $rwMount
		if [ $? -eq 0 ];then
			echo -e ${green}Catalog copied successfully${NC} else 
			echo -e ${red}Catalog copied with errors.  
			echo -e Exiting...  
			exit 102 
		fi 
		echo -e ${cyan}Copying file from /root/anaconda-ks.cfg to $rwMount/ks.cfg 
		cp /root/anaconda-ks.cfg $rwMount/ks.cfg 
		if [ $? -eq 0 ]; then 
		echo -e ${green}"File copied successfully"${NC} 
		echo -e ${cyan}Unmounting $roMount${NC} umount $roMount
	else
		echo -e ${red}Something went wrong. File was not copied.
		echo -e Exiting...
		exit 103
	fi
}
#The line below can be commented to the debug purpose
#MediaMountAndCopyFiles

#echo 999
# The file below will add needed information to the grub.cfg file
#. "$DIRTOINCLUDE/colorsforthefiles.bash"
# shellcheck source=/home/alex/myscripts/bash-ed/GrubFileModify.bash
. "$DIRTOINCLUDE/GrubFileModify.bash"
#echo isoname=$ISONAME



#sed -i 's/dvd quiet/dvd quiet ks=cdrom\:\/ks.cfg/' $rwMount/$kstocfg
#sed -i 's/dvd quiet/dvd quiet ks=cdrom\:\/ks.cfg/' $rwMount/EFI/BOOT/BOOT.conf
cd $rwMount/ || { echo -e ${red}"Can't cd to $rwMount catalog"${NC}; exit 104; }
echo -e ${cyan}"Writing ISO file"${NC}
#sleep 2
genisoimage -U -r -v -T -J\
        -joliet-long\
       	-V "$NameForISO"\
       	-volset "$NameForISO"\
       	-A "$NameForISO"\
       	-b isolinux/isolinux.bin\
       	-c isolinux/boot.cat\
       	-no-emul-boot\
       	-boot-load-size 4\
       	-boot-info-table\
       	-eltorito-alt-boot\
       	-e images/efiboot.img\
       	-no-emul-boot\
	-quiet\
       	-o ../$NameForISO.iso .  
#mkisofs -J -T -o /root/$NameForISO -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -m TRANS.TBL -graft-points -V $NameForISO /root/CentOS-install/
echo -e "Injecting MD5 sum to the ISO"
implantisomd5 /media/$NameForISO.iso 
MyIPAddr=$(ifconfig | grep 192.168.55 | awk '{print $2}')
echo -e ${yellow}You may run command ${green}scp alex@${MyIPAddr}:/media/${NameForISO}.iso D:\\Hyper-V\\CENTOS-COPY\\  ${yellow}from your windows computer.${NC}
