" lua plugins

if g:use_builtin_lsp
  execute LoadRelative('lua/code/completion.lua')
  execute LoadRelative('lua/code/lsp.lua')
else
  autocmd CursorHold * silent call CocActionAsync('highlight')
endif

if has('nvim')
  lua require'colorizer'.setup()
  execute LoadRelative('lua/code/treesitter.lua')
  execute LoadRelative('lua/telescope_extensions.lua')
endif

function! AirlineInit()
  call airline#parts#define_accent('coc_error_count', 'red')
  call airline#parts#define_accent('coc_warning_count', 'orange')
  let g:airline_section_warning = airline#section#create([])
  let g:airline_section_c = airline#section#create(['%{getcwd()}', '  ', 'coc_error_count', 'coc_warning_count'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

execute LoadRelative('settings/projects.vim')
