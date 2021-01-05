# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# For easily navigating/specifying custom omz locations
# Also good for easily navigating to my dotfiles directory
DOTFILES=$HOME/.dotfiles

ZSH_THEME="powerlevel10k/powerlevel10k"

# Because powerlevel10k doesn't already magically start at the bottom :(
printf '\n%.0s' {1..100}

# ---------------------------
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
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
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

# ZSH custom folder path
ZSH_CUSTOM=$DOTFILES/custom

# Because I don't like to be corrected
# and because I'm very insensitive
ENABLE_CORRECTION="false"
CASE_SENSITIVE="false"

# Standard plugins can be found in $ZSH/plugins/
plugins=(
alias-finder
autojump
colored-man-pages
colorize
common-aliases
conda-zsh-completion
cp
debian
docker
docker-compose
docker-machine
dotenv
extract
fzf
git
git-auto-fetch
git-extras
git-flow
github
git-hubflow
gitignore
git-lfs
git-prompt
last-working-dir
man
node
npm
perms
pip
pipenv
please
pyenv
python
sudo
systemd
thefuck
themes
vscode
zsh-autosuggestions
zsh-syntax-highlighting
zsh_reload
)

# sourced files (well, obviously)
source $ZSH/oh-my-zsh.sh
source ~/.zsh_aliases
# source ~/.zsh_functions
source ~/.conda_setup

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/.p10k.zsh.
[[ ! -f ~/.dotfiles/.p10k.zsh ]] || source ~/.dotfiles/.p10k.zsh
