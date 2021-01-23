# P10K instant prompt. Keep close to top of .zshrc. Code that may require console input 
# password prompts, etc. must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-~/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-~/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Snap completion doesn't work without this
# fpath=($fpath:/usr/share/zsh/vendor-completions)
# For easily navigating to zsh file directory
ZDIR=~/.config/zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
# Because powerlevel10k doesn't magically start at the bottom :(
printf '\n%.0s' {1..100}


# -------------------------
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
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
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"
# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
ENABLE_CORRECTION="false"
CASE_SENSITIVE="false"
#--------------------------


# Oh-my-zsh enabled plugins
plugins=(
alias-finder autojump colored-man-pages colorize
common-aliases conda-zsh-completion cp
docker docker-compose docker-machine dotenv extract fzf
git git-auto-fetch git-escape-magic git-extras gitfast
git-flow github git-hubflow gitignore git-lfs git-prompt
jump man node npm perms
pip pipenv postgres pyenv pylint python
sudo systemd thefuck themes vscode
zsh-autosuggestions zsh-syntax-highlighting zsh_reload)


# Homebrew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# GitHub CLI completions
if [[ ! -d "$ZSH/completions" || ! -f "$ZSH/completions/_gh" ]]; then
    mkdir -pv $ZSH/completions
    gh completion --shell zsh > $ZSH/completions/_gh
    echo "gh added completions: gh completion --shell zsh > $ZSH/completions/_gh"
fi

# sourced files
# source /usr/share/zsh-autocomplete/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit $DOTFILES/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
