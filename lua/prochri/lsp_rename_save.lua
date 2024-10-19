---@see https://github.com/saecki/live-rename.nvim/issues/5#issuecomment-2296645814
-- Write buffers that were edited
local rename_handler = vim.lsp.handlers["textDocument/rename"]
---@param result lsp.WorkspaceEdit?
vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
  rename_handler(err, result, ctx, config)

  if err or not result then
    return
  end

  ---@param buf integer?
  local function write_buf(buf)
    if buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("w")
      end)
    end
  end
  -- see relevant lsp spec: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_rename
  if result.changes then
    for uri, _ in pairs(result.changes) do
      local buf = vim.uri_to_bufnr(uri)
      write_buf(buf)
    end
  elseif result.documentChanges then
    for _, change in ipairs(result.documentChanges) do
      if change.textDocument then
        local buf = vim.uri_to_bufnr(change.textDocument.uri)
        write_buf(buf)
      end
    end
  end
end
