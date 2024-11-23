return {
  { import = "lazyvim.plugins.extras.lang.sql" },
  {
    "kristijanhusak/vim-dadbod-ui",
    config = function()
      vim.g.db_ui_execute_on_save = true
    end,
  },
  "tpope/vim-dotenv",
  -- "tpope/vim-dadbod",
  -- dependencies = {
  --   "kristijanhusak/vim-dadbod-ui",
  --   {
  --     "kristijanhusak/vim-dadbod-completion",
  --     config = function()
  --       require("cmp").setup.filetype({ "sql" }, {
  --         sources = {
  --           { name = "vim-dadbod-completion" },
  --           { name = "buffer" },
  --           { name = "git" },
  --         },
  --       })
  --     end,
  --   },
  -- },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     if type(opts.ensure_installed) == "table" then
  --       vim.list_extend(opts.ensure_installed, { "sql" })
  --     end
  --   end,
  -- },
  -- {
  --   "kndndrj/nvim-dbee",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     -- for loading the DBEE_CONNECTIONS env variable from .env files
  --     "tpope/vim-dotenv",
  --     -- {
  --     --   "MattiasMTS/cmp-dbee",
  --     --   ft = "sql",
  --     --   opts = {},
  --     -- },
  --   },
  --   build = function()
  --     -- Install tries to automatically detect the install method.
  --     -- if it fails, try calling it with one of these parameters:
  --     --    "curl", "wget", "bitsadmin", "go"
  --     require("dbee").install()
  --   end,
  --   config = function()
  --     require("dbee").setup({
  --       sources = {
  --         require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
  --       },
  --     })
  --     local original = require("dbee").open
  --     require("dbee").open = function(...)
  --       vim.fn.setenv("DBEE_CONNECTIONS", vim.fn.DotenvGet("DBEE_CONNECTIONS"))
  --       original(...)
  --     end
  --   end,
  -- },
}
