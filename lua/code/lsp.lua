local lspconfig = require 'lspconfig'
-- require 'code.treesitter'
-- local formatting = require 'lsp.formatting'
local vim = _G.vim
-- local vimp = require('vimp')
local opts = {noremap = true, silent = true}

-- TODO this is completion options
-- TODO this doesnt work anyways
-- vim.cmd("autocmd BufEnter * lua require'completion'.on_attach()")

if not vim.lsp then
  return
end

local saga = require 'lspsaga'
saga.init_lsp_saga()

local lspinstall = require'lspinstall'
local function setup_servers()
  lspinstall.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end
-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

local language_servers = {'vim', 'latex', 'python', 'lua', 'cpp', 'json', 'typescript'}
do
  local installed_servers = {}
  for _, server in pairs(lspinstall.installed_servers()) do
    installed_servers[server] = true
  end
  for _, server in pairs(language_servers) do
    if not installed_servers[server] then
      lspinstall.install_server(server)
    end
  end
end
setup_servers()

-- vim.lsp.stop_all_clients()

-- vim.lsp.handlers['textDocument/publishDiagnostics'] =
--   vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--       virtual_text = {spacing = 4, prefix = ' '},
--       underline = true,
--       signs = true,
--       update_in_insert = false
--     })

-- do

-- local on_attach = function(var, bufnr)
--   -- vim.util.quickview(var)
--   -- require'completion'.on_attach(var, bufnr)

--   vim.api
--     .nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
--   vim.api
--     .nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
--   vim.api
--     .nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]

--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', 'gr',
--       '<cmd>lua require"telescope.builtin".lsp_references()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', 'gD', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
--   -- sould be used by default binding
--   -- vim.api.nvim_buf_set_keymap(
--   --   bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   -- vim.api.nvim_buf_set_keymap(
--   --   bufnr, 'n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   -- vim.api.nvim_buf_set_keymap(
--   --   bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', '<Leader>pd', '<cmd>lua vim.lsp.buf.peek_definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', '<Leader>de', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', '<Leader>c.',
--       '<cmd>lua require"telescope.builtin".lsp_code_actions()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', '<Leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', '<Leader>cf',
--       '<cmd>lua require"code.formatting".formatting()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', '<Leader>eN',
--       '<cmd>lua vim.lsp.diagnostic.goto_prev{ wrap = false }<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', '<Leader>en',
--       '<cmd>lua vim.lsp.diagnostic.goto_next{ wrap = false }<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr, 'n', '<Leader>es',
--       '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
-- end
local root_pattern = lspconfig.util.root_pattern
local servers = {
  sumneko_lua = {
    root_dir = root_pattern('.git', 'rc.lua'),
    -- cmd = '/usr/bin/lua-language-server',
    settings = {
      Lua = {
        runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
        diagnostics = {globals = {'vim', 'awesome', 'client'}},
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            ['/usr/share/awesome/lib'] = true
          }
        }
      }
    }
  },
  -- texlab = {root_dir = root_pattern('Makefile', '.git')},
  -- pyls = {}
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- for name, config in pairs(servers) do
--   config.capabilities = capabilities
--   if not config.root_dir then
--     config.root_dir = root_pattern('.git', 'Makefile')
--   end
--   print(name)
--   print(lspconfig[name].setup)
--   print(config)
--   lspconfig[name].setup(config)
-- end

-- vim.cmd('packadd nlua.nvim')
-- require'nlua.lsp.nvim'.setup(
--   require 'lspconfig', {
--     on_attach = on_attach,
--     capabilities = capabilities, -- does not work
--     globals = {'Color', 'c', 'Group', 'g', 's'}
--   })
