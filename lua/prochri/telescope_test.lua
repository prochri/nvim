_G.p = function(...) print(vim.inspect(...)) end
local telescope = require "telescope"
local sorters = require "telescope.sorters"
local pickers = require "telescope.pickers"
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local state = require "telescope.state"

local cmdline = require 'telescomp.cmdline'
local utils = require 'telescomp.utils'
local fn = vim.fn
local startswith = vim.startswith
local tbl_map = vim.tbl_map

local function getcompletion(opts_comp, include_default_text)
  local left = opts_comp.left
  local default_text = opts_comp.default_text
  local completion_search = left
  if include_default_text then
    completion_search = left .. default_text
  end

  local completion = fn.getcompletion(completion_search, 'cmdline')

  if startswith(left, 'set') and startswith(default_text, 'no') then
    return tbl_map(function(x) return 'no' .. x end, completion)
  end

  return completion
end

local function get_prefix(x, y)
  -- x = "'<,'>s", y = "substitute" -> "'<,'>"
  -- x = "vim.api.nv", y = "nvim_exec" -> "vim.api."
  if y == nil then return '' end
  local n = fn.strchars(x)
  if n == 0 then return x end
  for i = 0, n - 1 do
    if startswith(y, fn.strcharpart(x, i, n)) then
      return fn.strcharpart(x, 0, i)
    end
  end
  return x
end

local _complete = cmdline.create_completer({
  opts_picker = { finder = function() return { results = {} } end }
})

function _G.mycmdcmp(opts_picker, opts_comp)
  -- print('hello wrold uwuuuuuuuuuuuuuuuuuu')

  -- setup opts_comp
  opts_comp = cmdline.spec_completer_options(opts_comp)
  -- p(opts_comp)
  local helper_results = getcompletion(opts_comp, true)

  -- print('helper results')
  -- p(helper_results)
  local complete_prefix = opts_comp.left .. opts_comp.default_text
  opts_comp.left = get_prefix(complete_prefix, helper_results[1])
  opts_comp.default_text = string.sub(complete_prefix, opts_comp.left:len() + 1)
  -- p(opts_comp)

  -- find candidates and setup opts_picker
  local results = getcompletion(opts_comp, false)

  opts_picker = utils.merge(
    {
      prompt_title = 'Complete cmdline (' .. opts_comp.cmdcompltype .. ')',
      finder = require('telescope.finders').new_table({ results = results })
    },
    opts_picker
  )

  opts_picker.prompt_prefix = opts_comp.cmdtype .. opts_comp.left
  -- p(opts_comp)


  _complete(opts_picker, opts_comp)
end
