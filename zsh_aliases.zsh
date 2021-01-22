# Aliases can be placed here, though oh-my-zsh users 
# are encouraged to define aliases within the ZSH_CUSTOM folder.
# 'alias' command will print a list of every alias

# this will show all Powerlevel10K prompt elements
prompt-elements() {
  typeset -A reply
  p10k display -a '*'
  printf '%-32s = %q\n' ${(@kv)reply} | sort
}

# Shortcut aliases
#-------------------
alias p10k-prompt=prompt-elements
alias update-db="sudo updatedb --prunepaths='/timeshift/snapshots /run/timeshift /run/user'"
alias omz-dir="$ZDOTDIR/.oh-my-zsh"
alias python-projects="~/Projects/Python"
alias JS-projects="~/Projects/JavaScript"
alias bashscript-projects="~/Projects/BashScripts"
alias e='echo'
alias s='sudo'
alias fk='fuck'
# aliases for docker, apt commands, getting IP info etc.
#-------------------
alias d='docker'
alias dps='docker ps'
alias mksymlink='ln -srv'
alias mksymlinkffs='sudo mkslink'
alias fix='sudo apt-get install -f'
alias update-apt='sudo apt update'
alias upgrade-parrot='sudo parrot-upgrade'
alias sapt-get='sudo apt-get'
alias sapt='sudo apt'
alias acache='sudo apt-cache'
alias cleanup='sudo apt-get --purge autoremove -y && sudo apt-get autoclean -y'
alias extip='curl https://ipecho.net/plain; echo'
alias intip='hostname -I; echo'
alias pc-shutdown='sudo shutdown now'
alias pc-restart='sudo reboot'
alias help='run-help'
alias sysctl='sudo systemctl'
alias sysd='sudo systemd'
#-------------------
