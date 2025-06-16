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
                        SCRIPTHOME: YArch
-------------------------------------------------------------------------

Installing AUR Softwares
"
source $HOME/YArch/dotfiles/setup.conf

sed -n '/'$INSTALL_TYPE'/q;p' ~/YArch/pkg-files/${DESKTOP_ENV}.txt | while read line
do
  echo "INSTALLING: ${line}"
  sudo pacman -S --noconfirm --needed ${line}
done

cd ~
git clone "https://aur.archlinux.org/$AUR_HELPER.git"
cd ~/$AUR_HELPER
makepkg -si --noconfirm
# install aur packages
sed -n '/'$INSTALL_TYPE'/q;p' ~/YArch/pkg-files/aur-pkgs.txt | while read line
do
  echo "INSTALLING: ${line}"
  $AUR_HELPER -S --noconfirm --needed ${line}
done

export PATH=$PATH:~/.local/bin

echo -ne "
-------------------------------------------------------------------------
                          Applying Themes
-------------------------------------------------------------------------
"

$AUR_HELPER -S --noconfirm --needed lightdm-webkit2-theme-glorious
# Set default lightdm greeter to lightdm-webkit2-greeter
sudo sed -i 's/^\(#?greeter\)-session\s*=\s*\(.*\)/greeter-session = lightdm-webkit2-greeter #\1/ #\2g' /etc/lightdm/lightdm.conf

# applying themes
cp -r ~/YArch/dotfiles/ ~/.config/

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit