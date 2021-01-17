" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" basic settings {{{
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" autocmd BufEnter * lua require'completion'.on_attach() 


augroup default_folding
  au!
"   au FileType * setlocal foldmethod=expr
"   au FileType * setlocal foldexpr=nvim_treesitter#foldexpr()
  au BufRead * set foldexpr=nvim_treesitter#foldexpr()
augroup END

" Only show cursorline in current window in insert mode
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave,VimEnter,BufEnter * set cursorline
augroup END

augroup latex
  au!
  autocmd FileType tex let b:coc_pairs = [["$", "$"]]
augroup END
" augroup latex
"   au!
"   au FileType tex setlocal foldmethod=marker
" augroup END

augroup lua
  au!
  au FileType lua setlocal shiftwidth=2
augroup END

augroup fish
  au!
  au FileType fish compiler fish
  au FileType fish set foldmethod=expr
augroup END


" hi Normal ctermbg=None
" end basic settings }}}
