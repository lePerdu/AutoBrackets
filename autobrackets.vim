" Vim plugin for autocompleting brackets
" Maintainer: Zach Peltzer
"

if exists('g:loaded_autobrackets')
    finish
endif

let g:loaded_autobrackets = 1

" Action for the backspace (<BS>) key.
" In the situation:
"   (|), for any initialized bracket types
" the result will be
"   |
"
" Otherwise, the result will be the normal one for <BS>
function! AutoBracketsBackSpace()
    let text = getline('.')
    let cnum = col('.')

    for [o, c] in items(b:autobrackets_pairs)
        if strpart(text, cnum-len(o)-1, len(o)) == o &&
                    \ strpart(text, cnum-1, len(c)) == c
            return repeat("\<BS>", len(o)) . repeat("\<Del>", len(c))
        endif
    endfor

    return "\<BS>"
endfunction

" Surrounds the currently selected text with the specified
" opening/closing brackets.
function! AutoBracketsSurround(o, c, n) range
    let lnum = line("'>")
    let cnum = col("'>")
    let text = getline(lnum)
    call setline(lnum, strpart(text, 0, cnum) . repeat(a:c, a:n) .
                \ strpart(text, cnum))

    let lnum = line("'<")
    let cnum = col("'<")
    let text = getline(lnum)
    call setline(lnum, strpart(text, 0, cnum-1) . repeat(a:o, a:n) .
                \ strpart(text, cnum-1))
endfunction

" Creates mappings to autocomplete the specified bracket pairs.
" Mappings are created for the following situations, with the bracket
" pairs '(' and ')' ('|' is the cursor position):
"   start       typed       end
"   |           ()          ()|
"   |           (\          (|
"   |           (\\         (\|)
"   (|          <BS>        |
"   |           (           (|)
"   |)          )           )|
"   (|)         <BS>        |
"
" Also, the visual-mode mapping is created to wrap selected text
" in brackets:
"   start       typed       end
"   text        \(          ((text))
function! AutoBracketsAdd(pairs)
    if !exists('b:autobrackets_pairs')
        let b:autobrackets_pairs = {}
    endif

    if len(a:pairs) != 0
        inoremap <buffer> <expr> <BS> AutoBracketsBackSpace()
        call extend(b:autobrackets_pairs, a:pairs)
    endif

    for [o, c] in items(a:pairs)
        " Escaped (if needed) the closing character.
        let o_esc = o == '"' ? '\'.o : o
        let c_esc = c == '"' ? '\'.c : c

        " Complete brackets in insert mode
        execute 'inoremap <buffer>' o.c o.c
        execute 'inoremap <buffer>' o.'\' o
        execute 'inoremap <buffer>' o.'\\'
                    \ o.'\'.c.repeat('<Left>', len(c))
        execute 'inoremap <buffer>' o.'<BS>' '<Nop>'
        if o !=# c
            execute 'inoremap <buffer>' o o.c.repeat('<Left>', len(c))

            " inoremap <buffer> <expr> ) <Right> ; if following (
            " inoremap <buffer> <expr> ) ) ; if not following (
            execute 'inoremap <buffer> <expr>' c
                        \ 'strpart(getline("."),col(".")-1,' .
                        \ len(c) . ') == "' . c_esc . '" ? "' .
                        \ repeat('<Right>', len(c)) . '" : "' .
                        \ c_esc . '"'
        else
            " inoremap <buffer> <expr> ' <Right> ; if following '
            " inoremap <buffer> <expr> ' '' ; if not following '
            execute 'inoremap <buffer> <expr>' c
                        \ 'strpart(getline("."),col(".")-1,' .
                        \ len(c) . ') == "' . c_esc . '" ? "' .
                        \ repeat('<Right>', len(c)) . '" : "' .
                        \ c_esc.c_esc .
                        \ repeat('<Left>', len(c)) . '"'
        endif

        " Surround visual selection with brackets
        execute 'vnoremap <buffer> <silent>' '\'.o
                    \ ':<C-U>call AutoBracketsSurround("' .
                    \ o_esc.'","'.c_esc.'", v:count1)<CR>'
    endfor
endfunction

" Removes all mappings created by AutoBracketsAdd() for the specified
" pairs.
function! AutoBracketsRemove(pairs)
    for [o, c] in items(a:pairs)
        if has_key(b:autobrackets_pairs, o) &&
                    \ b:autobrackets_pairs[o] == c
            exec 'iunmap <buffer>' o
            exec 'iunmap <buffer>' c
            exec 'iunmap <buffer>' o.'\'
            exec 'iunmap <buffer>' o.'\\'
            exec 'iunmap <buffer>' o.'<BS>'
            exec 'vunmap <buffer>' '\'.o

            unlet b:autobrackes_pairs[o]
        endif
    endfor

    if len(b:autobrackets_pairs) == 0
        iunmap <buffer> <BS>
    endif
endfunction

