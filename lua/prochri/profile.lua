local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  -- TODO: make this work with lazyvim
  require("profile").instrument_autocmds()
  if should_profile:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
end

local function toggle_profile()
  local prof = require("profile")
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format("Wrote %s", filename))
      end
    end)
  else
    prof.start("*")
  end
end

local profiling_plenary_running = false
local filename = "/tmp/neovim_profile.log"
local function toggle_profile2()
  local profile = require("plenary.profile")
  if profiling_plenary_running then
    profile.stop()
    profiling_plenary_running = false
    vim.cmd("silent! !inferno-flamegraph " .. filename .. " > /tmp/neovim_profile.svg")
    vim.cmd("silent! !open /tmp/neovim_profile.svg")
  else
    profile.start(filename, { flame = true })
    profiling_plenary_running = true
  end
end

vim.keymap.set("", "<f1>", toggle_profile)
vim.keymap.set("", "<f2>", toggle_profile2)
