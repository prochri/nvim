local formatter = require 'format'

formatter.setup {
  ['*'] = {{cmd = {'sed -i \'s/[ \t]*$//\''}}}, -- remove trailing whitespace
  -- TODO default arguments / search for files
  lua = {{cmd = {'lua-format -i -c ~/git_repos/awesome-wm-config/.lua-format'}}}
}

local M = {}

function M.lsp_format_available()
  local clients = vim.lsp.get_active_clients()
  for _, c in ipairs(
    clients) do
    if c.server_capabilities.documentFormattingProvider then
      return true
    end
  end
  return false
end

function M.formatting(opts)
  if M.lsp_format_available() then
    vim.lsp.buf.formatting(
      opts)
  else
    -- TODO arguments?, direct call without vim?
    vim.cmd(
      'Format')
  end
end

return M
