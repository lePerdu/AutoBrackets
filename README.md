# AutoBrackets
Vim plugin to autocomplete brackets

## Installation
To install the plugin, copy the file `autobrackets.vim` into your Vim plugin folder.
This folder is usually ~/.vim/plugin (on Linux).

Call the function `AutoBracketsAdd(begin, end)` for each type of bracket, with `begin` and `end` the beginning and ending strings for the brackets, in the `vimrc` file or in a filetype plugin to tell AutoBrackets which types of brackets to complete.
Call the function `AutoBracketsAddIndent(begin, end)` instead if the bracket should be indented if Enter is pressed following the opening string.
