if not _G.xonuto then
  _G.xonuto = {}
end

local function get_guifont_info()
  local font = vim.o.guifont
  local fontname, sizestr = string.match(font, "(.*):h(.*)")
  return fontname, tonumber(sizestr)
end

local function set_guifont(fontname, fontsize)
  vim.o.guifont = fontname .. ":h" .. fontsize
end

function xonuto.increase_fontsize()
  local fontname, fontsize = get_guifont_info()
  fontsize = fontsize + 1
  set_guifont(fontname, fontsize)
end

function xonuto.decrease_fontsize()
  local fontname, fontsize = get_guifont_info()
  fontsize = fontsize - 1
  if fontsize == 0 then
    fontsize = 1
  end
  set_guifont(fontname, fontsize)
end

function xonuto.test()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
    vim.lsp.buf.hover()
    print(filetype)
  end
end

-- get active window
function xonuto.get_active_window()
  local active_window = vim.api.nvim_get_current_win()
  p(vim.api.nvim_win_get_config(active_window))
end

function xonuto.close_floating()
  local needs_hack = false
  local inactive_floating_wins = vim.fn.filter(vim.api.nvim_list_wins(), function(k, v)
    local file_type = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(v) })
    if file_type == "noice" then
      needs_hack = true
    end
    ---@diagnostic disable-next-line: undefined-field
    return vim.api.nvim_win_get_config(v).relative ~= ""
      and v ~= vim.api.nvim_get_current_win()
      and file_type ~= "hydra_hint"
      and file_type ~= "incline"
  end)
  if needs_hack then
    vim.api.nvim_feedkeys("jk", "nt", true)
  end
  for _, w in ipairs(inactive_floating_wins) do
    pcall(vim.api.nvim_win_close, w, false)
  end
end

function xonuto.show_floating()
  local inactive_floating_wins = vim.fn.filter(vim.api.nvim_list_wins(), function(k, v)
    local file_type = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(v) })
    print("file type:", file_type, "buffer", v)
    p(vim.api.nvim_win_get_config(v))
    ---@diagnostic disable-next-line: undefined-field
    return vim.api.nvim_win_get_config(v).relative ~= ""
      and v ~= vim.api.nvim_get_current_win()
      and file_type ~= "hydra_hint"
  end)
end

-- get cursor position and line
function xonuto.get_cursor_pos()
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  return line, pos
end

-- find enclosing square braces around position in string
function xonuto.get_braces_pos(str, pos, open, close)
  local before = string.sub(str, 1, pos):reverse()
  local after = string.sub(str, pos)
  local start_pos
  local end_pos
  for index = 1, before:len() do
    local value = before:sub(index, index)
    if value == open then
      start_pos = pos - index + 1
      break
    end
  end
  for index = 1, after:len() do
    local value = after:sub(index, index)
    if value == close then
      end_pos = pos + index - 1
      break
    end
  end
  if start_pos and end_pos then
    return string.sub(str, start_pos + 1, end_pos - 1)
  else
    return ""
  end
end

function xonuto.get_square_braces_pos(line, pos)
  return xonuto.get_braces_pos(line, pos, "[", "]")
end

function xonuto.get_curly_braces_pos(line, pos)
  return xonuto.get_braces_pos(line, pos, "{}")
end

function xonuto.get_filename()
  local line, pos = xonuto.get_cursor_pos()
  local filename
  filename = xonuto.get_square_braces_pos(line, pos)
  if filename ~= "" then
    return filename
  end
  filename = xonuto.get_curly_braces_pos(line, pos)
  if filename ~= "" then
    return filename
  end
  if vim.fn.expand("%:e") == "md" then
    return vim.fn.expand("%:t:r")
  end
  return ""
end

-- open pdf file with given filename without extension in the path specified
function xonuto.open_pdf()
  local filename = xonuto.get_filename()
  if filename == "" then
    print("No potential file name found")
    return
  end
  local path = os.getenv("HOME") .. "/Masterarbeit/Literature/"
  local pdf_path = path .. filename .. ".pdf"
  if vim.fn.filereadable(pdf_path) == 1 then
    -- open file in external program
    vim.fn.jobstart("xdg-open " .. pdf_path, { detach = true })
  else
    print("No pdf file found:", pdf_path)
  end
end

local notes_path = vim.env.HOME .. "/Nextcloud/Notes/"
local daily_notes = notes_path .. "DailyNotes/"
xonuto.open_todays_note = function()
  local date = vim.fn.strftime("%Y-%m-%d")
  local file = daily_notes .. date .. ".md"
  vim.cmd.edit(file)
end

function xonuto.delete_remaing_command_line()
  local cmd = vim.fn.getcmdline()
  local completType = vim.fn.getcmdcompltype()
  if completType == "<Lua function>" then
    completType = "cmdline"
  end

  local remaining = cmd:sub(0, vim.fn.getcmdpos() - 1)
  return remaining
end

function xonuto.start_telescope_qf()
  vim.cmd("cclose")
  require("telescope.builtin").quickfix()
end

function xonuto.smart_hover()
  -- hover fold content
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if winid then
    return
  end

  if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
    require("crates").show_popup()
  end
  local clients = vim.lsp.get_active_clients()
  -- check if rust-analyzer is active
  for _, client in ipairs(clients) do
    if client.name == "rust_analyzer" then
      print("rust-analyzer hover")
      vim.cmd("RustHoverActions")
      return
    end
  end
  local ok, _ = pcall(vim.lsp.buf.hover)
  if ok then
    return
  end
  vim.api.nvim_feedkeys("K", "n", true)
end

local dapui = require("dapui")
local debug_win = nil
local debug_tab = nil
local debug_tabnr = nil
xonuto.dapui = {}

-- taken from https://github.com/rcarriga/nvim-dap-ui/issues/122#issuecomment-1206389311
function xonuto.dapui.open_in_tab()
  if debug_win and vim.api.nvim_win_is_valid(debug_win) then
    vim.api.nvim_set_current_win(debug_win)
    return
  end

  vim.cmd("tabedit %")
  debug_win = vim.fn.win_getid()
  debug_tab = vim.api.nvim_win_get_tabpage(debug_win)
  debug_tabnr = vim.api.nvim_tabpage_get_number(debug_tab)

  dapui.open()
end

function xonuto.dapui.close_tab()
  dapui.close()

  if debug_tab and vim.api.nvim_tabpage_is_valid(debug_tab) then
    vim.api.nvim_exec("tabclose " .. debug_tabnr, false)
  end

  debug_win = nil
  debug_tab = nil
  debug_tabnr = nil
end

function xonuto.dapui.toggle()
  if not debug_win then
    xonuto.dapui.open_in_tab()
  elseif vim.api.nvim_tabpage_get_number(0) ~= debug_tabnr then
    vim.api.nvim_set_current_tabpage(debug_tabnr)
  else
    xonuto.dapui.close_tab()
  end
end

local async = require("async")
local ufo = require("ufo")
function xonuto.foldfun()
  async(function()
    p(await(ufo.getFolds(vim.api.nvim_get_current_buf(), "lsp")))
  end)
end

function xonuto.fold_lvls()
  local lines = vim.fn.line("$")
  local foldlevel_start_stack = {}
  local foldranges = {}
  -- loop over all lines, get foldlevel of each line
  local last_foldlevel = 0
  for i = 1, lines do
    local foldlevel = vim.fn.foldlevel(i)
    -- assert(#foldlevel_starts == last_foldlevel)
    if foldlevel < last_foldlevel then
      for j = last_foldlevel, foldlevel + 1, -1 do
        local start = table.remove(foldlevel_start_stack)
        -- end range 1 before current line
        local range = { startLine = start, endLine = i - 1, level = j }
        table.insert(foldranges, range)
      end
    end
    if foldlevel > last_foldlevel then
      for j = last_foldlevel + 1, foldlevel do
        table.insert(foldlevel_start_stack, i)
      end
    end
    last_foldlevel = foldlevel
  end
  while #foldlevel_start_stack > 0 do
    local start = table.remove(foldlevel_start_stack)
    -- end range 1 before current line
    local range = { startLine = start, endLine = lines, level = last_foldlevel }
    table.insert(foldranges, range)
    last_foldlevel = last_foldlevel - 1
  end
  return foldranges
end

---@param level integer
function xonuto.fold_on_lvl_only(level)
  local foldranges = xonuto.fold_lvls()
  local filtered_ranges = vim.tbl_filter(function(range)
    return range.level == level + 1
  end, foldranges)
  xonuto.fold_line_ranges(filtered_ranges)
end

---@param line_ranges UfoFoldingRange[]
function xonuto.fold_line_ranges(line_ranges)
  local fold = require("ufo.fold")
  local bufnr = vim.api.nvim_get_current_buf()
  local fb = fold.get(bufnr)
  for _, range in ipairs(line_ranges) do
    fb:closeFold(range.startLine, range.endLine)
    vim.cmd(range.startLine .. "," .. range.endLine .. " foldclose")
  end
end

---@param bufnr integer
---@return nil|table
local function get_client(bufnr)
  local ret
  local last_priority = -1
  local client_info = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(client_info) do
    -- TODO: do I need priority?
    local priority = 10

    if client.server_capabilities.documentSymbolProvider and priority > last_priority then
      ret = client
      last_priority = priority
    end
  end
  return ret
end

---@return table|nil
function xonuto.get_buffer_symbols()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
  local client = get_client(bufnr)
  if not client then
    vim.notify("No LSP client found that supports symbols", vim.log.levels.WARN)
    return
  end
  local response
  local request_success = client.request("textDocument/documentSymbol", params, function(err, result)
    response = { err = err, result = result }
  end, bufnr)
  if not request_success then
    vim.notify("Error requesting document symbols", vim.log.levels.WARN)
  end
  local wait_result = vim.wait(4000, function()
    return response ~= nil
  end, 10)
  if not wait_result then
    vim.notify("Timeout waiting for document symbols", vim.log.levels.WARN)
    return
  end
  if response.err then
    vim.notify("Error requesting document symbols: " .. vim.inspect(response.err), vim.log.levels.WARN)
    return
  end
  return response.result
end

---@return UfoFoldingRange
local function lsp_range_to_lines(range)
  return { startLine = range.start.line + 1, endLine = range["end"].line + 1 }
end

-- returns all top level functions/methods from current buffer
---@return UfoFoldingRange[]
function xonuto.get_buffer_functions()
  local symbols = xonuto.get_buffer_symbols()
  -- 6 = Method, 12 = Function
  local allowed_symbols = { [6] = true, [12] = true }
  local ranges = {}
  local function traverse(symbol)
    if allowed_symbols[symbol.kind] then
      table.insert(ranges, lsp_range_to_lines(symbol.range))
      return
    end
    if symbol.children then
      for _, child in ipairs(symbol.children) do
        traverse(child)
      end
    end
  end

  traverse({ children = symbols })
  -- filter out ranges shorter than 3 lines
  ranges = vim.tbl_filter(function(range)
    return range.endLine - range.startLine >= 2
  end, ranges)
  -- remove last line from function range
  local function_ranges = vim.tbl_map(function(range)
    range.endLine = range.endLine - 1
    return range
  end, ranges)

  -- functions may include the docstring. So, find the most fitting folding range.
  local fold_ranges = xonuto.fold_lvls()
  local fitting_ranges = {}
  for _, range in ipairs(function_ranges) do
    local most_fitting
    for _, fold_range in ipairs(fold_ranges) do
      if
        fold_range.startLine >= range.startLine
        and (fold_range.endLine == range.endLine or fold_range.endLine == range.endLine + 1)
      then
        if not most_fitting or most_fitting.startLine > fold_range.startLine then
          most_fitting = fold_range
        end
      end
    end
    if most_fitting then
      table.insert(fitting_ranges, most_fitting)
    end
  end

  return fitting_ranges
end

function xonuto.fold_functions_ranges()
  local ranges = xonuto.get_buffer_functions()
  for _, range in ipairs(ranges) do
    print(range.startLine, range.endLine)
  end
end

function xonuto.fold_functions()
  local ranges = xonuto.get_buffer_functions()
  xonuto.fold_line_ranges(ranges)
end

local perfanno_running = false
function xonuto.toggle_perfanno()
  local perfanno_lua = require("perfanno.lua_profile")
  if not perfanno_running then
    perfanno_lua.start(1)
    perfanno_running = true
  else
    perfanno_lua.stop()
    xonuto.show_flamegraph(xonuto.dump_pretty_flamegraph())
    perfanno_running = false
  end
end
-- hint: to use this, the lua_profile from perfanno must be modified to include the traces in the object
function xonuto.dump_pretty_flamegraph(reverse)
  local traces = require("perfanno.lua_profile").traces
  local path = vim.fn.tempname()
  if not traces then
    vim.notify("No traces available", vim.log.levels.ERROR)
    return
  end
  -- open file
  local trace_str = {}
  for _, trace in ipairs(traces) do
    local frames = {}
    for _, frame in ipairs(trace.frames) do
      local name = frame.file
      if name then
        local plugin_path = frame.file:match("lua/(.+).lua$")
        if plugin_path then
          name = plugin_path:gsub("/", ".")
        else
          name = frame.file
        end
        if frame.symbol then
          name = name .. ":" .. frame.symbol
        end
      else
        name = frame.symbol or "unknown"
      end
      if frame.linenr then
        name = name .. ":" .. frame.linenr
      end
      table.insert(frames, name)
    end
    if not reverse then
      -- default is correct ordering
      frames = vim.fn.reverse(frames)
    end
    table.insert(trace_str, vim.fn.join(frames, ";") .. " " .. trace.count)
  end
  local file = io.open(path, "w")
  vim.notify(#trace_str .. " traces", vim.log.levels.Info)
  if not file then
    vim.notify("Could not open file to write flamegraph", vim.log.levels.ERROR)
    return
  end
  file:write(vim.fn.join(trace_str, "\n"))
  file:close()
  return path
end

function xonuto.show_flamegraph(path)
  local svg = vim.fn.tempname() .. ".svg"
  local cmd = "inferno-flamegraph " .. path .. " > " .. svg
  vim.fn.jobstart(cmd, {
    on_exit = function()
      vim.fn.jobstart("open " .. svg, { detach = true })
    end,
  })
end

function xonuto.dap_info()
  local dap = require("dap")
  dap.continue()
  dap.sessions()
  require("dap.ext.vscode")
end

-- returns true if the buffer should stay in the list
-- false if the buffer should not be loaded next time
function xonuto.project_buffer_filter(bufnr)
  local resession_filter = require("resession").default_buf_filter
  if not resession_filter(bufnr) then
    return false
  end

  local path = vim.api.nvim_buf_get_name(bufnr)
  if not path then
    return false
  end

  -- get file path of bufnr
  if path:match(".rustup") then
    return false
  end
  if path:match(".cargo") then
    return false
  end
  -- filter out files containing "node_modules"
  if path:match("node_modules") then
    return false
  end
  -- filter out files not in the current pwd
  if not path:match(vim.fn.getcwd()) then
    return false
  end

  -- otherwise, keep the buffer
  return true
end
