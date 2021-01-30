#!/bin/sh

# make sure install.sh is being run with bash
if [ "$BASH_VERSION" = '' ]; then
    echo "You are trying to run this script using sh. Please run this script again using bash.\n" && exit
fi

# check if necessary packages are installed
if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget &> /dev/null; then
    printf "Zsh, Git and wget are already installed\n"
else
    if sudo apt install -y zsh git wget || sudo pacman -S zsh git wget || sudo dnf install -y zsh git wget || sudo yum install -y zsh git wget || sudo brew install git zsh wget || pkg install git zsh wget ; then
        printf "Zsh, Git and wget Installed\n"
    else
        printf "Please install the following packages first, then try again: zsh git wget \n" && exit
    fi
fi

INSTALL_DIRECTORY=$HOME/.config/zsh
CLONED_REPO=$(pwd)

# check if cloned repo is in home directory, if not ask to move it to home directory
if [ -d "$HOME/Dotfiles" ]; then
    printf "Dotfiles repo is located within users home directory.\nContinuing...\n"
else
    printf "Dotfiles repo is NOT located with users home directory.\n"
    while true; do
        read -p "Would you like to move the repo to your home directory? [Y/n]" yn
        case  $yn in
            [Yy]* )
                printf "Moving repo to home directory...";
                mv $CLONED_REPO $HOME/Dotfiles;
                cd $HOME/Dotfiles && CLONED_REPO=$(pwd);
                break;;
            [Nn]* )
                printf "Please move the repo to your home directory before running this script again." && exit;
                break;;
            * )
                printf "Please provide a valid answer.";;
        esac
    done
fi


# HOMEBREW/LINUXBREW INSTALL
if [ -d /home/linuxbrew ]; then
    printf "Homebrew is already installed.\n"
else
    printf "Homebrew not installed.\n" 
    while true; do
        read -p "Do you want to install Homebrew? [Y/n]:" yn
        case $yn in
            [Yy]* )
                printf "Installing Homebrew...";
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
                break;;
            [Nn]* )
                printf "Homebrew will not be installed.\nContinuing...";
                break;;
            * )
                printf "Please provide a valid answer.";;
        esac
    done
fi


# MINICONDA INSTALL
if [ -d $HOME/miniconda3 ]; then
    printf "Miniconda3 is already installed.\n"
else
    printf "Miniconda3 is not installed.\n"
    while true; do
        read -p "Do you want to install Miniconda? [Y/n]:" yn
        case $yn in
            [Yy]* )
                printf "Please be sure to install Miniconda3 to your users home directory.";
                if [ -f $HOME/Miniconda3-latest-Linux-x86_64.sh ]; then # to prevent downloading Miniconda3 setup file multiple times
                    printf "Miniconda3 is already downloaded\nStarting Miniconda3 setup..."
                    bash $HOME/Miniconda3-latest-Linux-x86_64.sh
                else
                    printf "Downloading Miniconda3..."
                    wget -q --show-progress https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P $HOME/
                    printf "Download finished.\nStarting Miniconda3 setup..."
                    bash $HOME/Miniconda3-latest-Linux-x86_64.sh
                fi;
                break;;
            [Nn]* )
                printf "Answer: No.\nContinuing...";
                break;;
            * )
                printf "Please provide a valid answer.";;
        esac
    done
fi

[[ -f $HOME/Miniconda3-latest-Linux-x86_64.sh && -d $HOME/miniconda3 ]] && printf "\nRemoving Miniconda3 install file..." && rm -f $HOME/Miniconda3-latest-Linux*

# Ask if user is ready to continue to Zsh configuration
while true; do
    printf "About to start Zsh configuration.\nOh-My-Zsh, nerd fonts, OMZ plugins and Powerlevel10K theme will be installed.\n"
    read -p "Continue? [Y/n]:" yn
    case $yn in
        [Yy]* )
            printf "\nContinuing install...\n"; && cd $HOME
            if [ -f $HOME/.zshrc ]; then # backup .zshrc
                mv $HOME/.zshrc $HOME/.zshrc-backup-$(date +"%Y-%m-%d")
                printf "Backed up current .zshrc to .zshrc-backup-$(date +"%Y-%m-%d")\n"
            fi;
            break;;
        [Nn]* )
            printf "\nStopping install...\n" && exit;
            break;;
        * )
            printf "Please provide a valid answer.";;
    esac
done

# CHOOSE INSTALL DIRECTORY
while true; do
    printf "\\nDefault install directory is:\\n$INSTALL_DIRECTORY\\n"
    printf "  - Press ENTER to confirm the location\\n"
    printf "  - Press CTRL-C to abort the installation\\n"
    printf "  - Or specify a different location below\\n"
    printf "[%s] >>> " "$INSTALL_DIRECTORY"
    read -r user_prefix
    if [ "$user_prefix" != "" ]; then
        case "$user_prefix" in
            *\ * )
                printf "ERROR: Cannot install into directories with spaces\\n" >&2
                continue;;
            *)
                eval INSTALL_DIRECTORY="$user_prefix"
                ;;
        esac
    fi

    case "$INSTALL_DIRECTORY" in
        *\ * )
            printf "ERROR: Cannot install into directories with spaces\\n" >&2
            continue;;
    esac

    if [ -e "$INSTALL_DIRECTORY" ]; then
        printf "Directory already exists, no need to create it."
        break
    else
        if mkdir -p "$INSTALL_DIRECTORY" 2>/dev/null; then
            printf "Directory created.\\n" && ls -ld "$INSTALL_DIRECTORY"
            break
        else
            printf "Couldn't create directory: $INSTALL_DIRECTORY\\nMake sure you have the correct permissions to create the directory.\\n"
            sleep 1
            INSTALL_DIRECTORY=$HOME/.config/zsh
            continue
        fi
    fi
done

# OMZ INSTALL
printf "Installing oh-my-zsh\n"
if [ -d $HOME/.oh-my-zsh ]; then
    printf "oh-my-zsh is already installed in home directory, moving to new $HOME/.config/zsh directory...\n"
    mv $HOME/.oh-my-zsh $INSTALL_DIRECTORY
    cd $INSTALL_DIRECTORY/.oh-my-zsh && git pull
else
    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh ]; then
        printf "oh-my-zsh is already installed in $INSTALL_DIRECTORY.\n"
        cd $INSTALL_DIRECTORY/.oh-my-zsh && git pull
    else
        printf "oh-my-zsh is not installed in $INSTALL_DIRECTORY. Installing...\n"
        git clone --depth=1 git://github.com/robbyrussell/oh-my-zsh.git $INSTALL_DIRECTORY/.oh-my-zsh
    fi
fi

# INSTALL FONTS
printf "Installing Nerd Fonts version of Hack, Roboto Mono, DejaVu Sans Mono, Source Code Pro\n"
if [ -f $HOME/.fonts/DejaVu\ Sans\ Mono\ Nerd\ Font\ Complete.ttf ]; then
    printf "DejaVu Sans Mono Nerd Font already installed.\n"
else
    printf "Installing Nerd Fonts version of DejaVu Sans Mono\n"
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
fi
if [ -f $HOME/.fonts/Roboto\ Mono\ Nerd\ Font\ Complete.ttf ]; then
    printf "Roboto Mono Nerd Font already installed.\n"
else
    printf "Installing Nerd Fonts version of Roboto Mono\n"
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
fi
if [ -f $HOME/.fonts/Hack\ Regular\ Nerd\ Font\ Complete.ttf ]; then
    printf "Hack Nerd Font already installed.\n"
else
    printf "Installing Nerd Fonts version of Hack\n"
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
fi
if [ -f $HOME/.fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete.ttf ]; then
    printf "Sauce Code Pro Nerd Font already installed.\n"
else
    printf "Installing Nerd Fonts version of Source Code Pro\n"
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
fi
fc-cache -fv $HOME/.fonts


# OMZ PLUGINS INSTALL
if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion && git pull
else
    git clone --depth=1 https://github.com/esc/conda-zsh-completion $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion
fi

if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-completions ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-completions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-completions $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-completions
fi

if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search
fi

# INSTALL POWERLEVEL10K THEME
if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k && git pull
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k
fi

cd $HOME

# CREATE BACKUP FILES DIRECTORY
mkdir -p $HOME/Backup_Dotfiles

# BACKUP USER'S FILES
if [ -f $HOME/.p10k.zsh ]; then
    printf ".p10k.zsh already exists, making backup in $HOME/Backup_Dotfiles...\n"
    mv $HOME/.p10k.zsh $HOME/Backup_Dotfiles
fi

if [ -f $HOME/.vimrc ]; then
    printf ".vimrc already exists, making backup in $HOME/Backup_Dotfiles...\n"
    mv $HOME/.vimrc $HOME/Backup_Dotfiles
fi

if [ -f $HOME/.zprofile ]; then
    printf ".zprofile already exists, making backup in $HOME/Backup_Dotfiles...\n"
    mv $HOME/.zprofile $HOME/Backup_Dotfiles
fi

if [ -f $HOME/.zshenv ]; then
    printf ".zshenv already exists, making backup in $HOME/Backup_Dotfiles...\n"
    mv $HOME/.zshenv $HOME/Backup_Dotfiles
fi

if [ -f $HOME/.zshrc ]; then
    printf ".zshrc already exists, making backup in $HOME/Backup_Dotfiles...\n"
    mv $HOME/.zshrc $HOME/Backup_Dotfiles
fi

printf "Finished backing up any existing files to $HOME/Backup_Dotfiles."

# COPY FILES FROM REPO

cd $CLONED_REPO/other_files

# .vimrc needs to go in home directory
if [ -f ./.vimrc ]; then
    cp -f ./.vimrc $HOME
fi

# the two .zsh files in other_files need to go in .oh-my-zsh/custom/
for i in *; do
    if [ -f $i ]; then
        cp -f $i $INSTALL_DIRECTORY/.oh-my-zsh/custom
    fi
done

# directory for storing Powerlevel10K themes
mkdir -p $INSTALL_DIRECTORY/P10K-themes
# copy repo themes to new P10K-themes directory
cd $CLONED_REPO/P10K-themes
for i in * ; do
    if [ -f $i ]; then
        cp -f $i $INSTALL_DIRECTORY/P10K-themes
    fi
done

# recursively copy all dotfiles in the cloned repo directory (except .gitignore)
cd $CLONED_REPO
for i in .* ; do
    if [ -f $i ]; then
        if [[ "$i" != ".gitignore" ]]; then
            printf "Copying $i to $INSTALL_DIRECTORY\n"
            cp -f $i $INSTALL_DIRECTORY
        fi
    fi
done

printf "Finished setting up repo files in new $INSTALL_DIRECTORY directory.\n"
cd $HOME

# check if /etc/zsh/zshenv contains line exporting ZDOTDIR
FILE="/etc/zsh/zshenv"
STRING="export ZDOTDIR=\"\$HOME/.config/zsh\""
if grep -q "$STRING" "$FILE"; then
    printf "ZDOTDIR is already set in /etc/zsh/zshenv"
else
    # set $ZDOTDIR environment variable inside /etc/zsh/zshenv system-wide zshenv file
    printf "\nSudo access is needed to set ZDOTDIR in /etc/zsh/zshenv\n"
    [[ -f /etc/zsh/zshenv ]] && echo 'export ZDOTDIR=$HOME/.config/zsh' | sudo tee -a /etc/zsh/zshenv > /dev/null
fi

# source $HOME/.zshrc
printf "\nSudo access is needed to change default shell\n"

if chsh -s $(which zsh) && /bin/zsh -i -c upgrade_oh_my_zsh; then
    printf "Installation Successful, exit terminal and enter a new session"
else
    printf "Something went wrong"
fi

exit
