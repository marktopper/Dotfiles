# Dotfiles
My linux dotfiles, gotta have em up somewhere.

Running install.sh will set the $ZDOTDIR environment variable, meaning Zsh will look for Zsh dotfiles(and store them by default) within ~/.config/zsh instead of your home directory. This is done using the install script to add a line to the /etc/zsh/zshenv file.

Install.sh also downloads and installs(if not already installed):
LinuxBrew(aka Homebrew), Miniconda3, Oh-My-Zsh, certain OMZ plugins, Powerlevel10k theme, and some Patched Nerd Fonts.

You will need to have wget and Zsh installed before you try to run the install.sh script.
