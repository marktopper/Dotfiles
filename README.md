# dotfiles
For my linux dotfiles, you know how it is, you gotta have em up somewhere.

Finished with the install.sh script, now it downloads and installs Miniconda3 (all you have to do is go through, read the license and type yes, pretty easy)
The install.sh script will give a couple of errors (like couldn't overwrite root/. or root/..) which is because of a for loop I have that recursively symlinks anything beginning with . even . and .. apparently. Anyway seeing as how it doesn't harm anything anyway and just throws a couple errors I'm keeping it in there for now as everything is currently working just as intended.

Be sure to have wget before you try to run the install.sh script. Also shout out to jotyGill and their quicz-sh repo because copying and repurposing a lot of the code from their install.sh script helped me learn a lot about bash scripting and my install.sh wouldn't be working without it.
