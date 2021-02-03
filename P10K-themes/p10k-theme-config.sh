# This file handles P10K themes if $P10K_THEME is set in .zshrc
# To use a certain p10k theme, set $P10K_THEME to name of theme in .zshrc
# To install a new theme, create a file and save it as `THEME_NAME`.zsh in P10K-themes

if [ -f "$ZDOTDIR/P10K-themes/$P10K_THEME.zsh" ]; then
    source "$ZDOTDIR/P10K-themes/$P10K_THEME.zsh"
  else
    echo "$P10K_THEME not found. Using .p10k.zsh instead.\n"
    if [ -f $ZDOTDIR/.p10k.zsh ]; then
      source $ZDOTDIR/.p10k.zsh
    else # notify user and run p10k configure to generate .p10k.zsh file.
      echo ".p10k.zsh NOT FOUND."
      echo "Running p10k configure to generate one...\n"
      sleep 1
      touch $ZDOTDIR/.p10k.zsh && p10k configure
    fi
fi