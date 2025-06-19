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

cat ~/YArch/pkg-files/${DESKTOP_ENV}.txt | while read line
do
  echo "INSTALLING: ${line}"
  sudo pacman -S --noconfirm --needed ${line}
done

cd ~
git clone "https://aur.archlinux.org/paru.git"
cd ~/paru
makepkg -si --noconfirm
cd ~
rm -rf paru
# install aur packages
cat ~/YArch/pkg-files/aur-pkgs.txt | while read line
do
  echo "INSTALLING: ${line}"
  paru -S --noconfirm --needed ${line}
done

export PATH=$PATH:~/.local/bin

echo -ne "
-------------------------------------------------------------------------
                          Applying Themes
-------------------------------------------------------------------------
"

# applying themes
mkdir ~/.config/
cp -r ~/YArch/dotfiles/* ~/.config/

if [[ ! $DESKTOP_ENV == "server" ]] then
    git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git
    Gruvbox-GTK-Theme/themes/install.sh
    rm -rf Gruvbox-GTK-Theme
    git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack.git ~/.icons
    ln -s ~/.icons/gruvbox-plus-icon-pack/Gruvbox-Plus-Dark ~/.icons/Gruvbox-Plus-Dark 
    rm -rf gruvbox-plus-icon-pack
    cp -r ~/YArch/setups/cursor/WhiteSur-cursors ~/.icons
fi

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit