#!/bin/bash
# DO NOT EXECUTE THIS FILE OUTSIDE OF THE CLONED REPO AND BE SURE THE CLONED REPO IS IN YOUR $HOME DIRECTORY

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

if mv -n ~/.zshrc ~/.zshrc-backup-$(date +"%Y-%m-%d"); then # backup .zshrc
    echo -e "Backed up the current .zshrc to .zshrc-backup-date\n"
fi

# Create user's ~/.dotfiles directory
if [ -d ~/.dotfiles ]; then
    echo -e ".dotfiles directory already exists.\n"
else
    mkdir -p ~/.dotfiles
fi

# MINICONDA INSTALL
if [ -d ~/miniconda3 ]; then
    echo -e "Miniconda3 is already installed.\n"
else
    if [[ -e Miniconda3-latest-Linux-x86_64.sh ]]; then
        echo -e "Miniconda3 is not installed but already downloaded.\n"
        echo -e "Starting Miniconda3 setup...\n"
        bash ~/Miniconda3-latest-Linux-x86_64.sh
    else
        echo -e "Miniconda3 is not installed, downloading...\n"
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
        echo -e "Starting Miniconda3 setup...\n"
        bash ~/Miniconda3-latest-Linux-x86_64.sh
    fi
fi

if [[ -f ~/Miniconda3-latest-Linux-x86_64.sh && -d ~/miniconda3 ]]; then
    echo -e "Removing Miniconda3 install file...\n"
    rm ~/Miniconda3-latest-Linux-x86_64.sh
fi


# OMZ INSTALL
echo -e "Installing oh-my-zsh\n"
if [ -d ~/.oh-my-zsh ]; then
    echo -e "oh-my-zsh is already installed\n"
else
    git clone --depth=1 git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

if [ -f ~/.zshrc ]; then
    cp -f .zshrc ~/
fi


# INSTALL FONTS
echo -e "Installing Nerd Fonts version of Hack, Roboto Mono, DejaVu Sans Mono\n"

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

fc-cache -fv ~/.fonts


# OMZ PLUGINS INSTALL
if [ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ -d ~/.oh-my-zsh/custom/plugins/conda-zsh-completion ]; then
    cd ~/.oh-my-zsh/custom/plugins/conda-zsh-completion && git pull
else
    git clone --depth=1 https://github.com/esc/conda-zsh-completion ~/.oh-my-zsh/custom/plugins/conda-zsh-completion
fi

if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [ -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-completions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
fi

if [ -d ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
fi

# INSTALL POWERLEVEL10K THEME
if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
fi

cd $HOME

# copying files from repo to user's ~/.dotfiles directory
if [ -d ~/.bashrc ]; then
    echo -e ".bashrc already exists, making backup in current directory...\n"
    mv ~/.bashrc ~/.bashrc_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.bashrc ~/.dotfiles
else
    cp -f $CLONED_REPO_DIR/.bashrc ~/.dotfiles
fi

if [ -d ~/.conda_setup ]; then
    echo -e ".conda_setup already exists, making backup in current directory...\n"
    mv ~/.conda_setup ~/.conda_setup_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.conda_setup ~/.dotfiles
else
    cp -f $CLONED_REPO_DIR/.conda_setup ~/.dotfiles
fi

if [ -d ~/.p10k.zsh ]; then
    echo -e ".p10k.zsh already exists, making backup in current directory...\n"
    mv ~/.p10k.zsh ~/.p10k.zsh_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.p10k.zsh ~/.dotfiles
else
    cp -f $CLONED_REPO_DIR/.p10k.zsh ~/.dotfiles
fi

if [ -d ~/.profile ]; then
    echo -e ".profile already exists, making backup in current directory...\n"
    mv ~/.profile ~/.profile_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.profile ~/.dotfiles
else
    cp -f $CLONED_REPO_DIR/.profile ~/.dotfiles
fi

if [ -d ~/.zshrc ]; then
    echo -e ".zshrc already exists, making backup in directory...\n"
    mv ~/.zshrc ~/.zshrc_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.zshrc ~/.dotfiles
else
    cp -f $CLONED_REPO_DIR/.zshrc ~/.dotfiles
fi

if [ -d ~/.zshenv ]; then
    echo -e ".zshenv already exists, making backup in current directory...\n"
    mv ~/.zshenv ~/.zshenv_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.zshenv ~/.dotfiles
else
    cp -f $CLONED_REPO_DIR/.zshenv ~/.dotfiles
fi

if [ -d ~/.zsh_aliases ]; then
    echo -e ".zsh_aliases already exists, making backup in current directory...\n"
    mv ~/.zsh_aliases ~/.zsh_aliases_pre_dotfiles
    cp -f $CLONED_REPO_DIR/.zsh_aliases ~/.dotfiles
else
    cp -f $CLONED_REPO_DIR/.zsh_aliases ~/.dotfiles
fi

echo -e "Finished making backups and transferring repo files into new .dotfiles directory.\n"

# SYMLINK CREATION
echo -e "Now creating necessary symlinks...\n"
for FILE in ~/.dotfiles/.*; do
    if [[ -f $FILE ]]; then
        echo -e "Creating symlink for $FILE in home directory..."
        ln -srf $FILE ~/
    fi
done

# source ~/.zshrc
echo -e "\nSudo access is needed to change default shell\n"

if chsh -s $(which zsh) && /bin/zsh -i -c upgrade_oh_my_zsh; then
    echo -e "Installation Successful, exit terminal and enter a new session"
else
    echo -e "Something is wrong"
fi

exit