# $ZDOTDIR/.zprofile
#
# This file is sourced only for login shells (i.e. shells
# invoked with "-" as the first character of argv[0], and
# shells invoked with the -l flag.)
#
# Order: .zshenv, .zprofile, .zshrc

# For Homebrew
if [[ -d /home/linuxbrew ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
fi

