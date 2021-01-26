# Dotfiles
My linux Zsh dotfiles (plus an install script for automatically setting them up)

# install.sh notes:
Running install.sh will set the $ZDOTDIR environment variable, meaning Zsh will look for Zsh dotfiles(and store them by default) within ~/.config/zsh instead of your home directory. The install script adds a line (export ZDOTDIR="$HOME/.config/zsh") exporting ZDOTDIR within the /etc/zsh/zshenv file if it isn't already present in the file.

The script also asks if you'd like to download and install(if not already installed) LinuxBrew(aka HomeBrew) and Miniconda3.
It then installs and sets up Oh-My-Zsh, certain OMZ plugins, Powerlevel10k theme, and some Patched Nerd Fonts.

You will need to have wget, git and Zsh installed before you try to run the install.sh script.
Having autojump, fzf, and thefuck installed is also recommended, but not required.
I have the plugins for them enabled in my .zshrc file but you can just remove whichever ones you don't want to use.
