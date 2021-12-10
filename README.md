# .dotfiles

Creates a ready-to-use desktop environment for a fresh arch install, whether you are on a virtualbox/qemu VM or install on real hardware.

![https://i.imgur.com/K6721Rg.png](https://i.imgur.com/K6721Rg.png)

## Installation

Install arch with the `archinstall` script included in the iso. When you're asked if you want to install xorg, select it and also the appropriate graphics driver package.

Once you cloned this repo and run the `./install.sh` script, it will ask you if you prefer a base install or a complete install with extra packages. Take a look at [base.txt](base.txt) or [extra.txt](extra.txt) to see whats included.

### VirtualBox

Make sure to set the display controller to `VMSVGA` for auto resizing features.
