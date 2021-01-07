for i in ./.z*
do
 ln -srfv $i $HOME/
done

ln -srfv .bashrc $HOME/
ln -srfv .dmrc $HOME/
ln -srfv .p10k.zsh $HOME/
ln -srfv .profile $HOME/
ln -srfv .themes $HOME/
ln -srfv .vim $HOME
ln -srfv .vimrc $HOME/
