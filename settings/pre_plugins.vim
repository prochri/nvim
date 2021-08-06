" prosession
let g:prosession_on_startup = 0
let g:prosession_dir = '~/.cache/vim/session/'

" vimtex syntax folding
let g:vimtex_fold_enabled = 1

" coc.nvim
if !g:use_builtin_lsp
  let g:coc_global_extensions = 
    \ [ 'coc-snippets', 'coc-lists', 'coc-pairs', 
    \ 'coc-marketplace', 'coc-prettier', 'coc-floaterm', 
    \ 'coc-vimlsp', 'coc-lua', 'coc-tsserver', 'coc-json', 'coc-explorer',
    \ 'coc-clangd',
    \ 'coc-texlab', 'coc-bibtex', 'coc-vimtex'
    \]
  let g:coc_snippet_next = '<tab>'
  let g:coc_snippet_prev = '<s-tab>'
  
  set completeopt=menuone,noinsert
  set updatetime=200

  let g:airline#extensions#coc#error_symbol = ' '
  let g:airline#extensions#coc#warning_symbol = ' '
  let g:airline#extensions#coc#enabled = 1
endif

" terminal
let g:floaterm_autoclose = 1
let g:floaterm_winblend = 10

" hardtime
let g:hardtime_maxcount = 2
let g:hardtime_ignore_quickfix = 1
let g:hardtime_default_on = 0

tnoremap <silent><M-esc> <c-\><c-n>:FloatermHide<cr>

