# .zshenv is always sourced, and so should contain exported 
# variables that should be available to other programs.

export PATH=$HOME/bin:/usr/local/bin:usr/share:/snap/bin:$PATH
export ZSH=$HOME/.oh-my-zsh

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
 else
   export EDITOR='nano'
 fi

