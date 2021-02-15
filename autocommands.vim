" basic settings {{{
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" autocmd BufEnter * lua require'completion'.on_attach() 

" Only show cursorline in current window in insert mode
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave,VimEnter,BufEnter * set cursorline
augroup END

augroup latex
  au!
  autocmd FileType tex let b:coc_pairs = [["$", "$"]]
  autocmd BufNewFile,BufRead *.tikz set filetype=tex
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

augroup treesitter_fold
  au!
  au BufReadPost,FileReadPost,FileType * :call v:lua.myfun.treesitter_enable_fold()
augroup END

" hi Normal ctermbg=None
" end basic settings }}}
