# beta-ubuntu

**Distro**: Ubuntu 22.04

**DE**: [Regolith](https://regolith-desktop.com/)

**WM**: i3

**Shell**: zsh (Addition: [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh), [Powerlevel10k](https://github.com/romkatv/powerlevel10k))

**Terminal**: gnome-terminal

**Terminal Font**: [VictorMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/VictorMono)

**Theme**: [catppuccin](https://github.com/catppuccin/catppuccin) The gnome-terminal theme has been integrated into the custom Regolith Look. The GTK theme defined as `Catppuccin-blue` (this can be updated in the `root.gtk.theme_name` variable of the Regolith Look) must be installed from [here](https://github.com/catppuccin/gtk).

**Bar**: Polybar

**Launcher**: [ilia](https://github.com/regolith-linux/ilia)

For the custom Regolith Look several custom scripts and configuration files have been created:
- `/usr/share/regolith-ftue/custom-regolith-init-term-profile`: Custom script for the loading of the gnome-terminal configuration defined in the Look.
- `/usr/share/regolith-look/custom_loader.sh`: Custom loader that calls the custom term profile init program.

