#!/usr/bin/bash
# That script will add config file (ks.cfg) to DVD installation  
# Script created by: Oleksandr Dubel
# Created at: Wed Dec  2 15:41:44 EET 2020
# Modified at:
# The string below will add color output to your messages if needed
. ./colorsforotherfiles.bash

roMount="/media/dvdRO"
rwMount="/media/dvdRW"
kstocfg="isolinux/isolinux.cfg"
addks="ks=cdrom:/ks.cfg"
#Name from file /media/dvdRW/isolinux/isolinux.cfg is CentOS-8-2-2004-x86_64-dvd string begins with append initrd=
NameForISO="CentOS-8-2-2004-x86_64-dvd"

if [ "$EUID" -ne 0 ]; then
echo -e ${red}"That script should be run as root"
echo -e Exiting...${NC}
exit 1
fi
# Cleaning up; Removing calatogs if exist
rm -Rf /media/*
for catalog in $roMount $rwMount
do
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

echo -e ${cyan}Mounting dvd to $roMount
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
		echo -e ${green}Catalog copied successfully${NC}
	else 
		echo -e ${red}Catalog copied with errors.
		echo -e Exiting...
		exit 102
fi
echo -e ${cyan}Copying file from /root/anaconda-ks.cfg to $rwMount/ks.cfg
cp /root/anaconda-ks.cfg $rwMount/ks.cfg
	if [ $? -eq 0 ];then
		echo -e ${green}File copied successfully${NC}
		echo -e ${cyan} Unmounting $roMount${NC}
		umount $roMount
	else
		echo -e ${red}Something went wrong. File was not copied.
		echo -e Exiting...
		exit 103    
	fi

echo -e ${cyan}"Adding info about ks.kfg to the boot menu ks=cdrom:/ks.cfg"
read a
#sed -i 's/dvd quiet/dvd quiet ks=cdrom\:\/ks.cfg/' $rwMount/$kstocfg
#sed -i 's/dvd quiet/dvd quiet ks=cdrom\:\/ks.cfg/' /media/dvdRW/EFI/BOOT/BOOT.conf
cd $rwMount/
echo -e "Writing ISO file"${NC}
sleep 2
genisoimage -U -r -v -T -J -joliet-long -V $NameForISO -volset $NameForISO -A $NameForISO -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot -o ../$NameForISO.iso . > echo -n 
#mkisofs -J -T -o /root/$NameForISO -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -m TRANS.TBL -graft-points -V $NameForISO /root/CentOS-install/
echo -e "Injecting MD5 sum to the ISO"
implantisomd5 /media/$NameForISO.iso
