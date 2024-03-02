-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("config.which-key")
require("prochri.hydra")
require("prochri.fun")

local map = vim.keymap.set
local function noremap(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.tbl_extend("force", opts, { noremap = true, silent = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function nnoremap(lhs, rhs, opts)
  noremap("n", lhs, rhs, opts)
end

local function inoremap(lhs, rhs, opts)
  noremap("i", lhs, rhs, opts)
end

local function cnoremap(lhs, rhs, opts)
  noremap("c", lhs, rhs, opts)
end
local function tnoremap(lhs, rhs, opts)
  noremap("t", lhs, rhs, opts)
end

nnoremap("zf", prochri.fold_functions, { desc = "fold toplevel functions" })
for i = 0, 9 do
  nnoremap("z" .. i, "<cmd>lua prochri.fold_on_lvl_only(" .. i .. ")<cr>", { desc = "fold on lvl " .. i })
end

---@see https://www.reddit.com/r/neovim/comments/10b7e5x/comment/j49q3x2/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
nnoremap("gf", "gF")
nnoremap("gf", "<cmd>e <cfile><cr>")

-- terminal mapping
local terminal_escape = "<C-\\><C-n>"
tnoremap("<C-Esc>", terminal_escape)
tnoremap("<M-Esc>", terminal_escape)
tnoremap("<M-Space>", terminal_escape .. "<Space>")
-- should be part of lazyvim
-- tnoremap("<C-h>", terminal_escape .. "<C-w>h")
-- tnoremap("<C-j>", terminal_escape .. "<C-w>j")
-- tnoremap("<C-k>", terminal_escape .. "<C-w>k")
-- tnoremap("<C-l>", terminal_escape .. "<C-w>l")
tnoremap("<S-BS>", "<BS>")
vim.cmd([[nnoremap <silent><c-/> <Cmd>exe v:count1 . "ToggleTerm"<CR>]])
vim.cmd([[inoremap <silent><c-/> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>]])

require("prochri.fun")

nnoremap("K", prochri.smart_hover)

nnoremap("<ESC>", prochri.close_floating)
nnoremap("<C-=>", prochri.increase_fontsize)
nnoremap("<C-->", prochri.decrease_fontsize)
inoremap("<C-BS>", "<C-w>")
cnoremap("<C-BS>", "<C-w>")
inoremap("<D-v>", "<C-o>p")
cnoremap("<D-v>", "<C-o>p")
tnoremap("<D-v>", "<C-o>p")
cnoremap("<C-k>", "<C-\\>ev:lua.prochri.delete_remaing_command_line()<cr>")

map("n", "<C-LeftMouse>", "<LeftMouse>gd")
map("n", "<MiddleMouse>", "<LeftMouse>gd")
noremap({ "n", "v" }, "<f9>", "<C-o>")
noremap({ "n", "v" }, "<f10>", "<C-i>")

noremap({ "n", "v" }, "<f1>", prochri.toggle_perfanno)

-- scroll noice.nvim hover doc
vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-d>"
  end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-u>"
  end
end, { silent = true, expr = true })
