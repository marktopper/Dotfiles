# Dotfiles personalized for Parrot OS
My Parrot Linux Zsh dotfiles (plus an install script for automatically setting them up)

Keep in mind I've tried keeping everything POSIX compliant, but as much as I'd like this dotfiles install to be able to be run on any system, I don't yet know enough about this sort of thing, and so I have to warn anyone not using Parrot OS that you may encounter issues.

# NEW: Added functionality to allow for choosing Powerlevel10K custom prompts
You see a custom prompt file that someone else has set up for P10K and you decide you'd like to use it.
Normally, you'd have to go into .zshrc, after knowing where this P10K file is located, and source it.

I didn't really like having to do that every time, so I added a short file within P10K-themes/ called p10k-theme-config.sh to handle sourcing a custom prompt theme, or sourcing good ole .p10k.zsh if the custom prompt theme cannot be found for sourcing.

Instead of typing source and all that, simply set the P10K_THEME variable in your .zshrc file to the name of a custom p10k .zsh theme file you've placed within P10K-themes. 

# Be sure to add .zsh to the end of whatever p10k theme files you wanna use, otherwise there will likely be problems.
Example: To use my prompt theme (now rennamed docstheme.zsh, located in the P10K-themes directory) you simply add to .zshrc: P10K_THEME="docstheme"
In .zshrc the lines at the very bottom (of the .zshrc file included in this repo anyway) are for providing this functionality, so bear that in mind.

# install.sh notes:
You can choose whether or not to install the major packages that this script is set up to install. You'll be prompted throughout running the script and asked whether you want to install something like miniconda3, for example. Be aware, Oh-My-Zsh isn't one of these packages, it has to be installed.

Running install.sh will set the $ZDOTDIR environment variable, meaning Zsh will look for Zsh dotfiles(and store them by default) within ~/.config/zsh instead of your home directory. The install script adds a line (export ZDOTDIR="$HOME/.config/zsh") exporting ZDOTDIR within the /etc/zsh/zshenv file if it isn't already present in the file.

The script also asks if you'd like to download and install(if not already installed) LinuxBrew(aka HomeBrew) and Miniconda3.
It then installs and sets up Oh-My-Zsh, certain OMZ plugins, Powerlevel10k theme, and some Patched Nerd Fonts.

You will need to have wget, git and Zsh installed before you try to run the install.sh script.
Having autojump, fzf, and thefuck installed is also recommended, but not required.
I have the plugins for them enabled in my .zshrc file but you can just remove whichever ones you don't want to use.
