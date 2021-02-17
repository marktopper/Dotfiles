#!/bin/zsh
# ALIASES

# this alias shouldn't be set unless on parrot distro
if var=$(cat /etc/os-release | grep -wo 'parrot'); then
    alias sys-update='sudo parrot-upgrade'
fi

# Useful aliases
alias s='sudo'
alias update-db="sudo updatedb --prunepaths='/timeshift/snapshots /media /run/timeshift /run/user'"
alias sys-info='neofetch && info-message'
alias fk='fuck'
alias own='sudo chown -v $USER:$USER'
alias owndir='sudo chown -R $USER:$USER'
alias z='cd $ZDOTDIR'
alias zdir="$ZDOTDIR/"
alias help='better-help'

# cp, symlinks, etc.
alias e='echo'
alias cpd='cp -r'
alias cpd-ffs='sudo cp -r'
alias symlinkmk='ln -srv'
alias symlinkmk-ffs='sudo ln -srv'

# apt/apt-get/dpkg
alias afix='sudo apt-get install -f'
alias au='sudo apt-get update'
alias ai='sudo apt install'
alias ar='sudo apt reinstall'
alias arm='sudo apt remove'
alias ap='sudo apt purge'
alias af='sudo apt search'
alias ash='sudo apt show'
alias ag='sudo apt-get'
alias a='sudo apt'
alias ac='sudo apt-cache'
alias mark-auto='sudo apt-mark auto'
alias mark-manual='sudo apt-mark manual'
alias clean='sudo apt-get --purge autoremove -y && sudo apt-get autoclean -y'
alias reconfigure='sudo dpkg-reconfigure'
alias add-architecture='sudo dpkg --add-architecture'

# git aliases
alias gcall='git commit -a'
alias gstat='git status'
alias prcreate='gh pr create --fill'
alias prmerge='gh pr merge'

# docker aliases
alias d='docker'
alias dps='docker ps'

# ip info aliases and other system aliases
alias extip='curl https://ipecho.net/plain; echo'
alias intip='hostname -I; echo'
alias shutdown='sudo shutdown now'
alias sysctl='sudo systemctl'
alias sysd='sudo systemd'

# misc aliases
# alias neofetch='neofetch --source $ZDOTDIR/banner.txt'