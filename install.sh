#!/bin/bash

if [ "$EUID" -eq 0 ]
    then echo "Please don't run as root"
    exit
fi

# set script path
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# update pacman
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo pacman -Syu --noconfirm

# setup yay
sudo mkdir -p /opt/yay
sudo chown $(whoami). /opt/yay
git clone https://aur.archlinux.org/yay.git /opt/yay
cd /opt/yay
makepkg -si --noconfirm

# install packages
yay -Sy aom aria2 base-devel cifs-utils curl discord docker docker-compose exfat-utils feh ffmpeg firefox freerdp git gvfs gvfs-nfs gvfs-smb gzip handbrake htop kitty krita lutris man-db man-pages mangohud mediainfo mpv neofetch networkmanager-openvpn nm-connection-editor nmap noto-fonts noto-fonts-cjk noto-fonts-emoji obs-studio openvpn pactl pamixer pavucontrol piper pipewire pipewire-alsa pipewire-jack pipewire-jack-dropin pipewire-media-session pipewire-pulse playerctl python qemu qjackctl rav1e remmina rsync seafile seafile-client signal-desktop smbclient spotify steam svt-av1 telegram-desktop thunar thunderbird tigervnc tmux traceroute ttf-hack unrar unzip vim virt-manager virt-viewer visual-studio-code-bin wget wireguard-tools xorg-server xorg-server-common xorg-xinit xorg-xmodmap xorg-xrandr zsh

# audio
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service

# vim
sudo rm -f /etc/vimrc
sudo ln -s $SCRIPTPATH/etc/vimrc /etc/vimrc

# xorg
rm -f ~/.xinitrc
ln -s $SCRIPTPATH/home/.xinitrc ~/.xinitrc

# suckless stuff
mkdir -p ~/.config
ln -s $SCRIPTPATH/.config/dwm ~/.config/dwm
ln -s $SCRIPTPATH/.config/dwm-bar ~/.config/dwm-bar
ln -s $SCRIPTPATH/.config/dmenu ~/.config/dmenu
cd ~/.config/dwm
sudo make clean install
cd ~/.config/dwm-bar
sudo make clean install
cd ~/.config/dmenu
sudo make clean install

# kitty terminal
rm -rf ~/.config/kitty/kitty.conf
ln -s $SCRIPTPATH/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# zsh / prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin
ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout
ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile
ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv
ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc
curl 'https://gist.githubusercontent.com/seriousm4x/b93b2af2c226b82d755309f87ef936d3/raw/5cb4fd37b7984aed61997a157429cc032b90b297/.zpreztorc' -o ~/.zpreztorc
echo 'export PATH=\$PATH:/home/max/.local/bin' >> ~/.zshrc
echo 'alias ssh="kitty +kitten ssh"' >> ~/.zshrc
chsh -s /bin/zsh
