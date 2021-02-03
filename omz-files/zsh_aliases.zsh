# Zsh aliases and functions


# ALIASES
# this alias shouldn't be set unless on parrot distro
if var=$(cat /etc/os-release | grep -wo 'parrot'); then
    alias sys-update='sudo parrot-upgrade'
else
    unalias sys-update
fi

# aliases for cp, symlinks, etc.
alias help='help-function'
alias z='cd $ZDOTDIR'
alias zdir="$ZDOTDIR/"
alias update-db="sudo updatedb --prunepaths='/timeshift/snapshots /media /run/timeshift /run/user'"
alias e='echo'
alias system-info='neofetch && info-message'
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
alias gcommitall='git commit -a'
alias gstatus='git status'
alias pullreq='gh pr create --fill'
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

# neofetch alias
# alias neofetch='neofetch --source $ZDOTDIR/banner.txt'

# FUNCTIONS

help-function() {
  if [ "$*" = "" ]; then
    info-message
  elif [ ! "$1" = "" ]; then
    run-help "$1"
  fi
}

# displays helpful info if $HELP_MSG is true
info-message() {
  if $HELP_MSG; then
    printf '\nUSEFUL COMMANDS\n'
    printf '-------------------------------\n'
    printf 'Use `sys-update` to update & upgrade Parrot.\n'
    printf 'Use `own` to take ownership of files. Use `owndir` to recursively take ownership of directories.\n'
    printf 'Use `z` to change to $ZDOTDIR. Use cheat to lookup cheatsheets if needing help.\n'
    printf '\nUSEFUL ALIAS INFO\n'
    printf '-------------------------------\n'
    printf 'General Aliases(The ones here have -ffs alias versions using sudo): `cpd` (`cp -r`) | `symlinkmk` (`ln -srv`) \n'
    printf 'Apt Aliases: `au` | `ai` | `ar` | `ap` (update install remove purge)'
    printf '`showpkg` | `searchpkg` | `mark-auto` | `mark-manual` | `reconfigure` | `add-architecture`\n'
    printf 'Git Aliases: `gsw` (switch branch) | `gcommitall` | `gstatus` | `gstall` (stash all)\n\n'
  fi
}

# This is because I'm using transient prompt and my prompt
# doesn't magically start at the bottom of the terminal
prompt-cfg() {  
  if [[ -o interactive ]]; then
    printf '\n%.0s' {1..100}
    neofetch
    info-message
  elif [[ -o login ]]; then
    info-message
  fi
}

# this will show all Powerlevel10K prompt elements
p10k-prompt-info() {
  typeset -A reply
  p10k display -a '*'
  printf '%-32s = %q\n' ${(@kv)reply} | sort
}

# function for committing changes and pushing to github automatically
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

# pull-and-merge() {
#   if gh pr create --fill; then

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

print-colormap() {
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
}

