" lua plugins

if g:use_builtin_lsp
  execute LoadRelative('lua/code/completion.lua')
  execute LoadRelative('lua/code/lsp.lua')
else
  autocmd CursorHold * silent call CocActionAsync('highlight')
endif

if has('nvim')
  lua require'bufferline'.setup()
  lua require'colorizer'.setup()
  execute LoadRelative('lua/statusline.lua')
  execute LoadRelative('lua/code/treesitter.lua')
  execute LoadRelative('lua/telescope_extensions.lua')
endif


execute LoadRelative('settings/projects.vim')
