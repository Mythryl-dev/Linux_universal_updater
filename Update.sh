#!/bin/bash

#------------------------------------------------
# Documentation:
#------------------------------------------------
# add a nice logo
# After Update Message must be redesigned
# multiple language support must be added
# Colors must be added and changed
# Tinycore Linux support
# Puppy Linux support
#add alias and setup script
#------------------------------------------------



#------------------------------------------------
#Code Snippes for guidance
#------------------------------------------------
#In Bash, the command `echo` is used to print text to the terminal. The `-e` option tells `echo` to enable the interpretation of escape sequences, which allows special characters like newline (`\n`), tab (`\t`), and others #to be processed.

#For example:
#```bash
#echo -e "Hello\nWorld"
#```
#This will output:
#```
#Hello
#World
#```

#Without the `-e` option, escape sequences like `\n` would be printed as plain text rather than interpreted as newlines.

#Some common escape sequences used with `echo -e` include:
#- `\n` for a newline
#- `\t` for a tab
#- `\\` for a backslash
#- `\r` for carriage return
#- `\a` for an alert (bell sound)
#
#Would you like an example of using one of these in action?

#----------------------------------
#Checks if Skript is run as Sudo
#----------------------------------
if [ $EUID -ne 0 ]; then
    echo -e '\n** ERROR => Must be run with sudo to function properly\n'
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

#For Debian based Distros
function debianbased {
#if [[ -f $(which nala 2>> /dev/null) ]] && [[ -f $(which apt 2>> /dev/null) ]] ; then
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
            apt update
            apt upgrade
        elif [ "$apt_frontend" == "2" ]; then
            nala update
            nala upgrade
        elif [ "$apt_frontend" == "4" ]; then
            cd ~
            exit

        elif [ "$apt_frontend" == "3" ]; then
            return
        else
            echo "Invalid option selected."
        fi

elif [[ -n $(which nala 2>> /dev/null) ]] && ! [[ -f $(which pkcon 2>> /dev/null) ]]; then
     nala update
     nala upgrade
elif [[ -n $(which apt 2>> /dev/null) ]] && ! [[ -f $(which pkcon 2>> /dev/null) ]]; then
     apt update
     apt upgrade

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
#Alpine linux                       #Blau
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
        apk upgrade -Su
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
#Opensuse                           #Grün
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function susebased {
if [[ -f $(which zypher 2>> /dev/null) ]]; then
    echo -e "${GREEN}-----------------------------------------------------${NC}"
    echo -e "${GREEN}|${NC} Would you like to update your Packages?            ${GREEN}|${NC}"
    echo -e "${GREEN}-----------------------------------------------------${NC}"
    read -p "[J/n] " zypher_dup
    if  [ "$zypher_dup" == "n" ]; then
        return
    elif [ "$zypher_dup" == "J" ] ||  [ "$zypher_dup" == "j" ] || [ "$zypher_dup" == "" ] ; then
        zypper dup
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
if [[ -f $(which xpbs 2>> /dev/null) ]]; then
    echo -e "${GREEN}-----------------------------------------------------${NC}"
    echo -e "${GREEN}|${NC} Would you like to update your Packages?            ${GREEN}|${NC}"
    echo -e "${GREEN}-----------------------------------------------------${NC}"
    read -p "[J/n] " xbps_update
    if  [ "$xbps_update" == "n" ]; then
        return
    elif [ "$xbps_update" == "J" ] ||  [ "$xbps_update" == "j" ] || [ "$xbps_update" == "" ] ; then
        xbps-install -Su
        xcheckrestart
    fi
fi
#echo "7"
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#For Slackware based distros        #Blau
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
        slackpkg update
        slackpkg upgrade-all
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
#Puppy Linux variants you have to see wich one works
#------------------------------------------------------------
#pkg -i update

#Puppy Tarbals
#ppm upgrade --install
#should work work for most puppy packages all the other ones have to be update via the respective PuppyLinux flavour's package Manager

#------------------------------------------------------------
#Tinycore Linux
#------------------------------------------------------------
#tce-update oder
#tce-load -wi tce-update  wenn ersteres nicht vorhanden ist
#je nach version von tinycore



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

#-------------------------------------------------------------
#Special Package calls
#-------------------------------------------------------------
flatpakupdate
snapdupdate
waydroidupdate
#-------------------------------------------------------------

#-------------------------------------------------------------
#After Updating
#-------------------------------------------------------------
echo ""
echo -e "${RED}Thank you for using the Mythryls universal updater${NC}"
echo ""
cd ~
exit
