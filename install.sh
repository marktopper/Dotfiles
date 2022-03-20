#!/bin/bash

# variables
CLONED_REPO=$(dirname "$0")
CLONED_REPO=$(cd "$CLONED_REPO" && pwd)
INSTALL_DIRECTORY="$HOME/.config/zsh"
SHELL="$SHELL"

# functions
function clone_to_omz(){
    type=$1 # repo type, either plugins or themes
    repo=$2
    name=$(echo "${repo##*/}" | cut -f 1 -d '.')
    if [ -d "$ZSH/custom/$type/$name" ]; then
        cd "$ZSH/custom/$type/$name" && git pull
    else
        git clone --depth=1 "$repo" "$ZSH/custom/$type/$name"
    fi
}

function font_install(){
    font=$1
    link=$2
    fontname=$(echo "${font//\\}" | cut -f 1 -d '.')
    if [[ -f "$HOME/.fonts/$font" ]]; then
        printf "%s\n" "$fontname already installed"
    else
        printf "%s\n" "Installing $fontname..."
        wget -q --show-progress -N "$link" -P "$HOME/.fonts/"
    fi
}

function backup(){
	file=$1
	file_loc=$HOME/$file
	backup_loc="$HOME"/Backup_Dotfiles/"$file"_$(date +"%Y-%m-%d")
	if [ -f $file_loc ]; then
		printf "%s\n" "Found $file, backing up $file to $HOME/Backup_Dotfiles..."
		mv "$file_loc" "$backup_loc"
		printf "%s\n" "Backed up current $file to $backup_loc"
	fi
}

function pkg_manager_install(){
	pkg_manager=$1
	pkg_manager_cmd=$2
	if [ $# -eq 2 ]; then # if 2 params package manager is meant to update
		sudo $pkg_manager $pkg_manager_cmd
	elif [ $# -eq 3 ]; then # if 3 params package manager is meant to install
		package=$3
		sudo $pkg_manager $pkg_manager_cmd $package
	fi
}

# Example = update_then_install `pkg manager` `update command` `install command` `package to install`
function update_then_install(){
	pkg_manager=$1
	pkg_update=$2
	pkg_install=$3
	package=$4
        sudo $pkg_manager $pkg_update
	if command -v "$package" > /dev/null 2>&1; then
		printf "%s\n" "$package already installed"
	else
		sudo $pkg_manager $pkg_install $package --yes
		printf "\n%s\n" "$package has been installed successfully"
	fi
}

# ============BEGIN============
# check if necessary packages are installed
req_pkgs=(zsh git wget neofetch fzf thefuck)

if command -v apt-get > /dev/null 2>&1; then
	sudo apt-get update
	for package in "${req_pkgs[@]}"; do
		sudo apt-get install $package
	done
else
	if command -v pacman > /dev/null 2>&1; then
		for package in "${req_pkgs[a]}"; do
			update_then_install pacman -Syu -S $package
		done
	elif command -v dnf > /dev/null 2>&1; then
		for package in "${req_pkgs[a]}"; do
			update_then_install dnf update install $package
		done
	elif command -v yum > /dev/null 2>&1; then
		for package in "${req_pkgs[a]}"; do
			update_then_install yum check-update install $package
		done
	else
		printf "%s\n" "An error occurred, this may be due to a compatibility issue with your linux distribution."
		printf "\n%s\n%s\n" "If the error continues please consider creating an issue here:" "https://github.com/DocMemes/Dotfiles"
		sleep 5 && exit
	fi
fi

# ASK TO BACKUP FILES --- ZSH CONFIG INSTALLS BEGIN AFTER THIS
backup_files=(.zshrc .zprofile .zshenv .zlogin .zlogout .bashrc .bash_profile .bash_logout .profile)
while true; do
    printf "During this install, any zsh related dotfiles (such as .zshrc, .zshenv) in user's home directory will be deleted.\n"
    printf "Are there dotfiles in your home directory that you want to backup?\n"
    read -rp "Backup existing dotfiles in home directory? [Y/n]: " yn
    case $yn in
        [Yy]* )
            printf "Starting backup...\n"
            mkdir -p "$HOME/Backup_Dotfiles" # Create file backup directory
            # Backup files
	    for file in $backup_files; do
		    backup $file
		done
	    printf "Finished backing up any existing zsh files. Continuing...\n" && sleep 1
            break ;;
        [Nn]* )
            printf "Continuing without backing up existing zsh files...\n" && sleep 1
            break ;;
        * )
            printf "Please provide a valid answer.\n" ;;
    esac
done

# CHOOSE INSTALL DIRECTORY
while true; do
    printf "\n%s\n" "Where should your zsh and oh-my-zsh configuration files be installed?"
    printf "%s\n" "Default install directory is: $INSTALL_DIRECTORY"
    printf "  - %s\n" "Press ENTER to confirm the location" "Press CTRL-C to abort the installation" "Or specify a different location below"
    printf "[%s] >>> " "$INSTALL_DIRECTORY"
    read -r user_prefix
    if [ "$user_prefix" != "" ]; then
        case "$user_prefix" in
            *\ * )
                printf "ERROR: Cannot install into directories with spaces\n" >&2
                continue ;;
            *)
                eval INSTALL_DIRECTORY=$(echo "${user_prefix%/}") ;;
        esac
    fi
    # check if user entry contained spaces
    case "$INSTALL_DIRECTORY" in
        *\ * )
            printf "ERROR: Cannot install into directories with spaces\n" >&2
            continue ;;
    esac
    # if directory exists, don't try creating it
    if [ -e "$INSTALL_DIRECTORY" ]; then
        printf "\n%s\n" "Directory already exists, no need to create it."
        break
    else
        if mkdir -p "$INSTALL_DIRECTORY" 2>/dev/null; then
            printf "\n%s\n" "Directory created." && ls -ld "$INSTALL_DIRECTORY" && sleep 1
            break
        else # let user know we couldn't create directory
            printf "%s\n%s\n%s\n" '!-------------------------!' "Couldn't create directory: $INSTALL_DIRECTORY" '!-------------------------!'
            printf "Make sure you have the correct permissions to create the directory.\n" && sleep 3
            INSTALL_DIRECTORY=$HOME/.config/zsh
            continue
        fi
    fi
done

# Oh-My-ZSH INSTALL
printf "\n%s\n" "Installing oh-my-zsh into $INSTALL_DIRECTORY" && sleep 1
export ZSH=$INSTALL_DIRECTORY/.oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then # OMZ already installed, but located in user's home dir
    printf "%s\n" "oh-my-zsh is already installed in home directory, moving to new $INSTALL_DIRECTORY directory..."
    mv "$HOME/.oh-my-zsh" "$INSTALL_DIRECTORY"
    cd "$INSTALL_DIRECTORY/.oh-my-zsh" && git pull
else
    if [ -d "$INSTALL_DIRECTORY/.oh-my-zsh" ]; then # OMZ installed in install dir
        printf "%s\n" "oh-my-zsh is already installed in $INSTALL_DIRECTORY."
        cd "$INSTALL_DIRECTORY/.oh-my-zsh" && git pull
    else
        printf "oh-my-zsh is not installed. Installing...\n" # OMZ not installed
        sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
    fi
fi

printf "\n%+50s\n\n" "READY TO INSTALL OhMyZSH PLUGINS" && sleep 1

if [ ! -d "$INSTALL_DIRECTORY/.oh-my-zsh" ]; then
    printf "%s\n" "Something's wrong, oh-my-zsh isn't in $INSTALL_DIRECTORY..."
    printf "Checking if oh-my-zsh is in home directory...\n" && sleep 3
    if [ -d ~/.oh-my-zsh ]; then
        printf "%s\n" "oh-my-zsh is in home directory, will move it to $INSTALL_DIRECTORY..."
        mv "$HOME/.oh-my-zsh" "$INSTALL_DIRECTORY" && printf "%s\n" "oh-my-zsh directory moved to $INSTALL_DIRECTORY, can proceed now" && sleep 3
    else
        printf "oh-my-zsh is NOT in correct directory, something is wrong\n"
        printf "Exitting before attempting anything further\n" && sleep 3
        exit
    fi
else # INSTALL (or update) OMZ PLUGINS
    clone_to_omz plugins https://github.com/doctormemes/add-to-omz.git
    clone_to_omz plugins https://github.com/doctormemes/p10k-promptconfig.git
    clone_to_omz plugins https://github.com/zsh-users/zsh-autosuggestions.git
    clone_to_omz plugins https://github.com/zsh-users/zsh-syntax-highlighting.git
    clone_to_omz plugins https://github.com/marlonrichert/zsh-autocomplete.git
    clone_to_omz plugins https://github.com/zsh-users/zsh-history-substring-search.git
    clone_to_omz themes https://github.com/romkatv/powerlevel10k.git
fi

# INSTALL EMOJI FONTS IF NONE FOUND
if fc-list | grep -i emoji >/dev/null; then
    printf "Emoji fonts found, won't install any more. If emojis are missing try downloading fonts-noto-color-emoji and fonts-recommended packages\n" && sleep 1
else
	if command -v apt > /dev/null 2>&1; then
		if sudo apt install -y fonts-noto-color-emoji fonts-recommended || sudo pacman -S fonts-noto-color-emoji fonts-recommended || sudo dnf install -y fonts-noto-color-emoji fonts-recommended || sudo yum install -y fonts-noto-color-emoji fonts-recommended || pkg install fonts-noto-color-emoji fonts-recommended;
		then
		    printf "Fonts to show latest emojis are installed\n"
		else
		    printf "Couldn't install fonts, latest emojis may not show correctly\n"
		fi
	fi
fi

# INSTALL NERD FONTS
while true; do
    printf "\nWould you like to install nerd fonts?\n"
    read -rp "Install nerd fonts? [Y/n]: " yn
    case $yn in
        [Yy]* )
            # Meslo LG S Regular Nerd Font
            font_install "Meslo LG S Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete.ttf

            # DejaVu Sans Mono Nerd Font
            font_install "DejaVu Sans Mono Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf

            # Roboto Mono Nerd Font
            font_install "Roboto Mono Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf

            # Hack Regular Nerd Font
            font_install "Hack Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf

            # Sauce Code Pro Nerd Font
            font_install "Sauce Code Pro Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf

            # Scan new fonts and build font information cache files
            fc-cache -fv "$HOME/.fonts"
            break ;;
        [Nn]* )
            printf "\nWill not install Nerd Fonts. Continuing...\n";
            break ;;
        * )
            printf "\nPlease provide a valid answer.\n" ;;
    esac
done

# START TO COPY FILES FROM REPO
# create completions directory in .oh-my-zsh if needed
[ ! -d "$INSTALL_DIRECTORY/.oh-my-zsh/completions" ] && mkdir -p "$ZSH/completions"

# Start operations within omz-files directory
for i in "$CLONED_REPO/omz-files"/*; do
    # copy completion files to oh-my-zsh
    [[ -f "$i" ]] && cp -uv "$i" "$ZSH/completions/"
done && sleep 1

# copy regular files
for i in "$CLONED_REPO"/* ; do
    if [[ -f "$i" && ("$i" != *"LICENSE" && "$i" != *"install.sh") ]]; then
        printf "\n%s\n" "Copying $i to $INSTALL_DIRECTORY"
        cp -fv "$i" "$INSTALL_DIRECTORY"
    fi
done

# copy hidden files
for i in "$CLONED_REPO"/.* ; do
    if [[ -f "$i" && "$i" != *".gitignore" ]]; then
        printf "\n%s\n" "Copying $i to $INSTALL_DIRECTORY"
        cp -fv "$i" "$INSTALL_DIRECTORY"
    fi
done

printf "%s\n" "Finished setting up repo files in new $INSTALL_DIRECTORY directory." && sleep 1
# Remove remaining zsh files in $HOME directory (if the install directory isn't $HOME)
if [ "$INSTALL_DIRECTORY" != "$HOME" ]; then
    printf "Removing remaining .zsh* and .bash* dotfiles in user's home directory...\n"
    if [[ -d "$HOME/.zsh" || -d "$HOME/zsh" ]]; then
        cd "$HOME" && rm -f .zshrc .zshenv .zsh_history .bashrc .bash_profile .bash_history
    else
        cd "$HOME" && rm -f .zsh* .bash*
    fi
fi

cd "$HOME" || exit

PARTIAL_DIRECTORY="${INSTALL_DIRECTORY#$HOME/}"

if [ "$HOME" != "$INSTALL_DIRECTORY" ]; then
    INSERT_TEXT="[[ -z \"\$ZDOTDIR\" && -f \$HOME/$PARTIAL_DIRECTORY/.zshrc ]] && export ZDOTDIR=\$HOME/$PARTIAL_DIRECTORY"
else
    INSERT_TEXT="if [ -n '\$(find \$HOME -prune -user \"\$(id -u)\")' ]; then
    [[ -z \"\$ZDOTDIR\" && -f \$HOME/.zshrc ]] && export ZDOTDIR=\$HOME/
fi"
fi

while true; do
    printf "\n%s\n\v%s\n" "Zsh, by default, looks for zshrc, zshenv, etc.. in the user's home directory, so we set the ZDOTDIR variable required to let Zsh know where to look for these files." "We can symlink the zshenv file with the export ZDOTDIR line in it to your home directory from your $INSTALL_DIRECTORY directory, or we can export the variable in /etc/zsh/zshenv (this is my preferred method)."
    printf "\nIf already set, you can press enter to continue.\n"
    printf "\n%+50s\n" "OPTIONS:"
    printf "\t%s\t%s\n" "[1]" "Create symbolic link to $INSTALL_DIRECTORY/.zshenv in $HOME directory to point to your ZSH install directory."
    printf "\t%s\t%s\n" "[2]" "Configure global ZSH file /etc/zsh/zshenv to set ZSH install directory to $INSTALL_DIRECTORY (may require sudo priviledges)"
    printf "\t[Enter] \tDo nothing; ZDOTDIR is already set.\n"
    printf "\t>>> "
    read -r choice

    case $choice in
        [1] )
            printf "\nCreated symbolic link in home directory:\n"
            ln -sv "$INSTALL_DIRECTORY/.zshenv" "$HOME/.zshenv"
            if ! grep -Fxq $INSERT_TEXT "$HOME/.zshenv"; then
                printf "Inserting lines to export ZDOTDIR into $HOME/.zshenv file...\n"
                echo -e "$INSERT_TEXT" >> $HOME/.zshenv
            fi
            printf "Success.\n"
            printf "%s\n" 'YOU WILL NEED TO MODIFY $HOME/.zshenv IF YOU CHANGE YOUR ZSH DIRECTORY LOCATION!' && sleep 5
            break ;;
        [2] )
            if ! grep -Fxq $INSERT_TEXT "/etc/zsh/zshenv"; then
                printf "\nInserting lines to export ZDOTDIR into /etc/zsh/zshenv file...\n"
                echo -e "$INSERT_TEXT" >> /etc/zsh/zshenv
            fi
                printf "Success.\n"
                printf "%s\n" 'YOU WILL NEED TO MODIFY /etc/zsh/zshenv IF YOU CHANGE YOUR ZSH DIRECTORY LOCATION!' && sleep 5
            printf "\n%s\n" "$INSERT_TEXT" | sudo tee -a /etc/zsh/zshenv > /dev/null
            echo -e "$INSERT_TEXT" | sudo tee -a /etc/zsh/zshenv > /dev/null
            printf "/etc/zsh/zshenv will set and export ZDOTDIR\n"
            printf "%s\n" '!!!IMPORTANT: YOU WILL NEED TO MODIFY THIS FILE IF YOU CHANGE YOUR ZDOTDIR DIRECTORY LOCATION!' && sleep 5
            break ;;
        "" )
            if [ -z "$ZDOTDIR" ]; then
            printf "You don't have the ZDOTDIR variable set! You need to choose one of the above options. Read through them carefully.\n"
            continue
            elif [ -n "$ZDOTDIR" ]; then
            printf "Variable already set. Nothing will be done. Continuing on to final steps...\n" && sleep 5
            break
            fi ;;
        * )
            printf "\nPlease enter a valid choice.\n" ;;
    esac
done

if [[ "$INSTALL_DIRECTORY" != "$HOME" && -z "$ZDOTDIR" ]]; then
    export ZDOTDIR="$INSTALL_DIRECTORY"
elif [[ "$INSTALL_DIRECTORY" == "$HOME" && -z "$ZDOTDIR" ]]; then
    export ZDOTDIR=${ZDOTDIR:-$HOME}
fi

# Check if default shell is zsh
if [[ "$SHELL" != *"/zsh" ]]; then
    # Change default shell to zsh & run omz update
    printf "Default shell is NOT zsh\n"
    printf "Sudo access may be needed to change default shell\n"
    if chsh -s "$(which zsh)" && "$(which zsh)" "$INSTALL_DIRECTORY/.oh-my-zsh/tools/upgrade.sh"; then
        printf "Installation Successful, exit terminal and enter a new session\n"
    else
        printf "Something went wrong\n"
    fi
else
    printf "%s\n" "Default shell is already $(which zsh)"
    printf "Updating oh-my-zsh\n" && sleep 1
    if $(which zsh) "$INSTALL_DIRECTORY/.oh-my-zsh/tools/upgrade.sh"; then
        printf "Installation Successful, exit terminal and enter a new session\n"
    else
        printf "Something went wrong\n"
    fi
fi

exit
