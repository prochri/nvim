local resession = require("resession")
local nio = require("nio")

local M = {}

--- async: awaits the result of the callback
---@generic T
---@param socket string
---@param command string
local function nvr_command(socket, command)
  if socket == nil then
    return
  end
  local cmd = { cmd = "nvr", args = { "--servername", socket, "-c", command } }
  local process = nio.process.run(cmd)
  if process == nil then
    return
  end
  process.result(true)
end

---@param name string
---@return boolean
local function switch_to_session(name)
  local p = nio.process.run({ cmd = "nvr", args = { "--serverlist" } })
  if p == nil then
    return false
  end
  local output, err = p.stdout.read()
  if not output or err then
    return false
  end
  -- split string on newlines
  local lines = vim.split(output, "\n")
  local processes = vim.tbl_map(
    function(line)
      return {
        process = nio.process.run({
          cmd = "nvr",
          args = { "--servername", line, "--remote-expr", 'luaeval("require[[resession]].get_current()")' },
        }),
        servername = line,
      }
    end,
    vim.tbl_filter(function(line)
      return line ~= ""
    end, lines)
  )
  local target_server
  nio.first({
    function()
      nio.sleep(500)
    end,
    function()
      nio.gather(vim.tbl_map(function(p)
        return function()
          local out, err = p.process.stdout.read()
          if err then
            return
          end
          out = out:gsub("\n", "")
          print("found nvim instance", out, name)
          if name == out then
            target_server = p.servername
          end
        end
      end, processes))
    end,
  })
  for _, p in ipairs(processes) do
    p.process.signal("sigint")
  end
  if target_server then
    nvr_command(target_server, "NeovideFocus")
    return true
  end
  return false
end

function M.load_in_new_neovide(session_name)
  local cmd = [[!open -n /Applications/Neovide.app  --args -- -c "lua require'resession'.load(']]
    .. session_name
    .. [[')"]]
  vim.schedule(function()
    vim.cmd(cmd)
  end)
end

---@param name string?
---@param replace_current boolean? default: false
function M.load_or_switch(name, replace_current)
  local current = resession.get_current()
  nio.run(function()
    ---@param session string?
    local function load_or_switch(session)
      if not session then
        return
      end
      if session == current then
        return
      end
      if not switch_to_session(session) then
        if current and not replace_current then
          M.load_in_new_neovide(session)
          return
        end
        -- NOTE: needed, as it must be save to access nvim api functions
        vim.schedule(function()
          resession.load(session)
        end)
      end
    end
    if name ~= nil then
      load_or_switch(name)
      return
    end
    local sessions = resession.list()
    if vim.tbl_isempty(sessions) then
      vim.notify("No saved sessions", vim.log.levels.WARN)
      return
    end
    local select_opts = { kind = "resession_load", prompt = "Load session" }
    local config = require("resession.config")
    local files = require("resession.files")
    local util = require("resession.util")
    if config.load_detail then
      local session_data = {}
      for _, session_name in ipairs(sessions) do
        local filename = util.get_session_file(session_name, nil)
        local data = files.load_json_file(filename)
        session_data[session_name] = data
      end
      select_opts.format_item = function(session_name)
        local data = session_data[session_name]
        local formatted = session_name
        if data then
          if data.tab_scoped then
            local tab_cwd = data.tabs[1].cwd
            formatted = formatted .. string.format(" (tab) [%s]", util.shorten_path(tab_cwd))
          else
            formatted = formatted .. string.format(" [%s]", util.shorten_path(data.global.cwd))
          end
        end
        return formatted
      end
    end
    local selected = nio.ui.select(sessions, select_opts)
    load_or_switch(selected)
  end)
end

---returns true if the buffer should stay in the list
---false if the buffer should not be loaded next time
function M.project_buffer_filter(bufnr)
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

return M
