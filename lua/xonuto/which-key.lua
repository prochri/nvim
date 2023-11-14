local mappings = lvim.builtin.which_key.mappings

mappings[" "] = { "<cmd>Telescope commands<cr>", "+Commands" }
mappings["'"] = { "<cmd>ToggleTerm<cr>", "ToggleTerm" }
mappings["s"]["P"] = { "<cmd>Telescope grep_string<cr>", "Search cursor word" }
mappings["v"] = { name = "+vimtex" }
mappings["v"]["c"] = { "<cmd>VimtexCompile<cr>", "Vimtex Compile" }
mappings["v"]["s"] = { "<cmd>VimtexView<cr>", "Vimtex Show" }
mappings["l"]["a"] = { "<cmd>CodeActionMenu<cr>", "code action" }
mappings["l"]["r"] = { "<cmd>Lspsaga rename<cr>", "rename" }
mappings["l"]["p"] = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" }
mappings["l"]["h"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" }
mappings["w"] = { name = "+Window" }
mappings["w"]["h"] = { "<C-w>h", "Focus left" }
mappings["w"]["l"] = { "<C-w>l", "Focus right" }
mappings["w"]["j"] = { "<C-w>j", "Focus below" }
mappings["w"]["k"] = { "<C-w>k", "Focus above" }
mappings["w"]["s"] = { "<C-w>s", "Split horizontally" }
mappings["w"]["v"] = { "<C-w>v", "Split vertically" }
mappings["w"]["d"] = { "<cmd>hide<cr>", "Delete window" }
mappings["w"]["="] = { "<c-w><c-w>", "balance size" }
mappings["w"]["."] = { "<cmd>lua xonuto.hydra.window:activate()<cr>", "Window hydra" }
mappings["b"]["b"] = { "<cmd>Telescope buffers<cr>", "search buffers" }
mappings["b"]["n"] = { "<cmd>bnext<cr>", "next buffer" }
mappings["b"]["p"] = { "<cmd>bprev<cr>", "previous buffer" }
mappings["b"]["N"] = { "<cmd>bprev<cr>", "previous buffer" }
mappings["b"]["d"] = { "<cmd>BufferKill<cr>", "delete buffer" }
mappings["b"]["s"] = { "<cmd>BufferLinePick<cr>", "search bufferline" }
mappings["f"] = { name = "+Files" }
mappings["f"]["f"] = { "<cmd>Telescope find_files<cr>", "find files" }
mappings["f"]["t"] = { "<cmd>NvimTreeToggle<cr>", "File Tree" }
mappings["f"]["r"] = { "<cmd>Telescope oldfiles<cr>", "recent files" }
mappings["f"]["s"] = { "<cmd>w!<cr>", "save" }
mappings["f"]["S"] = { "<cmd>wa!<cr>", "save all" }
mappings["p"]["p"] = { "<cmd>Telescope session-lens search_session<cr>", "Recent project sessions" }
mappings["p"]["f"] = { "<cmd>Telescope git_files<cr>", "Files in git project" }
mappings["o"] = { name = "+Organizational/Obsidian" }
mappings["o"]["s"] = { "<cmd>ZkNotes<cr>", "Search notes" }
mappings["o"]["t"] = { "<cmd>lua xonuto.open_todays_note()<cr>", "Open todays note" }
mappings["o"]["b"] = { "<cmd>ZkBacklinks<cr>", "Show Backlinks" }
mappings["o"]["p"] = { "<cmd>lua xonuto.open_pdf()<cr>", "Open PDF file under cursor" }
mappings["g"]["g"] = { "<cmd>Neogit<cr>", "Neogit" }
mappings["s"]["p"] = { "<cmd>Telescope live_grep<cr>", "Search project" }
mappings["s"]["P"] = { "<cmd>Telescope grep_string<cr>", "Search string in project" }
mappings["t"] = { name = "+Toggles" }
mappings["t"]["w"] = { "<cmd>set wrap!<cr>", "Toggle wrap" }
mappings["t"]["h"] = { "<cmd>set hlsearch!<cr>", "Toggle highlight" }
mappings["t"]["d"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle debug UI" }
mappings["t"]["l"] = { "<cmd>lua require'lsp_lines'.toggle()<cr>", "Toggle LSP lines" }
mappings["d"]["."] = { "<cmd>lua xonuto.hydra.debug:activate()<cr>", "debug hydra" }
mappings["d"]["d"] = { "<cmd>lua require'dap'.continue()<cr>", "start debugging" }
mappings["d"]["r"] = { "<cmd>lua require'dap'.continue()<cr>", "start debugging" }
mappings["d"]["t"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint" }
mappings["d"]["s"] = { "<cmd>lua require'dap'.step_into()<cr>", "step into" }
mappings["d"]["n"] = { "<cmd>lua require'dap'.step_over()<cr>", "next line" }
mappings["d"]["u"] = { "<cmd>lua require'dap'.step_out()<cr>", "step out/up" }
mappings["d"]["l"] = { "<cmd>lua require'dap'.run_last()<cr>", "run last" }
mappings["d"]["x"] = { "<cmd>lua require'dap'.terminate()<cr>", "terminate" }
mappings["e"] = { name = "+Error" }
mappings["e"]["n"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "next error" }
mappings["e"]["p"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "next error" }
mappings["e"]["l"] = { "<cmd>lua require'diaglist'.open_all_diagnostics()<cr>", "next error" }
mappings["q"] = { name = "+Quickfix" }
mappings["q"]["t"] = { "<cmd>TodoQuickFix<cr>", "Todo items in project" }
mappings["q"]["e"] = { "<cmd>lua require'diaglist'.open_all_diagnostics()<cr>", "Workspace Diagnostics" }
mappings["q"]["q"] = { "<cmd>cclose<cr>", "Quit Quickfix Window" }
mappings["q"]["f"] = { "<cmd>copen<cr>", "Open Quickfix Window" }
