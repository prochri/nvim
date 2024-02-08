local Notifier = require("overseer.notifier")
local constants = require("overseer.constants")
local util = require("overseer.util")
local STATUS = constants.STATUS

---@type overseer.ComponentFileDefinition
local comp = {
  desc = "vim.cmd when task is completed",
  params = {
    statuses = {
      desc = "List of statuses to run the cmd on",
      type = "list",
      subtype = {
        type = "enum",
        choices = STATUS.values,
      },
      default = {
        STATUS.SUCCESS,
      },
    },
    vim_cmd = {
      desc = "Vim command to run",
      type = "string",
      default = "",
    },
  },
  constructor = function(params)
    if type(params.statuses) == "string" then
      params.statuses = { params.statuses }
    end
    local lookup = util.list_to_map(params.statuses)

    return {
      notifier = Notifier.new(),
      on_complete = function(self, task, status)
        if lookup[status] then
          vim.cmd(params.vim_cmd)
          local level = util.status_to_log_level(status)
          local message = string.format("'%s' finished.\nRunning vim cmd '%s'", task.name, params.vim_cmd)
          self.notifier:notify(message, level)
        end
      end,
    }
  end,
}
return comp
