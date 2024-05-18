return {
  { import = "lazyvim.plugins.extras.editor.harpoon2" },
  { "ojroques/nvim-bufdel" },
  {
    "stevearc/resession.nvim",
    config = function(_, opts)
      local resession = require("resession")
      resession.setup(opts)
      resession.add_hook("pre_load", function()
        if resession.get_current() then
          resession.save(resession.get_current())
        end
        local overseer = require("overseer")
        for _, task in pairs(overseer.list_tasks()) do
          task:dispose(true)
        end
      end)
      resession.add_hook("post_load", function()
        local ok, neogit = pcall(require, "neogit")
        if ok then
          neogit.dispatch_reset()
        end
        vim.opt.title = true
        vim.opt.titlestring = resession.get_current()
      end)
    end,
    opts = {
      autosave = {
        enabled = true,
        interval = 300,
        notify = true,
      },
      extensions = {
        overseer = {
          unique = true,
        },
      },
      buf_filter = function(bufnr)
        return require("prochri.resession").project_buffer_filter(bufnr)
      end,
    },
  },
}
