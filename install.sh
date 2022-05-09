#!/bin/bash

if [ "$EUID" -eq 0 ]
    then echo "Please don't run as root"
    exit
fi

# ask extra packages
while true; do
    read -rp "Install extra packages? [y/n]: " yn
    case $yn in
        [Yy]* ) extraPkg="y"; break;;
        [Nn]* ) extraPkg="n"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ask graphics drivers
echo "[0] AMD / ATI (open-source)"
echo "[1] Intel (open-source)"
echo "[2] Nvidia (proprietary)"
echo "[3] VMware / VirtualBox (open-source)"
while true; do
    read -rp "Select a graphics driver: " graphics
    case $graphics in
        [0]* ) graphics="amd"; break;;
        [1]* ) graphics="intel"; break;;
        [2]* ) graphics="nvidia"; break;;
        [3]* ) graphics="vm"; break;;
        * ) echo "Please answer 0, 1, 2 or 3.";;
    esac
done

# set script path
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# pacman
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j\$(nproc)"/g' /etc/makepkg.conf
sudo pacman -Syu --noconfirm

# yay
sudo mkdir -p /opt/yay
sudo chown "$(whoami)":"$(whoami)" /opt/yay
git clone https://aur.archlinux.org/yay.git /opt/yay
cd /opt/yay
makepkg -si --noconfirm
cd "$SCRIPTPATH"

# install base
yay -Sy --nodiffmenu - < pkg-base.txt
yes | yay -Sy --nodiffmenu libxft-bgra-git

# install graphics
if [ $graphics == "amd" ]; then
    yay -Sy --nodiffmenu - < pkg-base-amd.txt
elif [ $graphics == "intel" ]; then
    yay -Sy --nodiffmenu - < pkg-base-intel.txt
elif [ $graphics == "nvidia" ]; then
    yay -Sy --nodiffmenu - < pkg-base-nvidia.txt
elif [ $graphics == "vm" ]; then
    yay -Sy --nodiffmenu - < pkg-base-vm.txt
fi

# install extra
if [ $extraPkg == "y" ]; then
    yay -Sy --nodiffmenu - < pkg-extra.txt
    systemctl --user enable --now pipewire.service
    systemctl --user enable --now pipewire-pulse.service
fi

# install guest utils for vm
if [ "$(systemd-detect-virt)" == "oracle" ]; then
    yay -Sy --nodiffmenu virtualbox-guest-utils
    sudo systemctl enable --now vboxservice.service
    VBoxClient-all
elif [ "$(systemd-detect-virt)" == "kvm" ]; then
    yay -Sy --nodiffmenu spice-vdagent
fi

# stow
stow chromium dwm dwm-bar gtk-3 gpg-agent kitty rofi vim vscode xorg zsh

# suckless stuff
cd ~/.config/dwm
sudo make clean install

# zsh / prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin
ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout
ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile
ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv
ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc
{
    echo 'export PATH=$PATH:/home/max/.local/bin'
    echo 'alias ssh="TERM=xterm-256color ssh"'
    echo 'alias ll="exa -lah"'
} >> ~/.zshrc
sudo chsh -s "$(which zsh)" "$(whoami)"

# change default editor vim
sudo sed -i "s/EDITOR='nano'/EDITOR='vim'/g" ~/.zprofile
sudo sed -i "s/VISUAL='nano'/VISUAL='vim'/g" ~/.zprofile

# change keyboard fn key behavior
sudo mkdir -p /etc/modprobe.d/
echo "options hid_apple fnmode=2" | sudo tee -a hid_apple.conf

# rebuild mkinitcpio
sudo mkinitcpio -P

# auto login
sudo mkdir -p /etc/systemd/system/getty@tty1.service.default/
sudo tee -a /etc/systemd/system/getty@tty1.service.default/override.conf > /dev/null <<EOT
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin max --noclear %I $TERM
EOT

# startx at login
cat <<EOT >> ~/.zprofile
if [[ ! \$DISPLAY && \$XDG_VTNR -eq 1 ]]; then
    exec startx
fi
EOT


# done and reboot
echo ""
echo "Installation done. Reboot in 10 seconds."
echo ""
sleep 10
sudo reboot now
