for i in ./.z*
do
 ln -srfv $i $HOME/
done

ln -srfv .p10k.zsh $HOME/
ln -srfv .bashrc $HOME/
ln -srfv .profile $HOME/
ln -srfv .vimrc $HOME/
