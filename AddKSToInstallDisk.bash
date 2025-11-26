#!/usr/bin/bash

# That script will add submenu with config file (ks.cfg) to iso with CENTOS 8.3 installation  
# Script created by: Oleksandr Dubel

# Created at: 	Wed Dec  2 15:41:44 EET 2020
# First version of script was areated for 8.2 version of CentOS

# Modified at: 	Sun Dec 20 10:25:23 EET 2020
# All modification to the file are described via -m key during git commit. 

DIRTOINCLUDE="${BASH_SOURCE%/*}"
if [[ ! -d "$DIRTOINCLUDE" ]]; then DIRTOINCLUDE="$PWD"; fi

# The string below will add color output to your messages if needed
if [ -f "$DIRTOINCLUDE/colorsforthefiles.bash" ]; then
    . "$DIRTOINCLUDE/colorsforthefiles.bash"
else
    # Fallback colors
    red='\e[0;31m'
    green='\e[0;32m'
    yellow='\e[0;33m'
    cyan='\e[0;36m'
    NC='\e[0m'
fi

# Defaults
NameForISO="CentOS-8-3-2011-x86_64-dvd"
SOURCE_DEVICE="/dev/sr0"
KICKSTART_FILE="/root/anaconda-ks.cfg"

readonly media="/media"
readonly roMount="${media}/dvdRO"
readonly rwMount="${media}/dvdRW"

# Logging Functions
log_info() { echo -e "${cyan}[INFO] $1${NC}"; }
log_success() { echo -e "${green}[SUCCESS] $1${NC}"; }
log_warn() { echo -e "${yellow}[WARN] $1${NC}"; }
log_error() { echo -e "${red}[ERROR] $1${NC}"; }

usage() {
    echo "Usage: $0 [-n ISO_NAME] [-s SOURCE_DEVICE] [-k KICKSTART_FILE] [-h]"
    echo "  -n  Name for the new ISO (default: $NameForISO)"
    echo "  -s  Source device path (default: $SOURCE_DEVICE)"
    echo "  -k  Kickstart file path (default: $KICKSTART_FILE)"
    echo "  -h  Show this help message"
    exit 1
}

check_dependencies() {
    local dependencies=("genisoimage" "implantisomd5" "ip" "awk" "grep" "mount" "umount" "cp" "rm" "mkdir")
    local missing_deps=0
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Missing dependency: $cmd"
            missing_deps=1
        fi
    done
    if [ "$missing_deps" -eq 1 ]; then
        exit 1
    fi
}

cleanup() {
    if mountpoint -q "$roMount"; then
        log_info "Cleaning up: Unmounting $roMount"
        umount "$roMount"
    fi
}

trap cleanup EXIT INT TERM

MediaMountAndCopyFiles() {
    # Cleaning up; Removing catalogs if exist
    if mountpoint -q "$roMount"; then
        umount "$roMount"
    fi
    
    # Safety check for media directory
    if [ -z "$media" ] || [ "$media" = "/" ]; then
        log_error "Media directory is not safe to clean: $media"
        exit 1
    fi

    log_info "Cleaning up $media..."
    rm -rf "${media:?}/"*

    for catalog in "$roMount" "$rwMount"; do
        if [ ! -d "$catalog" ]; then
            log_info "Creating catalog $catalog..."
            mkdir -p "$catalog"
        fi
    done

    log_info "Read-only mounting dvd to $roMount"
    mount "$SOURCE_DEVICE" "$roMount" -o ro
    if [ $? -eq 0 ]; then
        log_success "Mounted successfully"
    else
        log_error "Can not mount DVD to $roMount catalog"
        exit 101
    fi

    log_info "Copying data from $roMount to $rwMount"
    shopt -s dotglob
    cp -aRf "$roMount"/* "$rwMount"
    if [ $? -eq 0 ]; then
        log_success "Catalog copied successfully"
    else
        log_error "Catalog copied with errors."
        exit 102
    fi

    log_info "Copying file from $KICKSTART_FILE to $rwMount/ks.cfg"
    if [ -f "$KICKSTART_FILE" ]; then
        cp "$KICKSTART_FILE" "$rwMount/ks.cfg"
        if [ $? -eq 0 ]; then
            log_success "File copied successfully"
        else
            log_error "Something went wrong. File was not copied."
            exit 103
        fi
    else
        log_error "Kickstart file not found: $KICKSTART_FILE"
        exit 103
    fi
    
    log_info "Unmounting $roMount"
    umount "$roMount"
}

main() {
    if [[ "$EUID" -ne 0 ]]; then
        log_error "That script should be run as root"
        exit 1
    fi

    check_dependencies

    MediaMountAndCopyFiles

    # Grub modification
    if [ -f "$DIRTOINCLUDE/GrubFileModify.bash" ]; then
        . "$DIRTOINCLUDE/GrubFileModify.bash"
    else
        log_warn "GrubFileModify.bash not found, skipping..."
    fi

    cd "$rwMount/" || { log_error "Can't cd to $rwMount catalog"; exit 104; }
    
    log_info "Writing ISO file"
    
    genisoimage -U -r -v -T -J \
        -joliet-long \
        -V "$NameForISO" \
        -volset "$NameForISO" \
        -A "$NameForISO" \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -eltorito-alt-boot \
        -e images/efiboot.img \
        -no-emul-boot \
        -quiet \
        -o "../$NameForISO.iso" .

    log_info "Injecting MD5 sum to the ISO"
    implantisomd5 "/media/$NameForISO.iso"

    local MyIPAddr
    MyIPAddr=$(ip addr show | grep 192.168.55 | awk '{print $2}' | cut -d/ -f1 | head -n 1)
    if [ -z "$MyIPAddr" ]; then
        MyIPAddr="<YOUR_IP>"
    fi
    
    echo -e "${yellow}You may run command ${green}scp alex@${MyIPAddr}:/media/${NameForISO}.iso D:\\Hyper-V\\CENTOS-COPY\\  ${yellow}from your windows computer.${NC}"
}

# Parse Arguments
while getopts "n:s:k:h" opt; do
    case ${opt} in
        n) NameForISO="$OPTARG" ;;
        s) SOURCE_DEVICE="$OPTARG" ;;
        k) KICKSTART_FILE="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

main
