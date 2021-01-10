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

-- vim.lsp.stop_all_clients()

vim.lsp.handlers['textDocument/publishDiagnostics'] =
  vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {spacing = 4, prefix = ' '},
      underline = true,
      signs = true,
      update_in_insert = false
    })

local peek_definition
do

  -- Taken from https://www.reddit.com/r/neovim/comments/gyb077/nvimlsp_peek_defination_javascript_ttserver/ and modified a bit
  local floating_win
  local function preview_location(location, context, before_context)
    -- location may be LocationLink or Location (more useful for the former)
    context = context or 10
    before_context = before_context or 5
    local uri = location.targetUri or location.uri
    if uri == nil then
      return
    end
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.bufload(bufnr)
    end
    local range = location.targetRange or location.range
    local startline = math.max(range.start.line - before_context, 0)
    local endline = range['end'].line + 1 + context
    local contents = vim.api.nvim_buf_get_lines(
      bufnr, startline, endline, false)
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    return vim.lsp.util.open_floating_preview(contents, filetype)
  end

  local function preview_location_callback(_, method, result)
    local context = 10
    if result == nil or vim.tbl_isempty(result) then
      print('No location found: ' .. method)
      return nil
    end
    if vim.tbl_islist(result) then
      _, floating_win = preview_location(result[1], context)
    else
      _, floating_win = preview_location(result, context)
    end
  end

  peek_definition = function()
    if vim.tbl_contains(vim.api.nvim_list_wins(), floating_win) then
      vim.api.nvim_set_current_win(floating_win)
    else
      local params = vim.lsp.util.make_position_params()
      return vim.lsp.buf_request(
        0, 'textDocument/definition', params, preview_location_callback)
    end
  end
end

vim.lsp.buf.peek_definition = peek_definition

local uivonim_callbacks
if vim.g.uivonim == 1 then
  uivonim_callbacks = require('uivonim/lsp').callbacks
end

local on_attach = function(var, bufnr)
  -- vim.util.quickview(var)
  -- require'completion'.on_attach(var, bufnr)

  vim.api
    .nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.api
    .nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.api
    .nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]

  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', 'gr',
      '<cmd>lua require"telescope.builtin".lsp_references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', 'gD', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  -- sould be used by default binding
  -- vim.api.nvim_buf_set_keymap(
  --   bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(
  --   bufnr, 'n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(
  --   bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', '<Leader>pd', '<cmd>lua vim.lsp.buf.peek_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', '<Leader>de', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', '<Leader>c.',
      '<cmd>lua require"telescope.builtin".lsp_code_actions()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', '<Leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', '<Leader>cf',
      '<cmd>lua require"code.formatting".formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', '<Leader>eN',
      '<cmd>lua vim.lsp.diagnostic.goto_prev{ wrap = false }<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', '<Leader>en',
      '<cmd>lua vim.lsp.diagnostic.goto_next{ wrap = false }<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', '<Leader>es',
      '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
end

local root_pattern = lspconfig.util.root_pattern
local servers = {
  -- sumneko_lua = {
  --   root_dir = root_pattern('.git', 'rc.lua'),
  --   settings = {
  --     Lua = {
  --       runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
  --       diagnostics = {globals = {'vim', 'awesome', 'client'}},
  --       workspace = {
  --         library = {
  --           [vim.fn.expand('$VIMRUNTIME/lua')] = true,
  --           [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
  --           ['/usr/share/awesome/lib'] = true
  --         }
  --       }
  --     }
  --   }
  -- },
  texlab = {root_dir = root_pattern('Makefile', '.git')},
  pyls = {}
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for name, config in pairs(servers) do
  config.on_attach = on_attach
  config.handlers = uivonim_callbacks
  config.capabilities = capabilities
  if not config.root_dir then
    config.root_dir = root_pattern('.git', 'Makefile')
  end
  -- config.root_dir = root_pattern('.git', 'Makefile')
  lspconfig[name].setup(config)
end

vim.cmd('packadd nlua.nvim')
require'nlua.lsp.nvim'.setup(
  require 'lspconfig', {
    on_attach = on_attach,
    capabilities = capabilities, -- does not work
    globals = {'Color', 'c', 'Group', 'g', 's'}
  })
