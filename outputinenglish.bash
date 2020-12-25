#!/usr/bin/bash
# That script will (please add some info about the script)
# Script created by: Oleksandr Dubel
# Created at: Tue Dec  1 22:09:25 EET 2020
# Modified at:
# The string below will add color output to your messages if needed
. ./colorsforthefiles.bash
echo "To switch to English in output for e.g. echo date you need to put LANG=LC."
echo "See example below"
echo "date before LANG=LC"
LANG=RU_ru && date
echo "Date after LANG=LC"
LANG=LC && date
