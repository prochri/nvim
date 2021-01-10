" lua plugins

if g:use_builtin_lsp
  call LoadRelative('lua/code/completion.lua')
  call LoadRelative('lua/code/lsp.lua')
endif

if has('nvim')
  lua require'bufferline'.setup()
  lua require'colorizer'.setup()
  call LoadRelative('lua/statusline.lua')
  call LoadRelative('lua/code/treesitter.lua')
  call LoadRelative('lua/telescope_extensions.lua')
endif

call LoadRelative('settings/projects.vim')
