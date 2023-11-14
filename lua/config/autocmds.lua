-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local home = os.getenv("HOME")
local keybinding_dir = home .. "/Seafile/Programming/Keybindings"
local keybind_build = function()
  vim.fn.jobstart({ "python3", keybinding_dir .. "/test.py" }, {
    cwd = keybinding_dir,
    stdout_buffered = true,
    on_stdout = function(_, data, _)
      for _, value in ipairs(data) do
        print(value)
      end
      local ok, val = pcall(require, "lvim.config")
      if ok then
        val:reload()
      end
      package.loaded["config.which-key"] = nil
      require("config.which-key")
    end,
  })
end

vim.api.nvim_create_augroup("keybinding_reloading", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "keybinding_reloading",
  pattern = { keybinding_dir .. "/*.yml", keybinding_dir .. "/*.yaml" },
  -- enable wrap mode for json files only
  callback = keybind_build,
})

local function on_dir_change(event)
  -- pcall require neogit
  local ok, neogit = pcall(require, "neogit")
  if ok then
    print("reset git")
    neogit.dispatch_reset()
  end
  -- reinit
  p(event)
  print("changed dir!!!")
end

vim.api.nvim_create_augroup("detect_dir_change", {})
vim.api.nvim_create_autocmd("DirChanged", {
  group = "detect_dir_change",
  pattern = "*",
  callback = on_dir_change,
})

local function load_dap_launch_json()
  local dap_ext = require("dap.ext.vscode")
  dap_ext.load_launchjs(nil, { lldb = { "rust" } })
end

-- I did not find any way to do this on a autocommand
-- load_dap_launch_json()
-- local dap_group = "DAP_Autocmds"
-- vim.api.nvim_create_augroup(dap_group, {})
-- vim.api.nvim_create_autocmd({ "DirChanged" }, {
--   group = dap_group,
--   pattern = "*",
--   callback = load_dap_launch_json,
-- })

local resession_group = "resession"
vim.api.nvim_create_augroup(resession_group, {})
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = resession_group,
  callback = function()
    local ok, resession = pcall(require, "resession")
    if not ok then
      return
    end
    -- resession.save("last")
    local current = resession.get_current()
    if current then
      resession.save(current)
    end
  end,
})
-- NOTE: for now we leave user commands here
local ok, resession = pcall(require, "resession")
if ok then
  vim.api.nvim_create_user_command("ResessionSave", function(opts)
    opts.args = vim.trim(opts.args)
    if opts.args == "" then
      opts.args = nil
    end
    resession.save(opts.args)
  end, {})
  vim.api.nvim_create_user_command("ResessionLoad", function(opts)
    opts.args = vim.trim(opts.args)
    if opts.args == "" then
      opts.args = nil
    end
    resession.load(opts.args)
  end, {})
end

local ok, osv = pcall(require, "osv")
if ok then
  vim.api.nvim_create_user_command("NeovimDebugeeServer", function()
    osv.launch({ port = 8086 })
  end, {})
end
