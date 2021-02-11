#!/bin/sh

# check if necessary packages are installed
if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget && command -v neofetch &> /dev/null; then
    printf "Zsh, Git, wget and neofetch are already installed\n"
else
    if sudo apt install -y zsh git wget || sudo pacman -S zsh git wget || sudo dnf install -y zsh git wget || sudo yum install -y zsh git wget || sudo brew install git zsh wget || pkg install git zsh wget ; then
        printf "Zsh, Git, wget and neofetch installed.\n"
    else
        printf "Please install the following packages first, then try again: zsh git wget neofetch\n" && exit
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
                printf "Moving repo to home directory..."
                mv $CLONED_REPO $HOME/Dotfiles
                cd $HOME/Dotfiles && CLONED_REPO=$(pwd)
                break
                ;;
            [Nn]* )
                printf "If an error occurs, you may want to try again after moving the repo to your home directory."
                sleep 1
                break
                ;;
            * )
                printf "Please provide a valid answer."
                ;;
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
                printf "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                break
                ;;
            [Nn]* )
                printf "Homebrew will not be installed.\nContinuing..."
                break
                ;;
            * )
                printf "Please provide a valid answer."
                ;;
        esac
    done
fi


# MINICONDA INSTALL
if [ -d $HOME/miniconda3 ]; then
    printf "\nMiniconda3 is already installed.\n"
else
    printf "\nMiniconda3 is not installed.\n"
    while true; do
        read -p "\nDo you want to install Miniconda? [Y/n]:" yn
        case $yn in
            [Yy]* )
                printf "Please be sure to install Miniconda3 to your users home directory.\n"
                if [ -f $HOME/Miniconda3-latest-Linux-x86_64.sh ]; then # to prevent downloading Miniconda3 setup file multiple times
                    printf "Miniconda3 is already downloaded\nStarting Miniconda3 setup...\n"
                    bash $HOME/Miniconda3-latest-Linux-x86_64.sh
                else
                    printf "Downloading Miniconda3..."
                    wget -q --show-progress https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P $HOME/
                    printf "Download finished.\nStarting Miniconda3 setup...\n"
                    bash $HOME/Miniconda3-latest-Linux-x86_64.sh
                fi
                break
                ;;
            [Nn]* )
                printf "Answer: No.\nContinuing...\n"
                break
                ;;
            * )
                printf "\nPlease provide a valid answer.\n"
                ;;
        esac
    done
fi

# MINICONDA INSTALL CLEANUP
if [ -f $HOME/Miniconda3-latest-Linux-x86_64.sh ] && [ -d $HOME/miniconda3 ]; then
    printf "\nRemoving Miniconda3 install file...\n"
    rm -f $HOME/Miniconda3-latest-Linux*
fi


# Ask if user is ready to continue to Zsh configuration
while true; do
    printf "\nAbout to start Zsh configuration.\nOh-My-Zsh, nerd fonts, OMZ plugins and Powerlevel10K theme will be installed.\n"
    read -p "Continue? [Y/n]:" yn
    case $yn in
        [Yy]* )
            printf "\nContinuing install...\n"
            if [ -f $HOME/.zshrc ]; then # backup .zshrc
                mv $HOME/.zshrc $HOME/.zshrc-backup-$(date +"%Y-%m-%d")
                printf "\nBacked up current .zshrc to .zshrc-backup-$(date +"%Y-%m-%d")\n"
            fi
            sleep 1
            break
            ;;
        [Nn]* )
            printf "\nStopping install...\n" && exit;
            break
            ;;
        * )
            printf "\nPlease provide a valid answer.\n"
            ;;
    esac
done

# CHOOSE INSTALL DIRECTORY
while true; do
    if [ ! -e "$INSTALL_DIRECTORY" ]; then
        printf "\nDefault install directory is:\n$INSTALL_DIRECTORY\n"
        printf "  - Press ENTER to confirm the location\n"
        printf "  - Press CTRL-C to abort the installation\n"
        printf "  - Or specify a different location below\n"
        printf "[%s] >>> " "$INSTALL_DIRECTORY"

        read -r user_prefix
        if [ "$user_prefix" != "" ]; then
            case "$user_prefix" in
                *\ * )
                    printf "ERROR: Cannot install into directories with spaces\n" >&2
                    continue
                    ;;
                *)
                    eval INSTALL_DIRECTORY="$user_prefix"
                    ;;
            esac
        fi
        # check if user entry contained spaces
        case "$INSTALL_DIRECTORY" in
            *\ * )
                printf "\nERROR: Cannot install into directories with spaces\n" >&2
                continue
                ;;
        esac
        # if directory exists, don't try creating it
        if [ -e "$INSTALL_DIRECTORY" ]; then
            printf "\nDirectory already exists, no need to create it.\n"
            break
        else
            if mkdir -p "$INSTALL_DIRECTORY" 2>/dev/null; then
                printf "\nDirectory created.\n" && ls -ld "$INSTALL_DIRECTORY"
                break
            else # let user know we couldn't create directory
                printf "\nCouldn't create directory: $INSTALL_DIRECTORY\nMake sure you have the correct permissions to create the directory.\n"
                sleep 1
                INSTALL_DIRECTORY=$HOME/.config/zsh
                continue
            fi
        fi
    else
        printf "\n$INSTALL_DIRECTORY already exists. No need to create it.\nContinuing...\n"
        break
    fi
done

# OMZ INSTALL
printf "\nInstalling oh-my-zsh\n"
if [ -d $HOME/.oh-my-zsh ]; then
    printf "\noh-my-zsh is already installed in home directory, moving to new $HOME/.config/zsh directory...\n"
    mv $HOME/.oh-my-zsh $INSTALL_DIRECTORY
    cd $INSTALL_DIRECTORY/.oh-my-zsh && git pull
else
    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh ]; then
        printf "\noh-my-zsh is already installed in $INSTALL_DIRECTORY.\n"
        cd $INSTALL_DIRECTORY/.oh-my-zsh && git pull
    else
        printf "\noh-my-zsh is not installed. Installing...\n"
        ZSH=$INSTALL_DIRECTORY/.oh-my-zsh
        sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
    fi
fi

# OMZ PLUGINS
if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion && git pull
else
    git clone --depth=1 https://github.com/esc/conda-zsh-completion.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion
fi

if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autocompletion ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autocompletion && git pull
else
    git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autocomplete
fi

if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search
fi

# POWERLEVEL10K THEME
if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k && git pull
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k
fi

# INSTALL NERD FONTS
while true; do
    printf "\nWould you like to install nerd fonts?\n"
    read -p "Install nerd fonts? [Y/n]:" yn
    case $yn in
        [Yy]* )
            printf "\nInstalling various Nerd Fonts...\n"
            # Meslo LG S Regular Nerd Font
            if [ -f $HOME/.fonts/Meslo\ LG\ S\ Regular\ Nerd\ Font\ Complete.ttf ]; then
                printf "Meslo LG S Regular Nerd Font already installed.\n"
            else
                printf "Installing Meslo LG S Regular Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # DejaVu Sans Mono Nerd Font
            if [ -f $HOME/.fonts/DejaVu\ Sans\ Mono\ Nerd\ Font\ Complete.ttf ]; then
                printf "DejaVu Sans Mono Nerd Font already installed.\n"
            else
                printf "Installing DejaVu Sans Mono Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # Roboto Mono Nerd Font
            if [ -f $HOME/.fonts/Roboto\ Mono\ Nerd\ Font\ Complete.ttf ]; then
                printf "Roboto Mono Nerd Font already installed.\n"
            else
                printf "Installing Roboto Mono Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            
            fi
            # Hack Regular Nerd Font
            if [ -f $HOME/.fonts/Hack\ Regular\ Nerd\ Font\ Complete.ttf ]; then
                printf "Hack Nerd Font already installed.\n"
            else
                printf "Installing Hack Regular Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # Sauce Code Pro Nerd Font
            if [ -f $HOME/.fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete.ttf ]; then
                printf "Sauce Code Pro Nerd Font already installed.\n"
            else
                printf "Installing Sauce Code Pro Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # Scan new fonts and build font information cache files
            fc-cache -fv $HOME/.fonts
            break
            ;;
        [Nn]* )
            printf "\nWill not install Nerd Fonts. Continuing...\n";
            break
            ;;
        * )
            printf "\nPlease provide a valid answer.\n"
            ;;
    esac
done

# cd $HOME

# ASK TO BACKUP FILES
while true; do
    printf "\nAre there dotfiles in your home directory that you want to backup?\n"
    read -p "Backup existing dotfiles in home directory? [Y/n]:" yn
    case $yn in
        [Yy]* )
            printf "\nStarting backup...\n"
            mkdir -p $HOME/Backup_Dotfiles # Create file backup directory
                if [ -f $HOME/.p10k.zsh ]; then # Move all related dotfiles (if they exist) to Backup_Dotfiles directory
                printf "Found .p10k.zsh, moving file to $HOME/Backup_Dotfiles...\n"
                mv $HOME/.p10k.zsh $HOME/Backup_Dotfiles
            fi
            if [ -f $HOME/.zprofile ]; then
                printf "Found .zprofile, moving file to $HOME/Backup_Dotfiles...\n"
                mv $HOME/.zprofile $HOME/Backup_Dotfiles
            fi
            if [ -f $HOME/.zshenv ]; then
                printf "Found .zshenv, moving file to $HOME/Backup_Dotfiles...\n"
                mv $HOME/.zshenv $HOME/Backup_Dotfiles/.zshenv-backup-$(date +"%Y-%m-%d")
            fi
            if [ -f $HOME/.zshrc ]; then
                printf "Found .zshrc, moving file to $HOME/Backup_Dotfiles...\n"
                mv $HOME/.zshrc* $HOME/Backup_Dotfiles
            fi
            printf "Finished backing up any existing files. Continuing..."
            break
            ;;
        [Nn]* )
            printf "\nWill continue without trying to backup existing files. Continuing...\n"
            break
            ;;
        * )
            printf "\nPlease provide a valid answer.\n"
            ;;
    esac
done



# COPY FILES FROM REPO
# the two .zsh files in omz-files need to go in .oh-my-zsh/custom/
cd $CLONED_REPO/omz-files
for i in *; do
    if [ -f $i ]; then
        if [ "$i" = "_better-help" ]; then
            [[ ! -d $INSTALL_DIRECTORY/.oh-my-zsh/completions ]] && mkdir -p $INSTALL_DIRECTORY/.oh-my-zsh/completions # in case completioons dir isn't there
            cp $i $INSTALL_DIRECTORY/.oh-my-zsh/completions
        else
            cp -f $i $INSTALL_DIRECTORY/.oh-my-zsh/custom
        fi
    elif [ -d $i ]; then # to copy nordvpn completions omz plugin (still hasnt been merged to OMZ stable branch yet but I found it on a test branch)
        cp -rf $i $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins
    fi
done

# directory for storing Powerlevel10K themes
if [ ! -d $INSTALL_DIRECTORY/P10K-themes ]; then
    mkdir -p $INSTALL_DIRECTORY/P10K-themes
fi

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
        if [ "$i" != ".gitignore" ]; then
            printf "\nCopying $i to $INSTALL_DIRECTORY\n"
            cp -f $i $INSTALL_DIRECTORY
        fi
    fi
done

printf "\nFinished setting up repo files in new $INSTALL_DIRECTORY directory.\n"
cd $HOME

while true; do
    printf "\nTo set the ZDOTDIR variable required to let Zsh know where to look for the .zsh files, we can either symlink the .zshenv file with the export ZDOTDIR line in it from your install directory, or we can export the variable in /etc/zsh/zshenv.\n"
    printf "If you'd prefer to set it some other way, choose option 3.\n"
    printf "\nHOW SHOULD ZDOTDIR BE SET?\n"
    printf "[1]     Create symbolic link to $INSTALL_DIRECTORY/.zshenv in $HOME directory\n"
    printf "[2]     Use /etc/zsh/zshenv file to set ZDOTDIR to $INSTALL_DIRECTORY (may require sudo priviledges)\n"
    printf "[3]     Do nothing; ZDOTDIR is already set, or I am going to set the ZDOTDIR variable myself.\n"
    printf ">>> "
    read -r choice
    case $choice in
        [1] )
            printf "\nCreated symbolic link:\n"
            ln -sv $INSTALL_DIRECTORY/.zshenv $HOME/.zshenv
            sleep 1
            break
            ;;
        [2] )
            echo -e "[[ -d $INSTALL_DIRECTORY && -f $INSTALL_DIRECTORY/.zshrc ]] && export ZDOTDIR=$INSTALL_DIRECTORY" | sudo tee -a /etc/zsh/zshenv > /dev/null
            printf "\n/etc/zsh/zshenv will now set the ZDOTDIR variable. Be sure to modify this file if you wish to change the location of your zsh dotfiles directory.\n"
            sleep 1
            break
            ;;
        [3] )
            printf "\nNothing will be done. Continuing on to final steps...\n"
            sleep 1
            break
            ;;
        * )
            printf "\nPlease enter a valid choice.\n"
            ;;
    esac
done

export ZDOTDIR=$INSTALL_DIRECTORY

# Change shell to zsh and run omz update
printf "\nSudo access is needed to change default shell\n"
if chsh -s $(which zsh); then
    if /bin/zsh -i -c 'omz update'; then
        printf "\nInstallation Successful, exit terminal and enter a new session\n"
    elif /bin/zsh -i -c upgrade_oh_my_zsh; then # in case omz update fails, will fallback to using upgrade_oh_my_zsh to finish install
        printf "\nInstallation Successful, exit terminal and enter a new session\n"
    else
        printf "\nSomething went wrong\n"
    fi
else
    printf "\nSomething went wrong\n"
fi

exit