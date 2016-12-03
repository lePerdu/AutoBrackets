# Miniature installer for the plugin

if [ -d ~/.vim/plugin/ ]; then
    DIR=~/.vim/plugin/
elif [ -d ~/.nvim/plugin/ ]; then
    DIR=~/.nvim/plugin/
elif [ -d ~/.config/nvim/plugin/ ]; then
    DIR=~/.config/nvim/plugin/
else
    echo "Could not find folder into which to install"
    exit
fi

cp ./autobrackets.vim $DIR

