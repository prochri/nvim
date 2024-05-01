-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local home = os.getenv("HOME")
local keybinding_dir = home .. "/Seafile/Programming/Keybindings"
local keybind_build = function()
  vim.fn.jobstart({ "python3.11", keybinding_dir .. "/test.py" }, {
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

local ft_disable_kb = {
  default = {
    [100] = {
      "lsp_semantic_highlight",
    },
    [1000] = {
      -- "ts_highlight",
      "auto_format",
    },
  },
}

local disable_feature = {
  lsp_semantic_highlight = function(buf)
    for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = buf })) do
      vim.lsp.semantic_tokens.stop(buf, client.id)
    end
  end,
  ts_highlight = function(buf)
    local ts_config = require("nvim-treesitter.configs")
    for _, module in ipairs(ts_config.get_modules()) do
      vim.cmd("TSBufDisable " .. module)
    end
  end,
  auto_format = function(buf)
    local LazyUtils = require("lazyvim.util")
    if LazyUtils.format.enabled(buf) then
      LazyUtils.format.toggle(true)
    end
  end,
}

local function check_bigfile(event)
  local buf = event.buf
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if not ok or not stats then
    return
  end

  local rules = ft_disable_kb.default
  local filetype = vim.bo[buf].ft
  if ft_disable_kb[filetype] then
    rules = ft_disable_kb[filetype]
  end
  for max_filesize, value in pairs(rules) do
    if stats.size > max_filesize * 1024 then
      for _, feature in ipairs(value) do
        if disable_feature[feature] then
          disable_feature[feature](buf)
        end
      end
    end
  end
end
vim.api.nvim_create_augroup("large_file_size", {})
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "large_file_size",
  pattern = "*",
  -- enable wrap mode for json files only
  callback = check_bigfile,
})

local function on_dir_change(event)
  -- local ok, neogit = pcall(require, "neogit")
  -- if ok then
  --   neogit.dispatch_reset()
  -- end
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
    -- require("resession").load(opts.args)
    require("prochri.resession").load_or_switch(opts.args)
  end, {})
end

local get_managed_clients = function(arg)
  local lspconfig = require("lspconfig")
  local clients = {}
  for _, client in ipairs(lspconfig.util.get_managed_clients()) do
    if clients[client.name] == nil then
      clients[client.name] = {
        ids = { client.id },
        name = client.name,
      }
    else
      table.insert(clients[client.name].ids, client.id)
    end
  end
  clients = vim.tbl_map(function(client)
    return client.name
    -- return ("%s (%s)"):format(client.name, table.concat(client.ids, ", "))
  end, clients)
  table.sort(clients)
  return vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, clients)
end
vim.api.nvim_create_user_command("LspNameRestart", function(opts)
  local lspconfig = require("lspconfig")
  local args = vim.split(opts.args, " ")
  if #args == 0 then
    return
  end
  local clients = lspconfig.util.get_managed_clients()
  for _, client in ipairs(clients) do
    if client.name == args[1] then
      vim.cmd("LspRestart " .. client.id)
    end
  end
end, {
  complete = get_managed_clients,
  nargs = "?",
  desc = "Manually restart all clients with the given name",
})

local ok, osv = pcall(require, "osv")
if ok then
  vim.api.nvim_create_user_command("NeovimDebugeeServer", function()
    osv.launch({ port = 8086 })
  end, {})
end
-- cmdline helper: use
-- nvim --cmd 'let g:debugee=v:true'
-- To launch nvim with the debugee server immdeiately
if vim.g.debugee then
  print("launching debugee")
  osv.launch({ port = 8086 })
end
