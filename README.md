# .dotfiles

Creates a ready-to-use desktop environment for a fresh arch install, whether you are on a virtualbox/qemu VM or install on real hardware.

![https://i.imgur.com/K6721Rg.png](https://i.imgur.com/K6721Rg.png)

## Installation

In case you use the `archinstall` script included in the iso, select the "minimal pre-programmed profile name".

Once you cloned this repo and run the `./install.sh` script, it will ask you for the graphics driver and if you prefer a base install or a complete install with extra packages. Take a look at [pkg-base.txt](pkg-base.txt) or [pkg-extra.txt](pkg-extra.txt) to see whats included.

### VirtualBox

Make sure to set the display controller to `VMSVGA` for auto resizing features.
