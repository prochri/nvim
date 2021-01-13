let g:use_builtin_lsp = 0
let g:use_builtin_lsp = has('nvim') ? g:use_builtin_lsp : 0

let s:vim_config_root = expand('<sfile>:p:h')

function! LoadRelative(relpath, ...) abort
  " specified file path?
  let l:abspath = s:vim_config_root . '/' . a:relpath
  let l:filetype = a:0 ? a:1 : a:relpath[-3:]
  if l:filetype ==# 'vim'
    return 'source ' . l:abspath
  elseif l:filetype ==# 'lua'
    return 'luafile ' . l:abspath
  else
    echoerr 'filetype not found: ' . l:filetype
  endif
endfunction


" let g:vim_config_root = expand('<sfile>:p:h')
" settings
execute LoadRelative('settings/default.vim')
" keybindings
execute LoadRelative('keybindings/default.vim')
execute LoadRelative('keybindings/leader.vim')
execute LoadRelative('keybindings/lsp_completion.vim')

" plugin settings
execute LoadRelative('settings/pre_plugins.vim')
execute LoadRelative('plugins.vim')
execute LoadRelative('settings/post_plugins.vim')


" personal usages
if has('nvim')
  lua require'util_functions'
endif

execute LoadRelative('vimscripts/lister.vim')
execute LoadRelative('settings/theme.vim')
execute LoadRelative('autocommands.vim')

