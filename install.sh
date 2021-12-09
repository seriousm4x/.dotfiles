#!/bin/bash

if [ "$EUID" -eq 0 ]
    then echo "Please don't run as root"
    exit
fi

# set script path
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# pacman
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo pacman -Syu --noconfirm

# yay
sudo mkdir -p /opt/yay
sudo chown $(whoami). /opt/yay
git clone https://aur.archlinux.org/yay.git /opt/yay
cd /opt/yay
makepkg -si --noconfirm

# install packages
yay -Sy aom aria2 base-devel cifs-utils curl discord docker docker-compose exfat-utils feh ffmpeg firefox freerdp git gvfs gvfs-nfs gvfs-smb gzip handbrake htop kitty krita lutris man-db man-pages mangohud mediainfo mpv neofetch networkmanager-openvpn nm-connection-editor nmap noto-fonts noto-fonts-cjk noto-fonts-emoji obs-studio openvpn pactl pamixer pavucontrol piper pipewire pipewire-alsa pipewire-jack pipewire-jack-dropin pipewire-media-session pipewire-pulse playerctl python qemu qjackctl rav1e remmina rsync seafile seafile-client signal-desktop smbclient spotify steam stow svt-av1 telegram-desktop thunar thunderbird tigervnc tmux traceroute ttf-hack unrar unzip vim virt-manager virt-viewer visual-studio-code-bin wget wireguard-tools xorg-server xorg-server-common xorg-xinit xorg-xmodmap xorg-xrandr zsh

# audio
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service

# stow
cd $SCRIPTPATH
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
curl 'https://gist.githubusercontent.com/seriousm4x/b93b2af2c226b82d755309f87ef936d3/raw/5cb4fd37b7984aed61997a157429cc032b90b297/.zpreztorc' -o ~/.zpreztorc
echo 'export PATH=$PATH:/home/max/.local/bin' >> ~/.zshrc
echo 'alias ssh="kitty +kitten ssh"' >> ~/.zshrc
chsh -s /bin/zsh

# startx at login
cat <<EOT >> ~/.zprofile
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
EOT

echo ""
echo "Installation done. Please reboot."
echo ""
