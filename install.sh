#!/bin/bash

if [ "$EUID" -eq 0 ]
    then echo "Please don't run as root"
    exit
fi

while true; do
    read -rp "Install extra packages? [y/n]: " yn
    case $yn in
        [Yy]* ) extraPkg="y"; break;;
        [Nn]* ) extraPkg="n"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# set script path
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# pacman
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo pacman -Syu --noconfirm

# yay
sudo mkdir -p /opt/yay
sudo chown "$(whoami)". /opt/yay
git clone https://aur.archlinux.org/yay.git /opt/yay
cd /opt/yay
makepkg -si --noconfirm
cd "$SCRIPTPATH"

# install packages
yes | yay -Sy libxft-bgra-git
yay -Sy --nodiffmenu - < base.txt
if [ $extraPkg == "y" ]; then
    yay -Sy --nodiffmenu - < extra.txt
    systemctl --user enable --now pipewire.service
    systemctl --user enable --now pipewire-pulse.service
fi

if [ "$(systemd-detect-virt)" == "oracle" ]; then
    yay -Sy virtualbox-guest-utils
    sudo systemctl enable --now vboxservice.service
    VBoxClient-all
fi

# stow
stow dmenu dwm dwm-bar kitty vim xorg

# suckless stuff
cd ~/.config/dwm
sudo make clean install
cd ~/.config/dmenu
sudo make clean install

# zsh / prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin
ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout
ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile
ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv
ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc
curl "https://gist.githubusercontent.com/seriousm4x/b93b2af2c226b82d755309f87ef936d3/raw/5cb4fd37b7984aed61997a157429cc032b90b297/.zpreztorc" -o ~/.zpreztorc
{
    echo 'export PATH=$PATH:/home/max/.local/bin'
    echo 'alias ssh="kitty +kitten ssh"'
    echo 'alias ll="exa -lah"'
} >> ~/.zshrc
chsh -s /bin/zsh

# default editor vim
sudo sed -i "s/EDITOR='nano'/EDITOR='vim'/g" ~/.zprofile
sudo sed -i "s/VISUAL='nano'/VISUAL='vim'/g" ~/.zprofile


# startx at login
cat <<EOT >> ~/.zprofile
if [ -z '${DISPLAY}' ] && [ '${XDG_VTNR}' -eq 1 ]; then
  exec startx
fi
EOT

echo ""
echo "Installation done. Please reboot."
echo ""
