" Vim plugin to auto-complete brackets.
" Maintainer: Zach Petlzer

if exists('g:loaded_autobrackets')
    finish
endif

let g:loaded_autobrackets = 1

" Each entry contains a string of length at least 2.
" The first character is the opening character,
" the second is the closing character,
" the (optional) third is an escape character
let s:autobracket_types = []

function! s:AutoBracketsClose()
    let action = 0
    for type in s:autobracket_types
        if v:char == type[1]
            let action = 1
            break
        endif
    endfor

    if !action
        return
    endif

    let lnum = line('.')
    let cnum = col('.')
    let text = getline(lnum)

    if text[cnum-1] == v:char
        let v:char = ''
        call cursor(lnum, cnum+1)
    endif
endfunction

" Sets up AutoBrackets to automatically complete specified types of brackets.
" @param begin - String to start the brackets
" @param end - String to end the brackets
function! AutoBracketsAdd(begin, end)
    execute 'inoremap' a:begin a:begin.a:end.'<Left>' 
    execute 'inoremap' a:begin.'<BS>' '<Nop>'

    call add(s:autobracket_types, a:begin . a:end)
endfunction

" Sets up AutoBrackets to automatically complete specified types of brackets
" and also indent the brackets if <Enter> is pressed following the openning
" bracket.
" @param begin - String to start the brackets
" @param end - String to end the brackets
function! AutoBracketsAddIndent(begin, end)
    call AutoBracketsAdd(a:begin, a:end)
    execute 'inoremap' a:begin.'<CR>' a:begin.'<CR>'.a:end.'<Esc>O'
endfunction

" Removes an entry from the types of brackets which AutoBrackets completes
" @param begin - String to start the brackets
" @param end - String to end the brackets
function! AutoBracketsRemove(begin, end)
    let index = -1
    for i in len(s:autobracket_types)
        let type = s:autobracket_types[i]
        if a:begin == type[0] && a:end == type[1]
            let index = i
            break
        endif
    endfor

    if index < 0
        return
    endif

    execute 'iunmap' a:begin
    execute 'iunmap' a:begin.'<BS>'
    execute 'iunmap' a:begin.'<CR>'
    call remove(s:autobracket_types, index)
endfunction

augroup autobrackets
    autocmd! InsertCharPre * call s:AutoBracketsClose()
augroup END

