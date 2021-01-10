local completion = require 'completion'
vim.cmd [[packadd completion-buffers]]

vim.o.completeopt = 'menuone,noinsert'
-- vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.updatetime = 100

vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
-- vim.g.completion_confirm_key = ''
vim.g.completion_auto_change_source = 1 -- really neede? yes!
-- vim.g.completion_enable_auto_paren = 1

vim.g.completion_enable_snippet = 'vim-vsnip'
vim.g.vsnip_snippet_dir = os.getenv('HOME') .. '/.config/Code/User/snippets/'
vim.g.vsnip_snippet_dirs = {os.getenv('HOME') .. '/.config/Code/User/snippets/'}
vim.g.vnsip_filetypes = {}
vim.g.vnsip_filetypes.latex = {'tex'}
vim.g.vnsip_filetypes.tex = {'latex'}

-- completion sources
completion.addCompletionSource('vimtex', {item = function(prefix) return vim.api.nvim_call_function('vimtex#complete#omnifunc', {0,prefix}) end})

vim.g.completion_chain_complete_list = {
  default = {
    {complete_items = {'lsp', 'snippet'}},
    -- {complete_items = {'path'}, triggered_only = {'/'}},
    {complete_items = {'buffer'}}
  },
  tex = {
    {complete_items = {'lsp', 'vimtex', 'snippet'}},
    -- {complete_items = {'path'}, triggered_only = {'/'}},
    {complete_items = {'buffer'}}
  }
}

-- enable completion everywhere
vim.cmd [[autocmd BufEnter * lua require'completion'.on_attach()]]

-- _G.myfun = {}
-- function _G.myfun.is_prev_columnd_free()
--   local col = vim.fn.col('.') - 1
--   return col == 0 or string.char(string.byte(vim.fn.getline('.'), col)) == ' '
-- end

vim.api.nvim_set_keymap(
  'i', '<TAB>',
    [[pumvisible() ? "\<CR>": vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : "\<TAB>"]],
    {expr = true})
vim.api.nvim_set_keymap(
  'i', '<s-TAB>',
    [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : "\<s-TAB>"]],
    {expr = true})

vim.api.nvim_set_keymap(
  'i', '<A-k>', [[pumvisible() ? "\<C-p>" : "\<A-k>"]],
    {expr = true, noremap = true, silent = true})
vim.api.nvim_set_keymap(
  'i', '<A-j>', [[pumvisible() ? "\<C-n>" : "\<A-j>"]],
    {expr = true, noremap = true, silent = true})
vim.api.nvim_set_keymap(
  'i', '<C-Space>', [[completion#trigger_completion()]],
    {expr = true, noremap = true, silent = true})

-- TODO improve snippets -- how do I cancel completion?? just press space and format ?
vim.api.nvim_set_keymap(
  'i', '<A-l>',
    [[pumvisible() ? "\<CR>" : vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : "\<A-l>"]],
    {expr = true})
vim.api.nvim_set_keymap(
  's', '<A-l>',
    [[pumvisible() ? "\<CR>" : vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : "\<A-l>"]],
    {expr = true})
vim.api.nvim_set_keymap(
  'i', '<A-h>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : "\<A-h>"]],
    {expr = true})
vim.api.nvim_set_keymap(
  's', '<A-h>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : "\<A-h>"]],
    {expr = true})
