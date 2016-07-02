" Vim plugin to auto-complete brackets.
" Maintainer: Zach Petlzer

if exists('g:loaded_autobrackets')
    finish
endif

let g:loaded_autobrackets = 1

" Sets up AutoBrackets to automatically complete specified types of brackets.
" @param begin - String to start the brackets
" @param end - String to end the brackets
function! AutoBracketsAdd(begin, end)
    execute 'inoremap' a:begin a:begin.a:end.'<Left>' 
    execute 'inoremap' a:begin.'<BS>' '<Nop>'
	execute 'inoremap' a:begin.'\' a:begin

	let end_esc = a:end == '"' ? '\'.a:end : a:end

	if a:begin !=# a:end
		execute 'inoremap <expr>' a:end 'strpart(getline("."), col(".")-1, 1) == "'.end_esc.'" ? "<Right>" : "'.end_esc.'"'
	else
		execute 'inoremap <expr>' a:end 'strpart(getline("."), col(".")-1, 1) == "'.end_esc.'" ? "<Right>" : "'.end_esc.end_esc.'<Left>"'
	endif

	execute 'vnoremap' '\'.a:begin '<Esc>`>'.v:count1.'a'.a:end.'<Esc>`<'.v:count1.'i'.a:begin.'<Esc>``l'
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

