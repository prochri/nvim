vim.o.completeopt = 'menuone,noinsert,noselect'
-- vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.updatetime = 100

require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'always',
  throttle_time = 80,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true
  }
}

vim.g.completion_enable_snippet = 'vim-vsnip'
vim.g.vsnip_snippet_dir = os.getenv('HOME') .. '/.config/Code/User/snippets/'
vim.g.vsnip_snippet_dirs = {os.getenv('HOME') .. '/.config/Code/User/snippets/'}
vim.g.vnsip_filetypes = {}
vim.g.vnsip_filetypes.latex = {'tex'}
vim.g.vnsip_filetypes.tex = {'latex'}

-- -- completion sources
-- completion.addCompletionSource('vimtex', {item = function(prefix) return vim.api.nvim_call_function('vimtex#complete#omnifunc', {0,prefix}) end})

-- vim.g.completion_chain_complete_list = {
--   default = {
--     {complete_items = {'lsp', 'snippet'}},
--     -- {complete_items = {'path'}, triggered_only = {'/'}},
--     {complete_items = {'buffer'}}
--   },
--   tex = {
--     {complete_items = {'lsp', 'vimtex', 'snippet'}},
--     -- {complete_items = {'path'}, triggered_only = {'/'}},
--     {complete_items = {'buffer'}}
--   }
-- }

-- -- enable completion everywhere
-- vim.cmd [[autocmd BufEnter * lua require'completion'.on_attach()]]

-- -- _G.myfun = {}
-- -- function _G.myfun.is_prev_columnd_free()
-- --   local col = vim.fn.col('.') - 1
-- --   return col == 0 or string.char(string.byte(vim.fn.getline('.'), col)) == ' '
-- -- end
