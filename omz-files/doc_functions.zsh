#!/bin/zsh
# FUNCTIONS

# Because getting told "there is no list of special help topoics available at this time." is just not helpful enough
better-help() {
  if [ "$*" = "" ]; then
    info-message
  else
    run-help "$1"
  fi
}

# displays helpful info if $HELP_MSG is true
info-message() {
    printf '\nUSEFUL COMMANDS\n'
    printf '-------------------------------\n'
    printf 'Use `sys-update` to update & upgrade Parrot, `sys-info` will dispay information about your system (and this message). You can use `s` and `e` for `sudo` and `echo`, respectively.\n'
    printf 'Use `own` to take ownership of files. Use `owndir` to recursively take ownership of directories.\n'
    printf 'Use `z` to change to $ZDOTDIR. Use cheat to lookup cheatsheets if needing help.\n'
    printf '\nUSEFUL ALIAS INFO\n'
    printf '-------------------------------\n'
    printf 'General(Aliases listed here have -ffs alias versions which use sudo): `cpd` (`cp -r`) | `symlinkmk` (`ln -srv`) \n'
    printf 'Apt/dpkg(btw no need to use sudo with these):\n`clean`=apt-get autoremove with --purge and apt-get autoclean | `afix`=apt-get install -f\n'
    printf '`a`=apt | `ag`=apt-get | `ac`=apt-cache | `fix`=apt-get install -f\n'
    printf '`au`=update || `ai`=install || `ar`=reinstall || `arm`=remove || `ap`=purge || `af`=search || `ash`=show\n'
    printf '`mark-auto`=apt-mark auto | `mark-manual`=apt-mark manual | `reconfigure`= dpkg-reconfigure | `add-architecture`=dpkg --add-architecture\n'
    printf '\nGit:\n`git-commit-push`=prompt for commit msg and push | `gsw`=switch branch | `gl`=pull | `gp`=push | `gstat`=status | `gstall`=commit all\n'
	printf 'Be aware, `git-commit-push` prompts for a commit message and then immediately pushes all changes to the repo. So be mindful of what files it will be committing.\n'
	printf '\nREMEMBER YOU CAN USE `fk` INSTEAD OF RETYPING THE ENTIRE COMMAND IF SOMETHING GOES WRONG!\n'
}

# This is because I'm using transient prompt and my prompt
# doesn't magically start at the bottom of the terminal
terminal-startup() {  
	if [[ -o interactive ]]; then
		printf '\n%.0s' {1..100}
		if $STARTUP_CONTENT; then
			neofetch
			info-message
		fi
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
git-commit-push() {
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

# edit recent git commit
function git-commit-edit() {
	git add .
    if [ "$1" != "" ]; then
        git commit -m "$1"
    else
        git commit -m update # default commit message is `update`
    fi # closing statement of if-else block
    git push origin HEAD
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

print-colormap() {
	for i in {0..255}; do
		print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
	done
}