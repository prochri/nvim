-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("config.which-key")
-- require("prochri.hydra")
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

-- disable some keymaps
vim.keymap.del("i", "<M-k>")
vim.keymap.del("i", "<M-j>")

nnoremap("zf", prochri.fold_functions, { desc = "fold toplevel functions" })
for i = 0, 9 do
  nnoremap("z" .. i, "<cmd>lua prochri.fold_on_lvl_only(" .. i .. ")<cr>", { desc = "fold on lvl " .. i })
end

---@see https://www.reddit.com/r/neovim/comments/10b7e5x/comment/j49q3x2/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
nnoremap("gf", "gF")
nnoremap("gf", "<cmd>e <cfile><cr>")
nnoremap("gX", prochri.open_first_hover_link)

inoremap("<S-Down>", "<Nop>")
inoremap("<S-Up>", "<Nop>")
nnoremap("<S-Down>", "<Nop>")
nnoremap("<S-Up>", "<Nop>")

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
--
inoremap("<C-h>", "<C-o><C-w>h")
inoremap("<C-j>", "<C-o><C-w>j")
inoremap("<C-k>", "<C-o><C-w>k")
inoremap("<C-l>", "<C-o><C-w>l")
tnoremap("<S-BS>", "<BS>")
vim.cmd([[nnoremap <silent><c-/> <Cmd>FloatermToggle<CR>]])
vim.cmd([[inoremap <silent><c-/> <Esc><Cmd>FloatermToggle<CR>]])
vim.cmd([[tnoremap <silent><c-/> <Esc><Cmd>FloatermToggle<CR>]])

require("prochri.fun")

nnoremap("K", function()
  prochri.smart_hover()
end)

nnoremap("<ESC>", prochri.close_floating)
nnoremap("<C-=>", prochri.increase_fontsize)
nnoremap("<C-->", prochri.decrease_fontsize)
inoremap("<C-BS>", "<C-w>")
cnoremap("<C-BS>", "<C-w>")
inoremap("<D-v>", "<C-r>*")
cnoremap("<D-v>", "<C-r>*")
tnoremap("<D-v>", terminal_escape .. "pi")
cnoremap("<C-k>", "<C-\\>ev:lua.prochri.delete_remaing_command_line()<cr>")

map("n", "<C-LeftMouse>", "<LeftMouse>gd")
map("n", "<MiddleMouse>", "<LeftMouse>gd")
noremap({ "n", "v" }, "<f9>", "<C-o>")
noremap({ "n", "v" }, "<f10>", "<C-i>")

noremap({ "n", "v" }, "<f1>", prochri.toggle_perfanno)

local function load_session_f(name)
  return function()
    require("prochri.resession").load_or_switch(name)
  end
end

noremap({ "n", "i", "v", "x" }, "<D-1>", load_session_f("Portal"))
noremap({ "n", "i", "v", "x" }, "<D-2>", load_session_f("API"))
noremap({ "n", "i", "v", "x" }, "<D-3>", load_session_f("Simulation"))
noremap({ "n", "i", "v", "x" }, "<D-4>", load_session_f("_SharedUtils"))
noremap({ "n", "i", "v", "x" }, "<D-5>", load_session_f("Notes"))
noremap({ "n", "i", "v", "x" }, "<D-6>", load_session_f("translation-tool"))
noremap({ "n", "i", "v", "x" }, "<D-7>", load_session_f("App"))
noremap({ "n", "i", "v", "x" }, "<D-0>", load_session_f("nvim-config"))

local ok, noice_lsp = pcall(require, "noice.lsp")
-- scroll noice.nvim hover doc
if ok then
  vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
    if noice_lsp.scroll(4) then
      return "<c-d>"
    end
  end, { silent = true, expr = true })

  vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
    if noice_lsp.scroll(-4) then
      return "<c-u>"
    end
  end, { silent = true, expr = true })
end
