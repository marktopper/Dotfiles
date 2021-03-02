# ALIASES

# alias should only be set if on Parrot OS
if var=$(cat /etc/os-release | grep -wo 'parrot'); then
    alias sys-update='sudo parrot-upgrade'
fi

# Useful aliases
alias s='sudo'
alias rt='sudo -i'
alias e='echo'
alias update-db="sudo updatedb --prunepaths='/timeshift/snapshots /media /run/timeshift /run/user'"
alias sysinfo='neofetch && info-message'
alias fk='fuck'
alias own='sudo chown -v $USER:$USER'
alias owndir='sudo chown -R $USER:$USER'
alias c='conda activate'
alias z='cd $ZDOTDIR'
alias zdir="$ZDOTDIR/"
# copy, symlinks
alias cpd='cp -r'
alias cpd-ffs='sudo cp -r'
alias sl='ln -srv'
alias sl-ffs='sudo ln -srv'
# clean zcomp and zwc zsh files
alias cleanzsh='rm -rf ${ZDOTDIR:-$HOME}/.zcompdump* && rm -rf ${ZDOTDIR:-$HOME}/.zshrc.zwc'

# apt/apt-get/dpkg
alias afix='sudo apt-get install -f'
alias alu='apt list --upgradeable'
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
alias mark-a='sudo apt-mark auto'
alias mark-m='sudo apt-mark manual'
alias aptc='sudo apt-get --purge autoremove -y && sudo apt-get autoclean -y'
alias reconf='sudo dpkg-reconfigure'
alias add-arch='sudo dpkg --add-architecture'

# git aliases
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
