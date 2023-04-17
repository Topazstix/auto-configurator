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

## Check if the user is root, otherwise exit
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   echo "Try: sudo $0"
   exit 1
fi

## Set a few local vars for the script
username=$SUDO_USER

## Update apt repositories
echo "Updating apt repositories"
apt update -y

## Install zsh, zsh-autosuggestions, zsh-syntax-highlighting
echo "Installing a few programs required for script:"
echo "zsh, zsh-autosuggestions, zsh-syntax-highlighting, git, wget"
apt install -y git wget zsh zsh-autosuggestions zsh-syntax-highlighting

echo -n "\n\n"

## Install oh-my-zsh in custom directory
echo "Downloading oh-my-zsh"
echo "Please visit their github and read their docs for extra configs!"
echo "https://github.com/ohmyzsh/ohmyzsh.git"
git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh

echo -n "\n\n"

## Install powerlevel10k theme
echo "Downloading powerlevel10k theme"
echo "Please visit their github and read their docs for extra configs!"
echo "I've disable the github module in p10k, as i use tmux with that same plugin"
echo "https://github.com/romkatv/powerlevel10k.git"
git clone https://github.com/romkatv/powerlevel10k.git /usr/share/oh-my-zsh/custom/themes/

echo -n "\n\n"

## Download custom configurations for zsh
## Check if current folder contains our github's conf folder, 
## if so, use conf files from there
## Otherwise download confs with wget
if [ -d ./confs ]; then
   echo "Using local conf files"
   cp ./confs/p10k.root.zsh /root/.p10k.zsh
   cp ./confs/p10k.user.zsh /home/$username/.p10k.zsh
   cp ./confs/user.zshrc /home/$username/.zshrc
   cp ./confs/user.zshrc /root/.zshrc
   cp ./.p10k.zsh /usr/share/oh-my-zsh/custom/
   
else
   echo "Downloading conf files from github"

   wget https://raw.githubusercontent.com/Topazstix/auto-configurator/main/confs/p10k.root.zsh -O /root/.p10k.zsh
   wget https://raw.githubusercontent.com/Topazstix/auto-configurator/main/confs/p10k.user.zsh -O /home/$username/.p10k.zsh
   wget https://raw.githubusercontent.com/Topazstix/auto-configurator/main/confs/user.zshrc -O /home/$username/.zshrc
   sed -i "s/DEFAULT_USER=\"\"/DEFAULT_USER=${username}/g" /home/$username/.zshrc
   cp /home/$username/.zshrc /root/.zshrc


fi

echo -n "\n\n"

## Change permissions on new files
echo "Changing perms on new files"
chown -R $username:$username /home/$username/.{zshrc,p10k.zsh}
chown -R root:root /root/.{zshrc,p10k.zsh}

## Replace default user with $username in new files
echo "Changing default user in zshrc confs"
sed -i "s/DEFAULT_USER=\"\"/DEFAULT_USER=${username}/g" /home/$username/.zshrc
sed -i "s/DEFAULT_USER=\"\"/DEFAULT_USER=${username}/g" /root/.zshrc



## Change default shell to zsh for root and user
chsh -s $(which zsh) $username
chsh -s $(which zsh) root

echo -n "\n\n"

## Advise user to log out and back in to their current shell for changes to take effect
echo "Successfully configured zsh! Congrats!"
echo "Log out and back in to your current shell for changes to take effect"
echo "Alternatively, you make run `zsh` in your current shell to test it out"