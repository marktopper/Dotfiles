# Doc's Zsh Dotfiles

-   (plus an install script for setting up Zsh automatically)

<br>

## The install script in particular is designed for Debian based distributions with the apt package manager, and it is not guaranteed to work on other distributions.

<br>

## _If you don't wish to use my own powerlevel10k prompt theme, you have two options:_

-   Create your own powerlevel prompt file using the file name convention `.your_file_here.zsh`, then go into the `.zshrc` file and change `P10K_PROMPT="p10k"` to `P10K_PROMPT="your_file_here"` instead.
-   Continue using the default `.p10k.zsh` Powerlevel10k prompt config file and just reconfigure it using `p10k configure`

<br>

## I've tested the install.sh installer on Debian, Kali Linux, and Parrot OS.

-   **It _SHOULD_ work without issue on most distros.**

-   Be sure to **BACK UP YOUR FILES** for your shell's configuration **BEFORE running the script.**

<br>

---

<br>

## INSTALL REQUIREMENTS: zsh, git, wget (neofetch required if you want the startup prompt to work)

-   I recommend you also either install the packages `fzf` and `thefuck`, or you remove them from `.zshrc` so you don't get warning messages.

<br>

## I am not responsible for anything undesirable that happens as a result of you using any of the files in this repo.
