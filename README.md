# AutoBrackets
Vim plugin to autocomplete brackets

## Installation
To install the plugin, copy the file `autobrackets.vim` into your Vim
plugin folder. This folder is usually ~/.vim/plugin (on Linux).
Alternatively, run the `install.sh` script, which looks for this folder
and copies the file into it.

Call the function `AutoBracketsAdd({begin : end, ...})` for each type of
bracket, with `begin` and `end` or each entry in the dictionary the
beginning and ending strings for the brackets, in the `vimrc` file or in
a filetype plugin to tell AutoBrackets which types of brackets to
complete. Call the function `AutoBracketsRemove({begin : end, ...})` to
remove pairs already added.

