local util = {}

function util.keys(tbl)
  local key_tbl = {}
  for k, _ in pairs(tbl) do
    table.insert(key_tbl, k)
  end
  return key_tbl
end

function util.quickview(obj)
  local bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_paste(vim.inspect(obj), true, -1)
  vim.api.nvim_win_set_cursor(0, {1, 0})

  local opts = {noremap = true, silent = true}
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '<cmd>bd<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<esc>', '<cmd>bd<cr>', opts)
end

-- function util.search_file_in_path(file)
--   local cwd = vim.fn.getcwd()
--   -- TODO search a file in this and all parent directories
-- end

function util.print_foldlevels()
  local folder = require 'nvim-treesitter.fold'
  local buf = vim.api.nvim_get_current_buf()

  local foldtbl = {}
  for i = 1, vim.api.nvim_buf_line_count(buf), 1 do
    table.insert(foldtbl, folder.get_fold_indic(i))
  end
  util.quickview(foldtbl)
end

vim.util = util
return util
