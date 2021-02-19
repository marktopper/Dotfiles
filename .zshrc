# $ZDOTDIR/.zshrc
#
# P10K instant prompt. Keep close to top of .zshrc. Code that may require console input
# password prompts, etc. must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-~/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-~/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# if there's a $ZDOTDIR directory, oh-my-zsh is probably in it
if [[ -n "$ZDOTDIR" ]]; then
	export ZSH=$ZDOTDIR/.oh-my-zsh
else # oh-my-zsh is probably in home directory, can probably set ZDOTDIR to $HOME to avoid anything breaking :)
    export ZDOTDIR=~
	export ZSH=~/.oh-my-zsh
fi

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# Set command history file location and name with below variable.
HISTFILE=$ZDOTDIR/.zsh_history
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"
# disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"
# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="false"
ENABLE_CORRECTION="false"
CASE_SENSITIVE="false"
# change this to false to turn off the help message and neofetch on terminal startup
STARTUP_CONTENT='true'

# Oh-my-zsh enabled plugins
plugins=(
alias-finder autojump
colored-man-pages colorize
common-aliases conda-zsh-completion
cp docker extract fzf
git git-escape-magic
gitignore jump man nordvpn
pip postgres python
sudo thefuck vscode
zsh-autosuggestions
zsh-syntax-highlighting
zsh_reload)

# P10K is only theme
ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

	autoload -Uz compinit
	rm -f ~/.zcompdump; compinit
fi

# To customize prompt, run `p10k configure`, edit $ZDOTDIR/.p10k.zsh or set P10K_THEME below to a prompt file name in P10K-themes directory.
P10K_THEME="docstheme"
# Uses powerlevel10k prompt themes if using powerlevel10k and P10K_THEME is set
if [[ -n "$P10K_THEME" && "$ZSH_THEME" = *"powerlevel10k"* ]]; then
	[[ -f $ZDOTDIR/P10K-themes/p10k-theme-config.sh ]] && source $ZDOTDIR/P10K-themes/p10k-theme-config.sh
else
	[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
fi

# Deduplicates path, fpath and manpath variables
[[ -e $ZSH/custom/custom_functions.zsh ]] && {
	dedup_pathvar PATH
	dedup_pathvar FPATH
}

# Terminal startup output (won't run unless $STARTUP_CONTENT is true)
if [[ -o interactive && $STARTUP_CONTENT ]]; then
	neofetch
	info-message
elif [[ -o login && $STARTUP_CONTENT ]]; then
	info-message
fi
