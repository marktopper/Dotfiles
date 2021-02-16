# .zshenv is sourced on ALL invocations of the shell, unless the -f option is
# set.  It should NOT normally contain commands to set the command search path,
# or other common environment variables unless you really know what you're
# doing.  E.g. running "PATH=/custom/path gdb program" sources this file (when
# gdb runs the program via $SHELL), so you want to be sure not to override a
# custom environment in such cases.  Note also that .zshenv should not contain
# commands that produce output or assume the shell is attached to a tty.

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='gedit'
fi

# export PATH=~/bin:/sbin:/usr/local/bin:usr/share:$PATH

# Linuxbrew stuff
if [[ -d /home/linuxbrew ]]; then
	eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
	# For compilers to find isl@0.18 you may need to set:
	export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib"
	export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/isl@0.18/include"
	# For pkg-config to find isl@0.18 you may need to set:
	export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib/pkgconfig"
fi
