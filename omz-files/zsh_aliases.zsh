# Zsh aliases and functions

# Custom Functions
# this will show all Powerlevel10K prompt elements
p10k-prompt-info() {
  typeset -A reply
  p10k display -a '*'
  printf '%-32s = %q\n' ${(@kv)reply} | sort
}

# cheat sheets (github.com/chubin/cheat.sh), find out how to use commands
# example 'cheat tar'
# for language specific question supply 2 args first for language, second as the question
# eample: cheat python3 execute external program
cheat() {
    if [ "$2" ]; then
        curl "https://cheat.sh/$1/$2+$3+$4+$5+$6+$7+$8+$9+$10"
    else
        curl "https://cheat.sh/$1"
    fi
}

speedtest() {
    curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
}

# Aliases
#-------------------
alias omz-dir="$ZDOTDIR/.oh-my-zsh"
alias zsh-dir="$ZDOTDIR/"
alias update-db="sudo updatedb --prunepaths='/timeshift/snapshots /media /run/timeshift /run/user'"
alias e='echo'
alias s='sudo'
alias cpd='cp -r'
alias fk='fuck'
alias mksymlink='ln -srv'
alias mksymlinkffs='sudo ln -srv'
alias search='find | grep -r'

# apt/apt-get aliases and upgrade alias
alias fix='sudo apt-get install -f'
alias update-apt='sudo apt update'
alias sapt-get='sudo apt-get'
alias sapt='sudo apt'
alias scache='sudo apt-cache'
alias cleanup='sudo apt-get --purge autoremove -y && sudo apt-get autoclean -y'
alias upgrade-parrot='sudo parrot-upgrade'

# git aliases
alias gitbranch='git switch'
alias commit-all='git commit -a -m'
alias status='git status'

# docker aliases
alias d='docker'
alias dps='docker ps'

# ip info aliases and other system aliases
alias extip='curl https://ipecho.net/plain; echo'
alias intip='hostname -I; echo'
alias pc-shutdown='sudo shutdown now'
alias pc-restart='sudo reboot'
alias help='run-help'
alias sysctl='sudo systemctl'
alias sysd='sudo systemd'
#-------------------
