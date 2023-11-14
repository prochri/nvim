-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("config.which-key")
require("xonuto.hydra")
require("xonuto.fun")

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

nnoremap("zf", xonuto.fold_functions, { desc = "fold toplevel functions" })
for i = 0, 9 do
  nnoremap("z" .. i, "<cmd>lua xonuto.fold_on_lvl_only(" .. i .. ")<cr>", { desc = "fold on lvl " .. i })
end

-- terminal mapping
local terminal_escape = "<C-\\><C-n>"
tnoremap("<C-Esc>", terminal_escape)
tnoremap("<M-Esc>", terminal_escape)
tnoremap("<M-Space>", terminal_escape .. "<Space>")
tnoremap("<C-h>", terminal_escape .. "<C-w>h")
tnoremap("<C-j>", terminal_escape .. "<C-w>j")
tnoremap("<C-k>", terminal_escape .. "<C-w>k")
tnoremap("<C-l>", terminal_escape .. "<C-w>l")
tnoremap("<S-BS>", "<BS>")

require("xonuto.fun")

nnoremap("K", xonuto.smart_hover)

nnoremap("<ESC>", xonuto.close_floating)
nnoremap("<C-=>", xonuto.increase_fontsize)
nnoremap("<C-->", xonuto.decrease_fontsize)
inoremap("<C-BS>", "<C-w>")
cnoremap("<C-BS>", "<C-w>")
cnoremap("<C-k>", "<C-\\>ev:lua.xonuto.delete_remaing_command_line()<cr>")

map("n", "<C-LeftMouse>", "<LeftMouse>gd")
map("n", "<MiddleMouse>", "<LeftMouse>gd")
noremap({ "n", "v" }, "<f9>", "<C-o>")
noremap({ "n", "v" }, "<f10>", "<C-i>")

noremap({ "n", "v" }, "<f1>", xonuto.toggle_perfanno)
