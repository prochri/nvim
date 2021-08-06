local telescope_builtin = require 'telescope.builtin'
require'telescope'.load_extension('project')
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local sorters = require 'telescope.sorters'
local actions = require 'telescope.actions'

-- TODO bat theme based on current theme

actions.close_empty = function(...)
  -- TODO maybe close only on empty input
  actions.close(...)
end

function telescope_builtin.generic(cmd, opts)
  local itemLister = cmd[1]
  local openAction = cmd[2]
  local prompt = cmd[3] or 'Generic List'
  itemLister = vim.fn[itemLister]

  pickers.new(opts, {
    prompt_title = prompt,
    finder = finders.new_table(itemLister()),
    sorter = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(
        function ()
          local item = actions.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)

          vim.cmd(openAction..' '..item[1])
        end)
      return true
    end
  }):find()
end

function telescope_builtin.projects(opts)
  local session_lister = vim.fn['prosession#ListSessions']
  pickers.new(opts, {
    prompt_title = 'Projects ',
    finder = finders.new_table(session_lister()),
    sorter = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(
        function()
          local selection = actions.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)

          vim.cmd('Prosession '..selection[1])
        end)
      return true
    end
  }):find()
end



require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close_empty,
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous,
      }
    }
  }
}
