# Miniature installer for the plugin

if [ -d ~/.vim/plugin/ ]; then
    cp ./autobrackets.vim ~/.vim/plugin/
elif [ -d ~/.nvim/plugin/ ]; then
    cp ./autobrackets.vim ~/.nvim/plugin/
elif [ -d ~/.config/nvim/plugin/ ]; then
    cp ./autobrackets.vim ~/.config/nvim/plugin/
else
    echo 'Could not find folder to install to'
fi

