# Zsh aliases and functions


# ALIASES
# this alias shouldn't be set unless on parrot distro
if var=$(cat /etc/os-release | grep -wo 'parrot'); then
    alias sys-update='sudo parrot-upgrade'
else
    unalias sys-update
fi

# aliases for cp, symlinks, etc.
alias z='cd $ZDOTDIR'
alias zdir="$ZDOTDIR/"
alias update-db="sudo updatedb --prunepaths='/timeshift/snapshots /media /run/timeshift /run/user'"
alias e='echo'
alias cls='clear && prompt-at-bottom'
alias s='sudo'
alias cpd='cp -r'
alias cpd-ffs='sudo cp -r'
alias symlinkmk='ln -srv'
alias symlinkmk-ffs='sudo ln -srv'
alias own='sudo chown -v $USER:$USER'
alias owndir='sudo chown -R $USER:$USER'
alias fk='fuck'

# apt/apt-get/dpkg aliases
alias fix='sudo apt-get install -f'
alias au='sudo apt-get update'
alias ai='sudo apt-get install'
alias ar='sudo apt-get remove'
alias ap='sudo apt purge'
alias sapt-get='sudo apt-get'
alias sapt='sudo apt'
alias sapt-cache='sudo apt-cache'
alias showpkg='sudo apt show'
alias searchpkg='sudo apt search'
alias mark-auto='sudo apt-mark auto'
alias mark-manual='sudo apt-mark manual'
alias cleanup='sudo apt-get --purge autoremove -y && sudo apt-get autoclean -y'
alias reconfigure='sudo dpkg-reconfigure'
alias add-architecture='sudo dpkg --add-architecture'

# git aliases
alias gswitch='git switch'
alias gcommitall='git commit -a'
alias gstatus='git status'


# docker aliases
alias d='docker'
alias dps='docker ps'

# ip info aliases and other system aliases
alias extip='curl https://ipecho.net/plain; echo'
alias intip='hostname -I; echo'
alias shutdown='sudo shutdown now'
alias help='run-help'
alias sysctl='sudo systemctl'
alias sysd='sudo systemd'

# FUNCTIONS

# displays alias information when zsh is started if $aliasmsg is true in .zshrc
helpmessage() {
  if $aliasmsg; then
    echo 'Remember to use cheat to lookup cheatsheets if needing help\n'
    echo 'Aliases to remember are:\n`sys-update` to run `parrot-upgrade` | `cpd` (`cp -r`) | `cpd-ffs` (`sudo cpd`) | `symlinkmk` (`ln -srv`)'
    echo '\nPackage Handling Alias Commands:\n`au` | `ai` | `ar` | `ap` (update install remove purge)'
    echo '`showpkg` | `searchpkg` | `mark-auto` | `mark-manual` | `reconfigure` | `add-architecture`'
    echo '\nGit Alias Commands:\n`gswitch` | `gcommitall` | `gstatus`\n'
    echo 'Use `z` to change to $ZDOTDIR.\nYou can use `own` `owndir` to take ownership of files and directories, respectively.'
    echo 'NOTE: `owndir` recursively gives you ownership of ALL files in a directory.'
  fi
}

# This is because I'm using transient prompt and my prompt
# doesn't magically start at the bottom of the terminal
prompt-at-bottom() {
  printf '\n%.0s' {1..100}
}

# this will show all Powerlevel10K prompt elements
p10k-prompt-info() {
  typeset -A reply
  p10k display -a '*'
  printf '%-32s = %q\n' ${(@kv)reply} | sort
}

commit-push() {
  if [[ $VCS_STATUS_HAS_UNSTAGED != 0 || $VCS_STATUS_HAS_UNTRACKED != 0 ]]; then
    git status
    printf "\nEnter a commit message: "
    read -r commit_msg
    if [ "$commit_msg" != "" ]; then
      git commit -a -m "$commit_msg"
      git push
      printf "\nChanges committed and pushed to the upstream branch successfully.\n"
    else
      printf "\nCommit message cannot be nothing. Nothing committed.\n"
    fi
  else
    printf "Nothing to commit!\n"
  fi
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
