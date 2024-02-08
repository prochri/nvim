_G.p = function(...)
  print(vim.inspect(...))
end
local telescope = require("telescope")
local sorters = require("telescope.sorters")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local state = require("telescope.state")
local conf = require("telescope.config").values

local cmdline = require("telescomp.cmdline")
local utils = require("telescomp.utils")
local fn = vim.fn
local startswith = vim.startswith
local tbl_map = vim.tbl_map

local seperator_chars = " .()/"

local function get_prefix(x, y)
  -- x = "'<,'>s", y = "substitute" -> "'<,'>"
  -- x = "vim.api.nv", y = "nvim_exec" -> "vim.api."
  if y == nil then
    return ""
  end
  local n = fn.strchars(x)
  if n == 0 then
    return x
  end
  for i = 0, n - 1 do
    if startswith(y, fn.strcharpart(x, i, n)) then
      return fn.strcharpart(x, 0, i)
    end
  end
  return x
end

-- prefix only
local function getcompletion(cmdline)
  local results = vim.fn.getcompletion(cmdline, "cmdline")
  local m = {}
  p(results)
  m.prefix = get_prefix(cmdline, results[1])
  m.remaining = cmdline:sub(m.prefix:len() + 1)

  m.results = vim.fn.getcompletion(m.prefix, "cmdline")

  return m
end

local function get_telescope_picker(cl)
  local cmp = getcompletion(cl)
  print("starting from command line", cl)
  pickers
    .new({
      finder = finders.new_table({ results = cmp.results }),
      sorter = conf.generic_sorter({}),
      prompt_title = "Command completion " .. cmp.prefix,
      prompt_prefix = ":" .. cmp.prefix,
      default_text = cmp.remaining,
      attach_mappings = function(prompbufnr, _)
        actions.select_default:replace(function()
          actions.close(prompbufnr)
          local picker = action_state.get_current_picker(prompbufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            selection = selection[1]
          else
            selection = action_state.get_current_line()
          end
          get_telescope_picker(cmp.prefix .. selection)
          -- p(action_state.get_current_line())
          -- print('hello form: ', prompbufnr)
          -- p(action_state.get_current_picker(prompbufnr))
          -- print('hello form: ', prompbufnr)
        end)
        return true
      end,
    }, {})
    :find()
end

local cl = "lua v"

p(getcompletion(cl))
get_telescope_picker(cl)
