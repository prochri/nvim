" prosession
let g:prosession_on_startup = 0
let g:prosession_dir = '~/.cache/vim/session/'

" coc.nvim
if !g:use_builtin_lsp
  let g:coc_global_extensions = 
    \ [ 'coc-snippets', 'coc-lists', 'coc-pairs', 
    \ 'coc-marketplace', 'coc-prettier', 'coc-floaterm', 
    \ 'coc-vimlsp', 'coc-lua', 'coc-tsserver', 'coc-json', 'coc-explorer',
    \ 'coc-texlab', 'coc-bibtex', 'coc-vimtex'
    \]
  let g:coc_snippet_next = '<tab>'
  let g:coc_snippet_prev = '<s-tab>'
  
  set completeopt=menuone,noinsert
  set updatetime=200
endif

" terminal
let g:floaterm_autoclose = 1
let g:floaterm_winblend = 10
tnoremap <silent><esc> <c-\><c-n>:FloatermHide<cr>

