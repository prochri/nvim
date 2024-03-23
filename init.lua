_G.p = function(...)
  print(vim.inspect(...))
end

if vim.fn.exists("g:neovide") == 1 then
  vim.cmd([[cd ~/]])
end

local function setenv(env, value)
  if os.getenv(env) == nil then
    vim.fn.setenv(env, value)
  end
end

vim.fn.setenv("VISUAL", "nvr -l")
vim.fn.setenv("EDITOR", "nvr -l")
vim.fn.setenv("NODE_OPTIONS", "--max_old_space_size=8192")
vim.fn.setenv("TSS_LOG", "-level trace -file /Users/christophprobst/tmp/tss/tss.log")
-- load secret environment variables, but do not fail.
pcall(dofile, os.getenv("HOME") .. "/.config/nvim/secrets.lua")

-- TODO: detect dark mode on startup
local function dark_mode_macos()
  vim.fn.jobstart({ "dark-mode", "status" }, {
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if line == "off" then
          vim.cmd("set background=light")
        end
        if line == "on" then
          vim.cmd("set background=dark")
        end
      end
    end,
  })
end
pcall(dark_mode_macos)
local guifont = "JetbrainsMono Nerd Font Mono"

if string.find(vim.o.guifont, guifont) == nil then
  vim.o.guifont = guifont .. ":h15"
end
vim.g.neovide_transparency = 1
vim.g.neovide_remember_window_size = true
vim.g.neovide_remember_window_position = true
vim.g.neovide_scale_factor = 1
vim.g.neovide_input_macos_alt_is_meta = true
-- vim.g.neovide_remember_window_size = false

local lunarvim = false
if lunarvim then
  setenv("XDG_DATA_HOME", os.getenv("APPDATA"))
  setenv("XDG_CONFIG_HOME", os.getenv("LOCALAPPDATA"))
  setenv("XDG_CACHE_HOME", os.getenv("TEMP"))

  setenv("LUNARVIM_RUNTIME_DIR", os.getenv("XDG_DATA_HOME") .. "/lunarvim")
  setenv("LUNARVIM_CONFIG_DIR", os.getenv("XDG_CONFIG_HOME") .. "/lvim")
  setenv("LUNARVIM_CACHE_DIR", os.getenv("XDG_CACHE_HOME") .. "/lvim")
  setenv("LUNARVIM_BASE_DIR", os.getenv("LUNARVIM_RUNTIME_DIR") .. "/lvim")

  dofile(os.getenv("LUNARVIM_BASE_DIR") .. "/init.lua")
else
  --- lazyvim
  require("prochri.profile")
  require("config.lazy")
end
