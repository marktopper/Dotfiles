# This file handles P10K themes if $P10K_THEME is set in .zshrc
# To use a certain p10k theme, set $P10K_THEME to name of theme in .zshrc
# To install a new theme, create a file and save it as `THEME_NAME`.zsh in P10K-themes

if [ -f "$ZDOTDIR/P10K-themes/$P10K_THEME.zsh" ]; then
    source "$ZDOTDIR/P10K-themes/$P10K_THEME.zsh"
  else
    echo "$P10K_THEME not found. Using .p10k.zsh instead.\n"
    source $ZDOTDIR/.p10k.zsh
fi
