
" only use this bindings for coc.nvim
if g:use_builtin_lsp
  " TODO load lua code here
  finish
endif

" completion
" tab and s-tab for snippet navigation set in pre_plugins
inoremap <silent><expr> <TAB>
        \ pumvisible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ "\<TAB>"

imap <silent><expr> <C-l> <TAB>
        " \ pumvisible() ? coc#_select_confirm() :
        " \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        " \ "\<c-l>"

imap <silent><expr> <C-h>
        \ pumvisible() ? coc#_cancel() :
        \ "\<s-tab>"

" select
inoremap <silent><expr> <C-j> pumvisible() ? "\<c-n>" : "\<c-j>"
inoremap <silent><expr> <C-k> pumvisible() ? "\<c-p>" : "\<c-k>"

inoremap <silent><expr> <c-space> coc#refresh()

" lsp
" errors
nmap <leader>en <Plug>(coc-diagnostic-next)
nmap <leader>eN <Plug>(coc-diagnostic-prev)
nnoremap <leader>el <cmd>CocDiagnostic list<cr>

" code actions TODO
nnoremap <leader>cr <Plug>call CocActionAsync('rename')<cr>

" TODO
" nnoremap K
nnoremap gd <cmd>call CocActionAsync('jumpDefinition')<cr>
nnoremap gr <cmd>call CocActionAsync('jumpReferences')<cr>

