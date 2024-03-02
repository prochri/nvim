local resession = require("resession")

local M = {}

---@generic T
---@param socket string
---@param command string
local function nvr_command(socket, command)
  if socket == nil then
    return
  end
  local cmd = "nvr --servername " .. socket .. " -c '" .. command .. "'"
  local handle = io.popen(cmd)
  if handle == nil then
    return
  end
  handle:close()
end

---@generic T
---@param command string
---@param callback fun(handle: file*): T
---@return T result of the callback
local function with_process(command, callback)
  local handle = io.popen(command)
  ---@cast handle file*
  local result = callback(handle)
  handle:close()
  return result
end

---@generic T
---@param command string
---@param callback fun(line: string): T
---@return T result of the callback
local function with_process_line(command, callback)
  return with_process(command, function(handle)
    local stdout = handle:read("*a")
    return callback(stdout)
  end)
end

local nvr_get_session = "nvr --remote-expr 'luaeval(\"require[[resession]].get_current()\")' "

---@param name string
---@return boolean
local function switch_to_session(name)
  return with_process("nvr --serverlist", function(serverlist_handle)
    for line in serverlist_handle:lines() do
      local my_nvim = vim.api.nvim_get_vvar("servername")
      if my_nvim == line then
        goto continue
      end
      local found = with_process_line(nvr_get_session .. " --servername " .. line, function(session_name)
        return session_name:find(name)
      end)
      if found then
        nvr_command(line, "NeovideFocus")
        return true
      end
      ::continue::
    end
    return false
  end)
end

---@param name string?
function M.resession_load_or_switch(name)
  ---@param session string?
  local function load_or_switch(session)
    if not session then
      return
    end
    if session == resession.get_current() then
      print("skipping load because of same session")
      return
    end
    if not switch_to_session(session) then
      print("Could not find other nvim instance with " .. (session or "nil") .. " loading it here")
      resession.load(session)
    end
  end
  if name ~= nil then
    load_or_switch(name)
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
  vim.ui.select(sessions, select_opts, function(selected)
    load_or_switch(selected)
  end)
end

return M
