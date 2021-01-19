#!/bin/bash

if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget &> /dev/null; then
    echo -e "ZSH and Git are already installed\n"
else
    if sudo apt install -y zsh git wget || sudo pacman -S zsh git wget || sudo dnf install -y zsh git wget || sudo yum install -y zsh git wget || sudo brew install git zsh wget || pkg install git zsh wget ; then
        echo -e "zsh wget and git Installed\n"
    else
        echo -e "Please install the following packages first, then try again: zsh git wget \n" && exit
    fi
fi

CLONED_REPO_DIR=$(pwd)

if [ -d $CLONED_REPO_DIR ]; then
    echo -e "Moving to parent directory...\n"
    cd ..
    echo -e "We are in $PWD"
    # check if cloned repo is located in $HOME directory
    if [ -d $HOME ]; then
        echo -e "Repo appears to be located in users home directory, continuing...\n"
    else
        echo -e "REPO IS NOT IN YOUR HOME DIRECTORY\nPLEASE MOVE REPO TO $HOME BEFORE RUNNING THE INSTALL SCRIPT!\n"
        echo -e "Use:\nmv -drf $CLONED_REPO_DIR $HOME\nTo move the git repo directory to your home directory, then try running this again." && exit
    fi
else
    echo -e "Something went wrong, stopping...\n"
    exit
fi

if [ -f ~/.zshrc ]; then # backup .zshrc
    mv ~/.zshrc ~/.zshrc-backup-$(date +"%Y-%m-%d")
    echo -e "Backed up current .zshrc to .zshrc-backup-$(date +"%Y-%m-%d")\n"
fi

# Create user's ~/.config/zsh directory
if [ -d ~/.config/zsh ]; then
    echo -e "~/.config/zsh directory already exists.\n"
else
    mkdir -p ~/.config/zsh
fi

Z_DOT_DIR=~/.config/zsh

# HOMEBREW/LINUXBREW INSTALL
if [ -d /home/linuxbrew ]; then
    echo -e "Homebrew is already installed.\n"
else
    echo -e "Homebrew not installed.\n" 
    while true; do
        read -p "Do you want to install Homebrew? [Y/n]:" yn
        case $yn in
            [Yy]* )
                echo -e "Answer: Yes.\nInstalling Homebrew...";
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
                break;;
            [Nn]* )
                echo -e "Answer: No.\nContinuing...";
                break;;
            * )
                echo -e "Please provide a valid answer.";;
        esac
    done
fi

# MINICONDA INSTALL
if [ -d ~/miniconda3 ]; then
    echo -e "Miniconda3 is already installed.\n"
    cp -f $CLONED_REPO_DIR/.conda_setup $Z_DOT_DIR;
else
    echo -e "Miniconda3 is not installed.\n"
    while true; do
        read -p "Do you want to install Miniconda? [Y/n]:" yn
        case $yn in
            [Yy]* )
                echo -e "Answer: Yes.";
                cp -f $CLONED_REPO_DIR/.conda_setup $Z_DOT_DIR; # copy .conda_setup file to Zsh dotfiles directory
                if [ -f ~/Miniconda3-latest-Linux-x86_64.sh ]; then # to prevent downloading Miniconda3 setup file multiple times
                    echo -e "Miniconda3 is already downloaded\nStarting Miniconda3 setup..."
                    bash ~/Miniconda3-latest-Linux-x86_64.sh
                else
                    echo -e "Downloading Miniconda3..."
                    wget -q --show-progress https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P ~/
                    echo -e "Download finished.\nStarting Miniconda3 setup..."
                    bash ~/Miniconda3-latest-Linux-x86_64.sh
                fi;
                break;;
            [Nn]* )
                echo -e "Answer: No.\nContinuing...";
                break;;
            * )
                echo -e "Please provide a valid answer.";;
        esac
    done
fi

[[ -f ~/Miniconda3-latest-Linux-x86_64.sh && -d ~/miniconda3 ]] && echo -e "\nRemoving Miniconda3 install file..." && rm -f ~/Miniconda3-latest-Linux-x86_64.sh

# OMZ INSTALL
echo -e "Installing oh-my-zsh\n"
if [ -d ~/.oh-my-zsh ]; then
    echo -e "oh-my-zsh is already installed in home directory, moving to new ~/.config/zsh directory...\n"
    mv ~/.oh-my-zsh $Z_DOT_DIR
    cd $Z_DOT_DIR/.oh-my-zsh && git pull
else
    if [ -d $Z_DOT_DIR/.oh-my-zsh ]; then
        echo -e "oh-my-zsh is already installed in $Z_DOT_DIR.\n"
        cd $Z_DOT_DIR/.oh-my-zsh && git pull
    else
        echo -e "oh-my-zsh is not installed in $Z_DOT_DIR. Installing...\n"
        git clone --depth=1 git://github.com/robbyrussell/oh-my-zsh.git $Z_DOT_DIR/.oh-my-zsh
    fi
fi

# INSTALL FONTS
echo -e "Installing Nerd Fonts version of Hack, Roboto Mono, DejaVu Sans Mono, Source Code Pro\n"

if [ -f ~/.fonts/DejaVu\ Sans\ Mono\ Nerd\ Font\ Complete.ttf ]; then
    echo -e "DejaVu Sans Mono Nerd Font already installed.\n"
else
    echo -e "Installing Nerd Fonts version of DejaVu Sans Mono\n"
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
fi

if [ -f ~/.fonts/Roboto\ Mono\ Nerd\ Font\ Complete.ttf ]; then
    echo -e "Roboto Mono Nerd Font already installed.\n"
else
    echo -e "Installing Nerd Fonts version of Roboto Mono\n"
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
fi

if [ -f ~/.fonts/Hack\ Regular\ Nerd\ Font\ Complete.ttf ]; then
    echo -e "Hack Nerd Font already installed.\n"
else
    echo -e "Installing Nerd Fonts version of Hack\n"
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
fi

if [ -f ~/.fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete.ttf ]; then
    echo -e "Sauce Code Pro Nerd Font already installed.\n"
else
    echo -e "Installing Nerd Fonts version of Source Code Pro\n"
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
fi

fc-cache -fv ~/.fonts

# OMZ PLUGINS INSTALL
if [ -d $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    cd $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ -d $Z_DOT_DIR/.oh-my-zsh/custom/plugins/conda-zsh-completion ]; then
    cd $Z_DOT_DIR/.oh-my-zsh/custom/plugins/conda-zsh-completion && git pull
else
    git clone --depth=1 https://github.com/esc/conda-zsh-completion $Z_DOT_DIR/.oh-my-zsh/custom/plugins/conda-zsh-completion
fi

if [ -d $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    cd $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [ -d $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-completions ]; then
    cd $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-completions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-completions $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-completions
fi

if [ -d $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
    cd $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search $Z_DOT_DIR/.oh-my-zsh/custom/plugins/zsh-history-substring-search
fi

# INSTALL POWERLEVEL10K THEME
if [ -d $Z_DOT_DIR/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    cd $Z_DOT_DIR/.oh-my-zsh/custom/themes/powerlevel10k && git pull
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $Z_DOT_DIR/.oh-my-zsh/custom/themes/powerlevel10k
fi

cd $HOME

# files going into ZSH directory
if [ -f ~/.p10k.zsh ]; then
    echo -e ".p10k.zsh already exists, making backup in current directory...\n"
    mv ~/.p10k.zsh ~/.p10k.zsh_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.p10k.zsh $Z_DOT_DIR
else
    cp -f $CLONED_REPO_DIR/.p10k.zsh $Z_DOT_DIR
fi

if [ -f ~/.zprofile ]; then
    echo -e ".zprofile already exists, making backup in current directory...\n"
    mv ~/.zprofile ~/.zprofile_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.zprofile $Z_DOT_DIR
else
    cp -f $CLONED_REPO_DIR/.zprofile $Z_DOT_DIR
fi

if [ -f ~/.zshrc ]; then
    echo -e ".zshrc already exists, making backup in current directory...\n"
    mv ~/.zshrc ~/.zshrc_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.zshrc $Z_DOT_DIR
else
    cp -f $CLONED_REPO_DIR/.zshrc $Z_DOT_DIR
fi

if [ -f ~/.zshenv ]; then
    echo -e ".zshenv already exists, making backup in current directory...\n"
    mv ~/.zshenv ~/.zshenv_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.zshenv $Z_DOT_DIR
else
    cp -f $CLONED_REPO_DIR/.zshenv $Z_DOT_DIR
fi

if [ -f ~/.zsh_aliases ]; then
    echo -e ".zsh_aliases already exists, making backup in current directory...\n"
    mv ~/.zsh_aliases ~/.zsh_aliases_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.zsh_aliases $Z_DOT_DIR
else
    cp -f $CLONED_REPO_DIR/.zsh_aliases $Z_DOT_DIR
fi

echo -e "Finished transferring repo files into new .config/zsh directory.\n"

# set $ZDOTDIR environment variable inside /etc/zsh/zshenv system-wide zshenv file
echo -e "\nSudo access is needed to set ZDOTDIR in /etc/zsh/zshenv\n"
if [ -n $ZDOTDIR ]; then
    echo -e "ZDOTDIR variable is already set."
else
    [[ -f /etc/zsh/zshenv ]] && echo 'export ZDOTDIR=~/.config/zsh' | sudo tee -a /etc/zsh/zshenv > /dev/null
fi

# source ~/.zshrc
echo -e "\nSudo access is needed to change default shell\n"

if chsh -s $(which zsh) && /bin/zsh -i -c upgrade_oh_my_zsh; then
    echo -e "Installation Successful, exit terminal and enter a new session"
else
    echo -e "Something is wrong"
fi

exit