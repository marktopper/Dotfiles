# dotfiles
For my linux dotfiles, you know how it is, you gotta have em up somewhere.

Be aware, running install.sh will create the $ZDOTDIR environment variable and assign the ~/.config/zsh directory path to it, meaning Zsh will look for dotfiles(and store them by default) within ~/.config/zsh instead of your home directory. However, $ZDOTDIR needs to be set somewhere, so I had to have the install.sh script create a symbolic link to .zshenv (where I export $ZDOTDIR) in the $HOME directory in order for Zsh to "see" the $ZDOTDIR environment variable upon startup.

The install script also downloads and does installs for:
LinuxBrew(aka Homebrew), Miniconda3, Oh-My-Zsh, certain OMZ plugins, Powerlevel10k theme, and some Nerd Fonts.

Be sure to have wget before you try to run the install.sh script. Also shout out to jotyGill and their quicz-sh repo because copying and repurposing a lot of the code from their install.sh script helped me learn a lot about bash scripting and my install.sh wouldn't be working without it.
