#!/usr/bin/env bash
#github-action genshdoc
#
# @file Post-Setup
# @brief Finalizing installation configurations and cleaning up after script.
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

Final Setup and Configurations
GRUB EFI Bootloader Install & Check
"
source ${HOME}/YArch/dotfiles/setup.conf

if [[ -d "/sys/firmware/efi" ]]; then
    bootctl install
    cp ${HOME}/YArch/setups/systemd-boot/loader.conf /boot/loader/
    cp ${HOME}/YArch/setups/systemd-boot/entries/* /boot/loader/entries/
fi

echo -ne "
-------------------------------------------------------------------------
               Enabling (and Theming) Login Display Manager
-------------------------------------------------------------------------
"

if [[ ! "${DESKTOP_ENV}" == "server"  ]]; then
    sudo pacman -S --noconfirm --needed lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan
    # Set default lightdm greeter to lightdm-webkit2-greeter litarvan
    cp $HOME/YArch/dotfiles/GUI/BG.png /usr/share/backgrounds/
    rm -r /usr/share/backgrounds/gnome
    cp $HOME/YArch/setups/lightdm/* /etc/lightdm/
    systemctl enable lightdm.service
fi

echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"
systemctl enable cups.service
echo "  Cups enabled"
ntpd -qg
systemctl enable ntpd.service
echo "  NTP enabled"
systemctl disable dhcpcd.service
echo "  DHCP disabled"
systemctl stop dhcpcd.service
echo "  DHCP stopped"
systemctl enable NetworkManager.service
echo "  NetworkManager enabled"
systemctl enable bluetooth
echo "  Bluetooth enabled"
systemctl enable avahi-daemon.service
echo "  Avahi enabled"

if [[ "${FS}" == "luks" || "${FS}" == "btrfs" ]]; then
echo -ne "
-------------------------------------------------------------------------
                    Creating Snapper Config
-------------------------------------------------------------------------
"

SNAPPER_CONF="$HOME/YArch/setups/snapper/root"
mkdir -p /etc/snapper/configs/
cp -rfv ${SNAPPER_CONF} /etc/snapper/configs/

SNAPPER_CONF_D="$HOME/YArch/setups/snapper/snapper"
mkdir -p /etc/conf.d/
cp -rfv ${SNAPPER_CONF_D} /etc/conf.d/

fi

echo -ne "
-------------------------------------------------------------------------
               Enabling (and Theming) Plymouth Boot Splash
-------------------------------------------------------------------------
"

mkdir -p /usr/share/plymouth/themes
echo 'Installing Plymouth theme...'
cp -rf ${HOME}/YArch/setups/plymouth/cross_hud /usr/share/plymouth/themes
if [[ $FS == "luks" ]]; then
  sed -i 's/HOOKS=(base udev*/& plymouth/' /etc/mkinitcpio.conf # add plymouth after base udev
  sed -i 's/HOOKS=(base udev \(.*block\) /&plymouth-/' /etc/mkinitcpio.conf # create plymouth-encrypt after block hook
else
  sed -i 's/HOOKS=(base udev*/& plymouth/' /etc/mkinitcpio.conf # add plymouth after base udev
fi
plymouth-set-default-theme -R cross_hud # sets the theme and runs mkinitcpio
echo 'Plymouth theme installed'

echo -ne "
-------------------------------------------------------------------------
                    Cleaning
-------------------------------------------------------------------------
"
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

rm -r $HOME/YArch
rm -r /home/$USERNAME/YArch
rm $HOME/.config/setup.conf

# Replace in the same state
cd $pwd