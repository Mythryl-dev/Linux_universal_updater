#!/bin/bash

#------------------------------------------------
# Mythryl's Universal Linux Updater
# Script Version: 11
#------------------------------------------------

#------------------------------------------------
# Must be changed:
#------------------------------------------------
# add a nice logo
# After Update Message must be redesigned
# multiple language support must be added
# Colors must be added and changed
# add version check and auto update of the script
# add licence
#------------------------------------------------


#------------------------------------------------
# Documentation
#------------------------------------------------
# This script provides a unified interface to update multiple Linux distributions
# with their respective package managers. It supports system-level, Flatpak, Snap # and Waydroid updates, and includes a self-update feature.
#
#  Supported Distros:
# - Debian / Ubuntu / Mint / Neon etc (apt, nala, pkcon)
# - Arch / Manjaro / Garuda (pacman, paru, yay)
# - Fedora / RHEL / CentOS (dnf, yum)
# - OpenSUSE (zypper)
# - Alpine (apk)
# - Void (xbps)
# - Slackware (slackpkg)
# - Gentoo (emerge)
# - Puppy Linux (ppm/pkg)
# - TinyCore Linux (tce-update)
#
#  Usage:
# Run the script as root using:
#     sudo ./update.sh
# or after installing globally:
#     sudo update
#
# The script automatically detects your distro and offers relevant update options.
#------------------------------------------------

#----------------------------------
#Checks if Skript is run as Sudo
#----------------------------------
if [ $EUID -ne 0 ]; then
    echo -e '\n** ERROR => Must be run with sudo or su to function properly\n'
    exit 1
fi

#----------------------------------
#Distro Color Coding Variables
#----------------------------------
RED='\033[0;31m'
Blue='\e[0;34m'
NC='\033[0m' # No Color
Orange='\033[38;5;202m'
Green='\033[0;32m'
Purple='\033[0;35m'
Cyan='\033[0;36m'

#----------------------------------
#Distro Detection Mechanisms
#----------------------------------

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#For Debian based Distros       #Red
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function debianbased {
if [[ -f $(which nala 2>> /dev/null) ]] && [[ -f $(which apt 2>> /dev/null) ]] && [ ! -f "/etc/apt/sources.list.d/neon.sources" ] ;then
        echo -e "${RED}--------------------------------------------------------------------------------------------------------------------${NC}"
        echo -e "${RED}|${NC} Which apt frontend would you like to use?                                                                        ${RED}|${NC}"
        echo -e "${RED}|${NC} 1) Regular apt                                                                                                   ${RED}|${NC}"
        echo -e "${RED}|${NC} 2) Nala                                                                                                          ${RED}|${NC}"
        echo -e "${RED}|${NC} 3) Skip apt packages                                                                                             ${RED}|${NC}"
        echo -e "${RED}|${NC} 4) Exit                                                                                                          ${RED}|${NC}"
        echo -e "${RED}--------------------------------------------------------------------------------------------------------------------${NC}"

        read apt_frontend
        if [ "$apt_frontend" == "1" ]; then
            apt update && apt upgrade -y && apt autoremove -y
        elif [ "$apt_frontend" == "2" ]; then
            nala update && nala upgrade -y && nala autoremove -y
        elif [ "$apt_frontend" == "4" ]; then
            cd ~ && exit
        elif [ "$apt_frontend" == "3" ]; then
            return
        else
            echo "Invalid option selected."
        fi
elif [[ -n $(which nala 2>> /dev/null) ]]; then
     nala update && nala upgrade -y
elif [[ -n $(which apt 2>> /dev/null) ]]; then
     apt update && apt upgrade -y
fi

#echo "1"
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#For KDE_Neon using Pkcon           #Cyan
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function pkcon_used { #kde neon
if [ ! -f "/etc/apt/sources.list.d/neon.sources" ]; then #is needed bc every distro that uses KDE as a Desktop most likely ship with discover and discover is dependent on pkcon
    return

fi

if [[ -f $(which pkcon 2>> /dev/null) ]] && [[ -n $(which apt 2>> /dev/null) ]] ; then
       echo -e "${Cyan}-------------------------------------------------------------------------------------------------------------------------------${NC}"
       echo -e "${Cyan}|${NC} Which system-package-manager would you like to use?                                                                         ${Cyan}|${NC}"
       echo -e "${Cyan}|${NC} 1) Regular apt                                                                                                              ${Cyan}|${NC}"
       echo -e "${Cyan}|${NC} 2) pkcon  (Recommended)                                                                                                     ${Cyan}|${NC}"
       echo -e "${Cyan}|${NC} 3) Skip system packages                                                                                                     ${Cyan}|${NC}"
       echo -e "${Cyan}|${NC} 4) Exit                                                                                                                     ${Cyan}|${NC}"
       echo -e "${Cyan}-------------------------------------------------------------------------------------------------------------------------------${NC}"

        read kde_neon
       if [ "$kde_neon" == "1" ]; then
           apt update
           apt upgrade
       elif [ "$kde_neon" == "2" ]; then
           pkcon refresh
           pkcon update
       elif [ "$kde_neon" == "4" ]; then
           cd ~
           exit

       elif [ "$kde_neon" == "3" ]; then
           return
       else
           echo "Invalid option selected."
       fi
elif [[ -n $(which pkcon 2>> /dev/null) ]]  ; then
    pkcon refresh
    pkcon update

fi
echo "2"
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Alpine linux                       #Blau  problem with installation an sudo
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function alpinebased {
if [[ -f $(which apk 2>> /dev/null) ]]; then
    echo -e "${Blue}-----------------------------------------------------${NC}"
    echo -e "${Blue}|${NC} Would you like to update your Packages?            ${Blue}|${NC}"
    echo -e "${Blue}-----------------------------------------------------${NC}"
    read -p "[J/n] " apk_update
    if  [ "$apk_update" == "n" ]; then
        return
    elif [ "$apk_update" == "J" ] ||  [ "$apk_update" == "j" ] || [ "$apk_update" == "" ] ; then
        apk update
        apk upgrade --no-interactive #may needs to be changed
    fi
fi
#echo "3"
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# For Arch based Distros            #Blau
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function archbased {
if [[ -f $(which pacman 2>> /dev/null) ]] && [[ -f $(which paru 2>> /dev/null) ]] && [[ -f $(which yay 2>> /dev/null) ]] ; then

        echo -e "${Blue}--------------------------------------------------------------------------------------------------------------------${NC}"
        echo -e "${Blue}|${NC} Which pacman frontend would you like to use?                                                                     ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 1) Regular pacman                                                                                                ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 2) Paru                                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 3) Yay                                                                                                           ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 4) Skip pacman packages                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 5) Exit                                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}--------------------------------------------------------------------------------------------------------------------${NC}"

        read pacman_frontend
        if [ "$pacman_frontend" == "1" ]; then
            pacman -Syu
        elif [ "$pacman_frontend" == "2" ]; then
            paru -Syu
        elif [ "$apt_frontend" == "3" ]; then
            yay

        elif [ "$pacman_frontend" == "4" ]; then
            return

        elif [ "$pacman_frontend" == "5" ]; then
            cd ~
            exit

        else
            echo "Invalid option selected."
        fi


 elif [[ -f $(which pacman 2>> /dev/null) ]] && [[ -f $(which paru 2>> /dev/null) ]] ; then
        echo -e "${Blue}--------------------------------------------------------------------------------------------------------------------${NC}"
        echo -e "${Blue}| Which pacman frontend would you like to use?                                                                     ${Blue}|${NC}"
        echo -e "${Blue}| 1) Regular pacman                                                                                                ${Blue}|${NC}"
        echo -e "${Blue}| 2) Paru                                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}| 3) Skip pacman packages                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}| 4) Exit                                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}--------------------------------------------------------------------------------------------------------------------"

        read pacman_frontend
        if [ "$pacman_frontend" == "1" ]; then
            pacman -Syu
        elif [ "$pacman_frontend" == "2" ]; then
            paru -Syu
        elif [ "$pacman_frontend" == "4" ]; then
            cd ~
            exit
        elif [ "$pacman_frontend" == "3" ]; then
            return

        else
            echo "Invalid option selected."
        fi
elif [[ -f $(which pacman 2>> /dev/null) ]] && [[ -f $(which yay 2>> /dev/null) ]] ; then
        echo -e "${Blue}--------------------------------------------------------------------------------------------------------------------${NC}"
        echo -e "${Blue}|${NC} Which pacman frontend would you like to use?                                                                     ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 1) Regular pacman                                                                                                ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 2) Yay                                                                                                           ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 3) Skip pacman packages                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 4) Exit                                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}--------------------------------------------------------------------------------------------------------------------${NC}"

        read pacman_frontend
        if [ "$pacman_frontend" == "1" ]; then
            pacman -Syu
        elif [ "$pacman_frontend" == "2" ]; then
            yay
        elif [ "$pacman_frontend" == "4" ]; then
            cd ~
            exit
        elif [ "$pacman_frontend" == "3" ]; then
            return

        else
            echo "Invalid option selected."
        fi

elif [[ -f $(which pacman 2>> /dev/null) ]]; then
     pacman -Syu
elif [[ -f $(which paru 2>> /dev/null) ]]; then
     paru -Syu
elif [[ -f $(which yay 2>> /dev/null) ]]; then
     yay
fi
#echo "4"
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Opensuse                           #Grün           corrected to new package manager with correct spelling
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function susebased {
if [[ -f $(which zypper 2>> /dev/null) ]]; then
    echo -e "${GREEN}-----------------------------------------------------${NC}"
    echo -e "${GREEN}|${NC} Would you like to update your Packages?            ${GREEN}|${NC}"
    echo -e "${GREEN}-----------------------------------------------------${NC}"
    read -p "[J/n] " zypper_dup
    if  [ "$zypper_dup" == "n" ]; then
        return
    elif [ "$zypper_dup" == "J" ] ||  [ "$zypper_dup" == "j" ] || [ "$zypper_dup" == "" ] ; then
        #zypper dup   old update command, no lnger used
        zypper refresh
        zypper update
    fi
fi
#echo "5"
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#For Fedora based                   #Blau / Rot
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function fedorabased {
if [[ -f $(which dnf 2>> /dev/null) ]] && [[ -f $(which yum 2>> /dev/null) ]] ; then

        echo -e "${Blue}--------------------------------------------------------------------------------------------------------------------${NC}"
        echo -e "${Blue}|${NC} Which Dnf frontend would you like to use?                                                                        ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 1) Regular Dnf                                                                                                   ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 2) Yum                                                                                                           ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 3) Skip dnf packages                                                                                             ${Blue}|${NC}"
        echo -e "${Blue}|${NC} 4) Exit                                                                                                          ${Blue}|${NC}"
        echo -e "${Blue}--------------------------------------------------------------------------------------------------------------------${NC}"

        read dnf_frontend
        if [ "$dnf_frontend" == "1" ]; then
            dnf check-update
            dnf update
            dnf upgrade
        elif [ "$dnf_frontend" == "2" ]; then
            yum clean all
            yum check-update
            yum update
        elif [ "$dnf_frontend" == "4" ]; then
            cd ~
            exit
        elif [ "$dnf_frontend" == "4" ]; then
            return
        else
            echo "Invalid option selected."
        fi

fi
#echo "6"
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Void linux                         #Grün
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function voidbased {
if  [[ -f $(which xtools 2>> /dev/null)]] &&  [[-f $(which xpbs 2>> /dev/null) ]]; then
    return
    else
        echo -e "${RED}Please install xtools via ''sudo xbps-install xtools'' it is requiered to restart services after an update ${NC}"
fi

if [[ -f $(which xpbs 2>> /dev/null) ]]; then
    echo -e "${GREEN}-----------------------------------------------------${NC}"
    echo -e "${GREEN}|${NC} Would you like to update your Packages?            ${GREEN}|${NC}"
    echo -e "${GREEN}-----------------------------------------------------${NC}"
    read -p "[J/n] " xbps_update
    if  [ "$xbps_update" == "n" ]; then
        return
    elif [ "$xbps_update" == "J" ] ||  [ "$xbps_update" == "j" ] || [ "$xbps_update" == "" ] ; then
        xbps-install -Su #updates repos
        xbps-install -Su #must be run again to actually install the updates
        xcheckrestart #xtools must be installed to restart the procceses with this command
    fi
fi
#echo "7"
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#For Slackware based distros        #Blau           untested
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function slackwarebased {
if [[ -f $(which slackpkg 2>> /dev/null) ]]; then
    echo -e "${Blue}-----------------------------------------------------${NC}"
    echo -e "${Blue}|${NC} Would you like to update your Packages?            ${Blue}|${NC}"
    echo -e "${Blue}-----------------------------------------------------${NC}"
    read -p "[J/n] " slackpkg_update
    if  [ "$slackpkg_update" == "n" ]; then
        cd ~
        exit
    elif [ "$slackpkg_update" == "J" ] ||  [ "$slackpkg_update" == "j" ] || [ "$slackpkg_update" == "" ] ; then
        slackpkg update                 #https://www.linuxquestions.org/questions/slackware-14/slackware-15-0-how-do-i-update-for-just-the-last-changes-4175726356/
        slackpkg install-new
        slackpkg upgrade-all
        slackpkg clean-system
    fi
fi
#echo "8"
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Gentoo linux                       #Lila
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function gentoobased {
if [[ -f $(which emerge 2>> /dev/null) ]]; then
    echo -e "${Purple}----------------------------------------------------- ${NC}"
    echo -e "${Purple}|${NC} Would you like to update your Packages?            ${Purple}|${NC}"
    echo -e "${Purple}-----------------------------------------------------${NC}"
    read -p "[J/n] " emerge_update
    if  [ "$emerge_update" == "n" ]; then
        cd ~
        exit
    elif [ "$emerge_update" == "J" ] ||  [ "$emerge_update" == "j" ] || [ "$emerge_update" == "" ] ; then
        emerge --sync
        emerge --update --deep --with-bdeps=y @world
    fi
fi
#echo "9"
}

#------------------------------------------------------------
# Puppy Linux variants
#------------------------------------------------------------
function puppybased {
if [[ -f $(which ppm 2>> /dev/null) ]]; then
    echo -e "${Orange}-----------------------------------------------------${NC}"
    echo -e "${Orange}|${NC} Would you like to upgrade Puppy Packages?          ${Orange}|${NC}"
    echo -e "${Orange}-----------------------------------------------------${NC}"
    read -p "[J/n] " puppy_update
    if [ "$puppy_update" != "n" ]; then
        ppm upgrade --install
    fi
elif [[ -f $(which pkg 2>> /dev/null) ]]; then
    pkg -i update
fi
#echo 10
}



#------------------------------------------------------------
# TinyCore Linux
#------------------------------------------------------------
function tinycorebased {
if [[ -f $(which tce-update 2>> /dev/null) ]]; then
    tce-update #works
elif [[ -f $(which tce-load 2>> /dev/null) ]]; then
    tce-load -wi tce-update #don't know what it does
fi
#echo 11
}


#------------------------------------------------------------
#Special Packages
#------------------------------------------------------------
#For updating Flatpak
function flatpakupdate {
if [[ -f $(which flatpak 2>> /dev/null) ]]; then
    echo -e "${Blue}-----------------------------------------------------${NC}"
    echo -e "${Blue}|${NC} Would you like to update your flatpaks?           ${Blue}|${NC}"
    echo -e "${Blue}-----------------------------------------------------${NC}"
    read -p "[J/n] " flatpak_update
    if  [ " $flatpak_update" == "n" ]; then
        return
    elif [ "$flatpak_update" == "J" ] ||  [ "$flatpak_update" == "j" ] || [ "$flatpak_update" == "" ] ; then
        flatpak update
    fi
fi
}

#For updating Snap packages (mainly present in Ubuntu and its flavours) use:
function snapdupdate {
if [[ -f $(which snapd 2>> /dev/null) ]]; then
    echo -e "${Orange}-----------------------------------------------------${NC}"
    echo -e "${Orange}|${NC} Would you also like to update your Snap Packages? ${Orange}|${NC}"
    echo -e "${Orange}-----------------------------------------------------${NC}"
    read -p "[J/n] " snap_refresh
    if  [ "$snap_refresh" == "n" ]; then
        return
    elif [ "$snap_refresh" == "J" ] ||  [ "$snap_refresh" == "j" ] || [ "$snap_refresh" == "" ] ; then
        snap refresh
    fi
fi
}

#For Updating the Android Subsystem in Case it is installed.
function waydroidupdate {
if [[ -f $(which waydroid 2>> /dev/null) ]]; then
    echo -e "${Green}-----------------------------------------------------${NC}"
    echo -e "${Green}|${NC} Would you like to update Waydroid?                ${Green}|${NC}"
    echo -e "${Green}-----------------------------------------------------${NC}"
    read -p "[J/n] " waydroid_update
     if  [ "$waydroid_update" == "n" ]; then
        return
    elif [ "$waydroid_update" == "J" ] ||  [ "$waydroid_update" == "j" ] || [ "$waydroid_update" == "" ] ; then
        waydroid upgrade
    fi
fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
#OS Calls
#-------------------------------------------------------------
debianbased
pkcon_used
alpinebased
archbased
susebased
fedorabased
voidbased
slackwarebased
gentoobased

puppybased
tinycorebased

#-------------------------------------------------------------
#Special Package calls
#-------------------------------------------------------------
flatpakupdate
snapdupdate
waydroidupdate
#-------------------------------------------------------------

#-------------------------------------------------------------
#Updates the script it self
#-------------------------------------------------------------
( wget -q -O /usr/bin/update https://raw.githubusercontent.com/Mythryl-dev/Linux_universal_updater/refs/heads/main/Update.sh && chmod 755 /usr/bin/update ) >/dev/null 2>&1 &
#-------------------------------------------------------------


#-------------------------------------------------------------
#After Updating
#-------------------------------------------------------------
echo ""
echo -e "${RED}Thank you for using Mythryl's Universal Updater${NC}"
echo ""
cd ~
exit


