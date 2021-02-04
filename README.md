# Dotfiles personalized for Parrot OS
My Parrot Linux Zsh dotfiles (plus an install script for automatically setting them up)

Keep in mind I've tried keeping everything POSIX compliant, but as much as I'd like this dotfiles install to be able to be run on any system, I don't yet know enough about this sort of thing, and so I have to warn anyone not using Parrot OS that you may encounter issues.

# INSTALL REQUIREMENTS: zsh, git, neofetch, wget (or something similar)
I'd also recommend installing autojump, fzf, and thefuck, as the OMZ plugins for them are in the repo zshrc file.
If you don't intend to use any of these, I recommend going into .zshrc and removing them from the plugins portion of the file so you don't see OMZ complaining about them not being installed. 

# NEW FUNCTIONALITIES

# Choose a particular powerlevel10k prompt config file
You see a custom prompt file that someone else has set up for P10K and you decide you'd like to use it.
Normally, you'd have to go into .zshrc, after knowing where this P10K file is located, and source it.
Well, I didn't really like having to do that every time, so I added a short file within P10K-themes/ called p10k-theme-config.sh to handle sourcing a custom prompt theme, or sourcing good ole .p10k.zsh if the custom prompt theme cannot be found for sourcing.
Instead of typing source and all that, simply set the P10K_THEME variable in your .zshrc file to the name of a custom p10k .zsh theme file you've placed within P10K-themes. 
# Be sure to add .zsh to the end of whatever p10k theme files you wanna use, otherwise there will likely be problems.
Example: To use my prompt theme (now rennamed docstheme.zsh, located in the P10K-themes directory) you simply add to .zshrc: P10K_THEME="docstheme"
In .zshrc the lines at the very bottom (of the .zshrc file included in this repo anyway) are for providing this functionality, so bear that in mind.


# The help command is useful again when run without any arguments
Now, like with bash, it will display information about useful command aliases and other useful information.
I will likely add more information for it to display in the future, but for now at least it isn't just saying "no help topic available for this" (or whatever it says when run without arguments)

# Automatically call a command to commit all changes, then prompt for a commit message and finally automatically push the commit to github.
The command is commit-push, only use it if you're sure all of the changes you've made are good to commit and push, as there's no going back after entering the commit message.

# I added some other functions and things of that nature but I'll get to listing them here at a later time.
