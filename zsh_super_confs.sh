#!/usr/bin/env bash

## Bash script to configure zsh and a few plugins 
## I've used these plugins and confs for some time,
## they have helped speed up my workflow immensely
## I hope they can help you too!
##
## NOTE: Work in progress
## 
## Program created by @Topazstix  ¯\_(ツ)_/¯

# Copyleft (c) 2023 Topazstix <topazstix@protonmail.com>

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.


## DEBUG 
# set -x


source library.lib

## Check if the user is root, otherwise exit
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   echo "Try: sudo $0"
   exit 1
fi

## Set a few local vars for the script
username=$SUDO_USER

if [[ -e /etc/os-release ]]; then
   source /etc/os-release
   case $ID in
      arch|endeavouros|manjaro)
            update_arch
            ;;
      debian|ubuntu|kali|linuxmint)
            update_debian
            ;;
      fedora)
            update_fedora
            ;;
      rhel|centos)
            update_centos
            ;;
      *)
            echo "Unknown distribution"
            exit 2
            ;;
   esac
else
   echo "Could not determine OS release information"
   exit 2
fi

## Exit script if updates failed
if [ $? -ne 0 ]; then
   echo "Updates failed, exiting script"
   exit 3
fi


## Check for existence of dirs
if [[ ! -n $(find /usr/share -maxdepth 1 -type d -name zsh-autosuggestions -print -quit) && ! -n $(find /usr/share -maxdepth 1 -type d -name zsh-syntax-highlighting -print -quit) ]]; then 
   echo "Directories are in non-standard location"
   echo "Symlinking to preferred locations"

   auto_suggestions=$(find /usr/share -type d -name zsh-autosuggestions  | grep -vE '(doc|licenses)')
   syntax_highlighting=$(find /usr/share -type d -name zsh-syntax-highlighting  | grep -vE '(doc|licenses)')

   ln -s $auto_suggestions /usr/share
   ln -s $syntax_highlighting /usr/share

   if [ $? -ne 0 ]; then
      echo "Failed to create symlinks"
      exit 4
   fi
fi



## Install oh-my-zsh in custom directory
echo "Downloading oh-my-zsh"
echo "Please visit their github and read their docs for extra configs!"
echo "https://github.com/ohmyzsh/ohmyzsh.git"
git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh

echo -e "\n\n"

## Install powerlevel10k theme
echo "Downloading powerlevel10k theme"
echo "Please visit their github and read their docs for extra configs!"
echo "I've disable the github module in p10k, as i use tmux with that same plugin"
echo "https://github.com/romkatv/powerlevel10k.git"
git clone https://github.com/romkatv/powerlevel10k.git /usr/share/oh-my-zsh/custom/themes/powerlevel10k

echo -e "\n\n"

## Download custom configurations for zsh
## Check if current folder contains our github's conf folder, 
## if so, use conf files from there
## Otherwise download confs with wget
if [ -d ./confs ]; then
   echo "Using local conf files"
   cp ./confs/zsh/p10k.root.zsh /root/.p10k.zsh
   cp ./confs/zsh/p10k.user.zsh /home/$username/.p10k.zsh
   cp ./confs/zsh/user.zshrc /home/$username/.zshrc
   cp ./confs/zsh/user.zshrc /root/.zshrc
   cp ./.p10k.zsh /usr/share/oh-my-zsh/custom/
   
else
   echo "Downloading conf files from github"

   wget https://raw.githubusercontent.com/Topazstix/auto-configurator/main/confs/zsh/p10k.root.zsh -O /root/.p10k.zsh
   wget https://raw.githubusercontent.com/Topazstix/auto-configurator/main/confs/zsh/p10k.user.zsh -O /home/$username/.p10k.zsh
   wget https://raw.githubusercontent.com/Topazstix/auto-configurator/main/confs/zsh/user.zshrc -O /home/$username/.zshrc
   sed -i "s/DEFAULT_USER=\"\"/DEFAULT_USER=${username}/g" /home/$username/.zshrc
   cp /home/$username/.zshrc /root/.zshrc


fi

echo -e "\n\n"

## Make cache directories in each user's home folder
echo "Making cache directories in each user's home folder"
mkdir -p /home/$username/.cache/oh-my-zsh
mkdir -p /root/.cache/oh-my-zsh

echo -e "\n\n"

## Change permissions on new files
echo "Changing perms on new files"
chown -R $username:$username /home/$username/.{zshrc,p10k.zsh,cache}
chown -R root:root /root/.{zshrc,p10k.zsh,cache}

## Replace default user with $username in new files
echo "Changing default user in zshrc confs"
sed -i "s/DEFAULT_USER=\"\"/DEFAULT_USER=${username}/g" /home/$username/.zshrc
sed -i "s/DEFAULT_USER=\"\"/DEFAULT_USER=${username}/g" /root/.zshrc

## Change default shell to zsh for root and user
usermod --shell $(which zsh) $username
usermod --shell $(which zsh) root

echo -e "\n\n"

## Advise user to log out and back in to their current shell for changes to take effect
echo "Successfully configured zsh! Congrats!"
echo "Log out and back in to your current shell for changes to take effect"
echo "Alternatively, you make run `zsh` in your current shell to test it out"
echo "Enjoy!"
exit 0
