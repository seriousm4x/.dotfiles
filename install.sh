#!/bin/bash

if [ "$EUID" -eq 0 ]
    then echo "Please don't run as root"
    exit
fi

# set script path
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# update pacman
sudo pacman -Syu --noconfirm

# setup yay
sudo mkdir -p /opt/yay
sudo chown $(whoami). /opt/yay
git clone https://aur.archlinux.org/yay.git /opt/yay
cd /opt/yay
makepkg -si --noconfirm
cd $SCRIPTPATH

# install packages
yay -Sy base-devel git curl wget htop vim xorg xorg-server xorg-server-common xorg-xinit xorg-xrandr xorg-xmodmap aom aria2 cifs-utils discord docker docker-compose exfat-utils feh ffmpeg firefox freerdp gvfs gvfs-nfs gvfs-smb gzip handbrake kitty krita lutris man-db man-pages mangohud mediainfo mpv neofetch networkmanager-openvpn nm-connection-editor nmap noto-fonts noto-fonts-cjk noto-fonts-emoji obs-studio openvpn pamixer piper pipewire pipewire-alsa pipewire-jack pipewire-jack-dropin pipewire-media-session pipewire-pulse playerctl python qemu qjackctl rav1e remmina rsync seafile seafile-client signal-desktop smbclient spotify steam svt-av1 telegram-desktop thunar thunderbird tigervnc tmux traceroute ttf-hack unrar unzip virt-manager virt-viewer visual-studio-code-bin wireguard-tools woeusb zsh pavucontrol pactl

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
cd $SCRIPTPATH

# kitty terminal
rm -rf ~/.config/kitty
ln -s .config/kitty ~/.config/kitty

# zsh / prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
/bin/zsh -dfi -c 'setopt EXTENDED_GLOB && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done'
echo "export PATH=\$PATH:/home/max/.local/bin" >> ~/.zshrc
echo "alias ssh=\"kitty +kitten ssh\"" >> ~/.zshrc
chsh -s /bin/zsh
cd $SCRIPTPATH
