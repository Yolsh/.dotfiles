#!/usr/bin/env bash
#github-action genshdoc
#
# @file User
# @brief User customizations and AUR package installation.
echo -ne "
-------------------------------------------------------------------------
   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
                        SCRIPTHOME: ArchTitus
-------------------------------------------------------------------------

Installing AUR Softwares
"
source $HOME/ArchTitus/configs/setup.conf

sed ~/ArchTitus/pkg-files/${DESKTOP_ENV}.txt | while read line
do
  echo "INSTALLING: ${line}"
  sudo pacman -S --noconfirm --needed ${line}
done

cd ~
git clone "https://aur.archlinux.org/$AUR_HELPER.git"
cd ~/$AUR_HELPER
makepkg -si --noconfirm
# install aur packages
sed ~/ArchTitus/pkg-files/aur-pkgs.txt | while read line
do
  echo "INSTALLING: ${line}"
  $AUR_HELPER -S --noconfirm --needed ${line}
done

export PATH=$PATH:~/.local/bin

# applying theme
cp -r ~/YArch/dotfiles/* ~/.config/

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit