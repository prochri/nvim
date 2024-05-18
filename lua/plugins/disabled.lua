return {
  {
    "smjonas/inc-rename.nvim",
    enabled = false,
    opts = true,
  },
  {
    "stevearc/aerial.nvim",
    enabled = false,
    opts = true,
  },
  {
    "glepnir/lspsaga.nvim",
    enabled = false,
    opts = {
      symbol_in_winbar = { enable = false },
      lightbulb = {
        enable = false,
        sign = true,
        virtual_text = false,
        update_time = 500,
      },
    },
  },
  {
    "kr40/nvim-macros",
    enabled = false,
    cmd = { "MacroSave", "MacroYank", "MacroSelect", "MacroDelete" },
    opts = {
      json_file_path = vim.fs.normalize(vim.fn.stdpath("config") .. "/macros.json"), -- Location where the macros will be stored
      default_macro_register = "q", -- Use as default register for :MacroYank and :MacroSave and :MacroSelect Raw functions
      json_formatter = "none", -- can be "none" | "jq" | "yq" used to pretty print the json file (jq or yq must be installed!)
    },
  },
  {
    "notomo/gesture.nvim",
    enabled = false,
    config = function()
      vim.keymap.set("n", "<M-LeftMouse>", "<LeftMouse>", { silent = true })
      vim.keymap.set("n", "<M-LeftDrag>", [[<Cmd>lua require("gesture").draw()<CR>]], { silent = true })
      vim.keymap.set("n", "<M-LeftRelease>", [[<Cmd>lua require("gesture").finish()<CR>]], { silent = true })
      local gesture = require("gesture")
      gesture.register({
        name = "scroll to top",
        inputs = { gesture.up(), gesture.down() },
        action = "normal! gg",
      })
      gesture.register({
        name = "scroll to bottom",
        inputs = { gesture.down(), gesture.up() },
        action = "normal! G",
      })
      gesture.register({
        name = "File tree",
        inputs = { gesture.left() },
        action = "Neotree toggle",
      })
      gesture.register({
        name = "Close window",
        inputs = { gesture.right(), gesture.left() },
        action = "hide",
      })
      gesture.register({
        name = "Close window",
        inputs = { gesture.left(), gesture.right() },
        action = "hide",
      })
      gesture.register({
        name = "quickfix",
        inputs = { gesture.down() },
        action = function()
          local winnr = vim.fn.winnr("$")
          vim.cmd([[cclose]])
          if winnr == vim.fn.winnr("$") then
            vim.cmd([[copen]])
          end
        end,
      })
      gesture.register({
        name = "vsplit",
        inputs = { gesture.right() },
        action = "vsplit",
      })
      gesture.register({
        name = "split",
        inputs = { gesture.up() },
        action = "split",
      })
    end,
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    enabled = false,
    config = function()
      require("lsp_lines").setup()
      require("lsp_lines").toggle()

      -- vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
    end,
  },
}
