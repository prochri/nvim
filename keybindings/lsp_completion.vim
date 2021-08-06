
set pumheight=15

" completion
" tab and s-tab for snippet navigation set in pre_plugins
if g:use_builtin_lsp
  inoremap <silent><expr> <TAB>
          \ pumvisible() ? compe#confirm('<CR>') :
          \ vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" :
          \ "\<TAB>"
else
  inoremap <silent><expr> <TAB>
          \ pumvisible() ? coc#_select_confirm() :
          \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
          \ "\<TAB>"
end

imap <silent><expr> <C-l> <TAB>
imap <silent><expr> <C-h>
        \ pumvisible() ? g:use_builtin_lsp ? compe#close('<C-e>') :  coc#_cancel() :
        \ "\<s-tab>"

" select
inoremap <silent><expr> <C-j> pumvisible() ? "\<c-n>" : "\<c-j>"
inoremap <silent><expr> <C-k> pumvisible() ? "\<c-p>" : "\<c-k>"

inoremap <silent><expr> <c-space>  g:use_builtin_lsp ? compe#complete() : coc#refresh()

" lsp
" errors
if g:use_builtin_lsp

  nnoremap <silent> <leader>eN <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
  nnoremap <silent> <leader>en <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
  nnoremap <silent> <leader>el <cmd>lua require'telescope.builtin'.lsp_document_diagnostics()<cr>

  " code actions TODO
  nnoremap <silent> <leader>cr <cmd>lua require('lspsaga.rename').rename()<CR>
  " TODO
  nnoremap <leader>co <cmd>CocList symbols<cr>
  nnoremap <leader>cf <cmd>call CocAction('format')<cr>

  " nnoremap K
  nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
  nnoremap gd <cmd>lua vim.lsp.buf.definition()<cr>
  " nnoremap gr <cmd>lua <cr>
  nnoremap <silent> gr <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>


else
  nmap <leader>en <Plug>(coc-diagnostic-next)
  nmap <leader>eN <Plug>(coc-diagnostic-prev)
  nnoremap <leader>el <cmd>CocDiagnostic list<cr>

  " code actions TODO
  nnoremap <leader>cr <cmd>call CocActionAsync('rename')<cr>
  nnoremap <leader>co <cmd>CocList symbols<cr>
  nnoremap <leader>cf <cmd>call CocAction('format')<cr>

  " TODO
  " nnoremap K
  nnoremap gd <cmd>call CocActionAsync('jumpDefinition')<cr>
  nnoremap gr <cmd>call CocActionAsync('jumpReferences')<cr>
end
