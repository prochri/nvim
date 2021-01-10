let g:use_builtin_lsp = 0
let g:use_builtin_lsp = has('nvim') ? g:use_builtin_lsp : 0

let s:vim_config_root = expand('<sfile>:p:h')

function! LoadRelative(relpath, ...) abort
  " specified file path?
  let l:abspath = s:vim_config_root . '/' . a:relpath
  let l:filetype = a:0 ? a:1 : a:relpath[-3:]
  if l:filetype ==# 'vim'
    execute 'source ' . l:abspath
  elseif l:filetype ==# 'lua'
    execute 'luafile ' . l:abspath
  else
    echoerr 'filetype not found: ' . l:filetype
  endif
endfunction


" let g:vim_config_root = expand('<sfile>:p:h')
" settings
call LoadRelative('settings/default.vim')
" keybindings
call LoadRelative('keybindings/default.vim')
call LoadRelative('keybindings/leader.vim')
call LoadRelative('keybindings/lsp_completion.vim')

" plugin settings
call LoadRelative('settings/pre_plugins.vim')
call LoadRelative('plugins.vim')
call LoadRelative('settings/post_plugins.vim')


" personal usages
if has('nvim')
  lua require'util_functions'
endif

call LoadRelative('vimscripts/lister.vim')
call LoadRelative('settings/theme.vim')
call LoadRelative('autocommands.vim')

