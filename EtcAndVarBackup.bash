#!/usr/bin/bash
# That test script will backup /etc and /var catalogs
# Created: 28-Nov-2020
# Modified:

. ./colorsforotherfiles.bash
catalog1="/etc"
backupname="/tmp/backup.tar"

echo -e ${yellow}Backup started at $(date)${NC}
sleep 1
tar cvf $backupname $catalog1 /var
echo -e ${green}Backup finished at $(date)${NC}
echo -e ${yellow}Start backup file compressing${NC}
gzip $backupname
echo -e ${green}Backup compressing finished${NC}

