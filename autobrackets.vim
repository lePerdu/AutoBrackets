" Vim plugin for autocompleting brackets
"

if exists('g:loaded_autobrackets')
    finish
endif

let g:loaded_autobrackets = 1

" Initializes AutoBrackets
" The following behaviour is setup:
"   Typing the starting character in insert mode places both brackets and puts
"   the cursor between them.
"   Typing the starting character followed by <BS> does not insert anything,
"   as it does without the plugin 
"   Typing the starting character followed by '\' does not insert the ending
"   character.
"   Typing the ending character moves the cursor to the right if the
"   character after the cursor is that character, otherwise, it inserts the
"   character.
"   In visual mode, typing '\' and the starting character surrounds the
"   selected region with the brackets.
" @param types - A List containing entries of bracket types to complete.
"                Entries are Strings, with the first index as the
"                starting character for the brackets and the second as the
"                ending character for the brackets.
function! AutoBracketsInit(types)
    for type in a:types
        let o = type[0]
        let c = type[1]

        " Escaped (if needed) the closing character.
        let c_esc = c == '"' ? '\'.c : c

        " Complete brackets in insert mode
        execute 'inoremap' o.c o.c
        execute 'inoremap' o.'\' o
        execute 'inoremap' o.'<BS>' '<Nop>'
        if o !=# c
            execute 'inoremap' o o.c.'<Left>'
            execute 'inoremap <expr>' c 'strpart(getline("."), col(".")-1, 1) == "'.c_esc.'" ? "<Right>" : "'.c_esc.'"'
        else
            execute 'inoremap <expr>' o 'strpart(getline("."), col(".")-1, 1) == "'.c_esc.'" ? "<Right>" : "'.c_esc.c_esc.'<Left>"'
        endif

        " Surround visual selection with brackets
        execute 'vnoremap' '\'.o '<Esc>`>'.v:count.'a'.c.'<Esc>`<'.v:count.'i'.o.'<Esc>'
    endfor
endfunction

