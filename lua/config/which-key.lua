
local map = vim.keymap.set
if not _G.prochri then _G.prochri = {} end
_G.prochri.wk_map = {mode = {"n", "v"}}
    
map("n", "<leader> ", "<cmd>Telescope cmdline<cr>", {noremap = true, silent = true, desc = "+Commands"})
map("v", "<leader> ", "<cmd>Telescope cmdline<cr>", {noremap = true, silent = true, desc = "+Commands"})
map("n", "<leader>'", "<cmd>ToggleTerm<cr>", {noremap = true, silent = true, desc = "ToggleTerm"})
map("v", "<leader>'", "<cmd>ToggleTerm<cr>", {noremap = true, silent = true, desc = "ToggleTerm"})
map("n", "<leader>sP", "<cmd>Telescope grep_string<cr>", {noremap = true, silent = true, desc = "Search cursor word"})
map("v", "<leader>sP", "<cmd>Telescope grep_string<cr>", {noremap = true, silent = true, desc = "Search cursor word"})
_G.prochri.wk_map["<leader>v"] = { name = "+vimtex" }
map("n", "<leader>vc", "<cmd>VimtexCompile<cr>", {noremap = true, silent = true, desc = "Vimtex Compile"})
map("v", "<leader>vc", "<cmd>VimtexCompile<cr>", {noremap = true, silent = true, desc = "Vimtex Compile"})
map("n", "<leader>vs", "<cmd>VimtexView<cr>", {noremap = true, silent = true, desc = "Vimtex Show"})
map("v", "<leader>vs", "<cmd>VimtexView<cr>", {noremap = true, silent = true, desc = "Vimtex Show"})
map("n", "<leader>ci", "<cmd>lua prochri.code_action_import()<cr>", {noremap = true, silent = true, desc = "Import under cursor"})
map("v", "<leader>ci", "<cmd>lua prochri.code_action_import()<cr>", {noremap = true, silent = true, desc = "Import under cursor"})
_G.prochri.wk_map["<leader>w"] = { name = "+Window" }
map("n", "<leader>wh", "<C-w>h", {noremap = true, silent = true, desc = "Focus left"})
map("v", "<leader>wh", "<C-w>h", {noremap = true, silent = true, desc = "Focus left"})
map("n", "<leader>wl", "<C-w>l", {noremap = true, silent = true, desc = "Focus right"})
map("v", "<leader>wl", "<C-w>l", {noremap = true, silent = true, desc = "Focus right"})
map("n", "<leader>wj", "<C-w>j", {noremap = true, silent = true, desc = "Focus below"})
map("v", "<leader>wj", "<C-w>j", {noremap = true, silent = true, desc = "Focus below"})
map("n", "<leader>wk", "<C-w>k", {noremap = true, silent = true, desc = "Focus above"})
map("v", "<leader>wk", "<C-w>k", {noremap = true, silent = true, desc = "Focus above"})
map("n", "<leader>ws", "<C-w>s", {noremap = true, silent = true, desc = "Split horizontally"})
map("v", "<leader>ws", "<C-w>s", {noremap = true, silent = true, desc = "Split horizontally"})
map("n", "<leader>wv", "<C-w>v", {noremap = true, silent = true, desc = "Split vertically"})
map("v", "<leader>wv", "<C-w>v", {noremap = true, silent = true, desc = "Split vertically"})
map("n", "<leader>wd", "<cmd>hide<cr>", {noremap = true, silent = true, desc = "Delete window"})
map("v", "<leader>wd", "<cmd>hide<cr>", {noremap = true, silent = true, desc = "Delete window"})
map("n", "<leader>w=", "<c-w><c-w>", {noremap = true, silent = true, desc = "balance size"})
map("v", "<leader>w=", "<c-w><c-w>", {noremap = true, silent = true, desc = "balance size"})
map("n", "<leader>w.", "<cmd>lua prochri.hydra.window:activate()<cr>", {noremap = true, silent = true, desc = "Window hydra"})
map("v", "<leader>w.", "<cmd>lua prochri.hydra.window:activate()<cr>", {noremap = true, silent = true, desc = "Window hydra"})
map("n", "<leader>bb", "<cmd>Telescope buffers<cr>", {noremap = true, silent = true, desc = "search buffers"})
map("v", "<leader>bb", "<cmd>Telescope buffers<cr>", {noremap = true, silent = true, desc = "search buffers"})
map("n", "<leader>bn", "<cmd>bnext<cr>", {noremap = true, silent = true, desc = "next buffer"})
map("v", "<leader>bn", "<cmd>bnext<cr>", {noremap = true, silent = true, desc = "next buffer"})
map("n", "<leader>bp", "<cmd>bprev<cr>", {noremap = true, silent = true, desc = "previous buffer"})
map("v", "<leader>bp", "<cmd>bprev<cr>", {noremap = true, silent = true, desc = "previous buffer"})
map("n", "<leader>bN", "<cmd>bprev<cr>", {noremap = true, silent = true, desc = "previous buffer"})
map("v", "<leader>bN", "<cmd>bprev<cr>", {noremap = true, silent = true, desc = "previous buffer"})
map("n", "<leader>bd", "<cmd>BufDel<cr>", {noremap = true, silent = true, desc = "delete buffer"})
map("v", "<leader>bd", "<cmd>BufDel<cr>", {noremap = true, silent = true, desc = "delete buffer"})
map("n", "<leader>bs", "<cmd>BufferLinePick<cr>", {noremap = true, silent = true, desc = "search bufferline"})
map("v", "<leader>bs", "<cmd>BufferLinePick<cr>", {noremap = true, silent = true, desc = "search bufferline"})
_G.prochri.wk_map["<leader>f"] = { name = "+Files" }
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {noremap = true, silent = true, desc = "find files"})
map("v", "<leader>ff", "<cmd>Telescope find_files<cr>", {noremap = true, silent = true, desc = "find files"})
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {noremap = true, silent = true, desc = "recent files"})
map("v", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {noremap = true, silent = true, desc = "recent files"})
map("n", "<leader>fs", "<cmd>w!<cr>", {noremap = true, silent = true, desc = "save"})
map("v", "<leader>fs", "<cmd>w!<cr>", {noremap = true, silent = true, desc = "save"})
map("n", "<leader>fS", "<cmd>wa!<cr>", {noremap = true, silent = true, desc = "save all"})
map("v", "<leader>fS", "<cmd>wa!<cr>", {noremap = true, silent = true, desc = "save all"})
map("n", "<leader>pp", "<cmd>ResessionLoad<cr>", {noremap = true, silent = true, desc = "Recent project sessions"})
map("v", "<leader>pp", "<cmd>ResessionLoad<cr>", {noremap = true, silent = true, desc = "Recent project sessions"})
map("n", "<leader>pn", "<cmd>!open -n /Applications/Neovide.app<cr>", {noremap = true, silent = true, desc = "New (Neovide) Project Window"})
map("v", "<leader>pn", "<cmd>!open -n /Applications/Neovide.app<cr>", {noremap = true, silent = true, desc = "New (Neovide) Project Window"})
map("n", "<leader>pf", "<cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true})<cr>", {noremap = true, silent = true, desc = "Files in git project"})
map("v", "<leader>pf", "<cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true})<cr>", {noremap = true, silent = true, desc = "Files in git project"})
map("n", "<leader>pr", "<cmd>OverseerRun<cr>", {noremap = true, silent = true, desc = "Run project task from template"})
map("v", "<leader>pr", "<cmd>OverseerRun<cr>", {noremap = true, silent = true, desc = "Run project task from template"})
_G.prochri.wk_map["<leader>pt"] = { name = "+Task Tools" }
map("n", "<leader>ptt", "<cmd>OverseerToggle<cr>", {noremap = true, silent = true, desc = "Toggle Task Window"})
map("v", "<leader>ptt", "<cmd>OverseerToggle<cr>", {noremap = true, silent = true, desc = "Toggle Task Window"})
map("n", "<leader>ptl", "<cmd>OverseerQuickAction<cr>", {noremap = true, silent = true, desc = "Last Task Actions"})
map("v", "<leader>ptl", "<cmd>OverseerQuickAction<cr>", {noremap = true, silent = true, desc = "Last Task Actions"})
map("n", "<leader>pto", "<cmd>OverseerQuickAction open<cr>", {noremap = true, silent = true, desc = "Last Task Actions"})
map("v", "<leader>pto", "<cmd>OverseerQuickAction open<cr>", {noremap = true, silent = true, desc = "Last Task Actions"})
_G.prochri.wk_map["<leader>o"] = { name = "+Organizational/Obsidian" }
map("n", "<leader>os", "<cmd>ObsidianSearch<cr>", {noremap = true, silent = true, desc = "Search notes"})
map("v", "<leader>os", "<cmd>ObsidianSearch<cr>", {noremap = true, silent = true, desc = "Search notes"})
map("n", "<leader>ox", "<cmd>ObsidianOpen<cr>", {noremap = true, silent = true, desc = "Open external"})
map("v", "<leader>ox", "<cmd>ObsidianOpen<cr>", {noremap = true, silent = true, desc = "Open external"})
map("n", "<leader>ot", "<cmd>ObsidianToday<cr>", {noremap = true, silent = true, desc = "Open todays note"})
map("v", "<leader>ot", "<cmd>ObsidianToday<cr>", {noremap = true, silent = true, desc = "Open todays note"})
map("n", "<leader>op", "<cmd>lua prochri.open_pdf()<cr>", {noremap = true, silent = true, desc = "Open PDF file under cursor"})
map("v", "<leader>op", "<cmd>lua prochri.open_pdf()<cr>", {noremap = true, silent = true, desc = "Open PDF file under cursor"})
map("n", "<leader>gg", "<cmd>Neogit<cr>", {noremap = true, silent = true, desc = "Neogit"})
map("v", "<leader>gg", "<cmd>Neogit<cr>", {noremap = true, silent = true, desc = "Neogit"})
map("n", "<leader>sp", "<cmd>Telescope live_grep<cr>", {noremap = true, silent = true, desc = "Search project"})
map("v", "<leader>sp", "<cmd>Telescope live_grep<cr>", {noremap = true, silent = true, desc = "Search project"})
map("n", "<leader>sP", "<cmd>Telescope grep_string<cr>", {noremap = true, silent = true, desc = "Search string in project"})
map("v", "<leader>sP", "<cmd>Telescope grep_string<cr>", {noremap = true, silent = true, desc = "Search string in project"})
_G.prochri.wk_map["<leader>t"] = { name = "+Toggles" }
map("n", "<leader>tw", "<cmd>set wrap!<cr>", {noremap = true, silent = true, desc = "Toggle wrap"})
map("v", "<leader>tw", "<cmd>set wrap!<cr>", {noremap = true, silent = true, desc = "Toggle wrap"})
map("n", "<leader>th", "<cmd>set hlsearch!<cr>", {noremap = true, silent = true, desc = "Toggle highlight"})
map("v", "<leader>th", "<cmd>set hlsearch!<cr>", {noremap = true, silent = true, desc = "Toggle highlight"})
map("n", "<leader>td", "<cmd>lua prochri.dapui.toggle()<cr>", {noremap = true, silent = true, desc = "Toggle debug UI"})
map("v", "<leader>td", "<cmd>lua prochri.dapui.toggle()<cr>", {noremap = true, silent = true, desc = "Toggle debug UI"})
map("n", "<leader>tl", "<cmd>lua require'lsp_lines'.toggle()<cr>", {noremap = true, silent = true, desc = "Toggle LSP lines"})
map("v", "<leader>tl", "<cmd>lua require'lsp_lines'.toggle()<cr>", {noremap = true, silent = true, desc = "Toggle LSP lines"})
map("n", "<leader>tn", "<cmd>tabn<cr>", {noremap = true, silent = true, desc = "next tab"})
map("v", "<leader>tn", "<cmd>tabn<cr>", {noremap = true, silent = true, desc = "next tab"})
map("n", "<leader>tp", "<cmd>tabp<cr>", {noremap = true, silent = true, desc = "next tab"})
map("v", "<leader>tp", "<cmd>tabp<cr>", {noremap = true, silent = true, desc = "next tab"})
map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", {noremap = true, silent = true, desc = "Toggle Git Blame"})
map("v", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", {noremap = true, silent = true, desc = "Toggle Git Blame"})
map("n", "<leader>d.", "<cmd>lua prochri.hydra.debug:activate()<cr>", {noremap = true, silent = true, desc = "debug hydra"})
map("v", "<leader>d.", "<cmd>lua prochri.hydra.debug:activate()<cr>", {noremap = true, silent = true, desc = "debug hydra"})
map("n", "<leader>dd", "<cmd>lua require'dap'.continue()<cr>", {noremap = true, silent = true, desc = "start debugging"})
map("v", "<leader>dd", "<cmd>lua require'dap'.continue()<cr>", {noremap = true, silent = true, desc = "start debugging"})
map("n", "<leader>dr", "<cmd>lua require'dap'.continue()<cr>", {noremap = true, silent = true, desc = "start (without) debugging"})
map("v", "<leader>dr", "<cmd>lua require'dap'.continue()<cr>", {noremap = true, silent = true, desc = "start (without) debugging"})
map("n", "<leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", {noremap = true, silent = true, desc = "toggle breakpoint"})
map("v", "<leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", {noremap = true, silent = true, desc = "toggle breakpoint"})
map("n", "<leader>ds", "<cmd>lua require'dap'.step_into()<cr>", {noremap = true, silent = true, desc = "step into"})
map("v", "<leader>ds", "<cmd>lua require'dap'.step_into()<cr>", {noremap = true, silent = true, desc = "step into"})
map("n", "<leader>dn", "<cmd>lua require'dap'.step_over()<cr>", {noremap = true, silent = true, desc = "next line"})
map("v", "<leader>dn", "<cmd>lua require'dap'.step_over()<cr>", {noremap = true, silent = true, desc = "next line"})
map("n", "<leader>du", "<cmd>lua require'dap'.step_out()<cr>", {noremap = true, silent = true, desc = "step out/up"})
map("v", "<leader>du", "<cmd>lua require'dap'.step_out()<cr>", {noremap = true, silent = true, desc = "step out/up"})
map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", {noremap = true, silent = true, desc = "run last"})
map("v", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", {noremap = true, silent = true, desc = "run last"})
map("n", "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>", {noremap = true, silent = true, desc = "terminate"})
map("v", "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>", {noremap = true, silent = true, desc = "terminate"})
_G.prochri.wk_map["<leader>e"] = { name = "+Error" }
map("n", "<leader>en", "<cmd>lua vim.diagnostic.goto_next()<cr>", {noremap = true, silent = true, desc = "next error"})
map("v", "<leader>en", "<cmd>lua vim.diagnostic.goto_next()<cr>", {noremap = true, silent = true, desc = "next error"})
map("n", "<leader>ep", "<cmd>lua vim.diagnostic.goto_prev()<cr>", {noremap = true, silent = true, desc = "next error"})
map("v", "<leader>ep", "<cmd>lua vim.diagnostic.goto_prev()<cr>", {noremap = true, silent = true, desc = "next error"})
map("n", "<leader>el", "<cmd>Trouble diagnostics<cr>", {noremap = true, silent = true, desc = "List errors in Trouble"})
map("v", "<leader>el", "<cmd>Trouble diagnostics<cr>", {noremap = true, silent = true, desc = "List errors in Trouble"})
map("n", "<leader>ey", "<cmd>lua prochri.yank_diagnostic()<cr>", {noremap = true, silent = true, desc = "Yank first error"})
map("v", "<leader>ey", "<cmd>lua prochri.yank_diagnostic()<cr>", {noremap = true, silent = true, desc = "Yank first error"})
_G.prochri.wk_map["<leader>q"] = { name = "+Quickfix" }
map("n", "<leader>qt", "<cmd>TodoQuickFix<cr>", {noremap = true, silent = true, desc = "Todo items in project"})
map("v", "<leader>qt", "<cmd>TodoQuickFix<cr>", {noremap = true, silent = true, desc = "Todo items in project"})
map("n", "<leader>qe", "<cmd>lua require'diaglist'.open_all_diagnostics()<cr>", {noremap = true, silent = true, desc = "Workspace Diagnostics"})
map("v", "<leader>qe", "<cmd>lua require'diaglist'.open_all_diagnostics()<cr>", {noremap = true, silent = true, desc = "Workspace Diagnostics"})
map("n", "<leader>qq", "<cmd>cclose<cr>", {noremap = true, silent = true, desc = "Quit Quickfix Window"})
map("v", "<leader>qq", "<cmd>cclose<cr>", {noremap = true, silent = true, desc = "Quit Quickfix Window"})
map("n", "<leader>qf", "<cmd>copen<cr>", {noremap = true, silent = true, desc = "Open Quickfix Window"})
map("v", "<leader>qf", "<cmd>copen<cr>", {noremap = true, silent = true, desc = "Open Quickfix Window"})

local wk = require("which-key")
wk.register(_G.prochri.wk_map)
    