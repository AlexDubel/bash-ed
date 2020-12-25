#!/usr/bin/bash
# That script will (please add some info about the script)
# Script created by: Oleksandr Dubel
# Created at: Вт дек  1 16:22:09 EET 2020
# Modified at:
# The string below will add color output to your messages if needed
. ./colorsforthefiles.bash

echo -e  ${yellow}"Cool awk (look at script)"${NC} 
df -h | awk '0+$5 >=50 {print}' | awk '{print $5, $6}'
