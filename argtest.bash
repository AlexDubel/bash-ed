#!/usr/bin/bash
# That script will (please add some info about the script)
# Script created by: Oleksandr Dubel
# Created at: Fri Dec 25 09:58:42 EET 2020
# Modified at:
# The string below will add color output to your messages if needed
#. ./colorsforthefiles.bash

#echo filename=${basename0}

echo =====
DIRTOINCLUDE="${BASH_SOURCE%/*}"
echo 1==DIRTOINCLUDE=$DIRTOINCLUDE
if [[ ! -d "$DIRTOINCLUDE" ]]; then DIRTOINCLUDE="$PWD"; fi
#. "$DIR/incl.sh"
#. "$DIR/main.sh"
echo 2==DIRTOINCLUDE=$DIRTOINCLUDE
. "$DIRTOINCLUDE/colorsforthefiles.bash"
#source ~/myscripts/bash-ed/colorsforthefiles.bash 
#source $(pwd)/myscripts/bash-ed/colorsforthefiles.bash
echo dollar0=$0
echo pwd =$(pwd)
echo -e ${yellow}Test${NC} 
#echo addinffile=$(pwd)/myscripts/bash-ed/colorsforthefiles.bash

echo =====
#ls -la $(pwd)/myscripts/bash-ed/colorsforthefiles.bash
echo date=$(date)

