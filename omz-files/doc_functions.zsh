#!/bin/zsh
# FUNCTIONS

# COLORS (to make help message look pretty)
color_off='\033[0m'
# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White
# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White


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
    echo $BRed'       USEFUL COMMANDS'
    echo $IWhite'-------------------------------'
    echo $BIBlue'Use `sys-update` to update & upgrade Parrot, `sys-info` will dispay information about your system (and this message). You can use `s` and `e` for `sudo` and `echo`, respectively.'
    echo 'Use `own` to take ownership of files. Use `owndir` to recursively take ownership of directories.'
    echo 'Use `z` to change to $ZDOTDIR. Use cheat to lookup cheatsheets if needing help.'
    echo $IWhite'-------------------------------'
    echo $BIGreen'GENERAL(Aliases listed here have -ffs alias versions which use sudo): `cpd` (`cp -r`) | `symlinkmk` (`ln -srv`)'
    echo 'APT/DPKG(no need to use sudo with these):\n`clean`=apt-get autoremove with --purge and apt-get autoclean | `afix`=apt-get install -f'
    echo '`a`=apt | `ag`=apt-get | `ac`=apt-cache | `fix`=apt-get install -f'
    echo '`au`=update || `ai`=install || `ar`=reinstall || `arm`=remove || `ap`=purge || `af`=search || `ash`=show'
    echo '`mark-auto`=apt-mark auto | `mark-manual`=apt-mark manual | `reconfigure`= dpkg-reconfigure | `add-architecture`=dpkg --add-architecture'
    echo $IWhite'-------------------------------'
    echo $BICyan'GIT: `git-commit-push`=prompt for commit msg and push | `gsw`=switch branch | `gl`=pull | `gp`=push | `gstat`=status | `gstall`=commit all'
	echo 'Keep in mind, `git-commit-push` prompts for a commit message and then immediately pushes all changes to the repo. So be mindful of what files it will be committing.\n'
	echo $BRed'IF USING PARROT OS DO NOT USE APT UPGRADE! USE PARROT-UPGRADE INSTEAD, PARROT IS A ROLLING DISTRO AND USING APT UPGRADE CAN MESS THINGS UP!' $color_off
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

'''
# function for committing changes and pushing to github automatically
gc-push() {
	if [[ $VCS_STATUS_HAS_UNSTAGED != 0 || $VCS_STATUS_HAS_UNTRACKED != 0 ]]; then
		if git status; then
			printf "Enter a commit message:\n"
			vared -c commit_msg
			if [ "$commit_msg" != "" ]; then
				git commit -a -m "$commit_msg"
				if git push; then
					printf "Changes committed and pushed to the upstream branch successfully.\n"
				else
					printf "Something went wrong. Nothing pushed to upstream branch.\n"
				fi
			else
				printf "Commit message cannot be nothing.\n"
			fi
			else
				printf "Nothing to commit!\n"
		fi
	fi
}
'''

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
