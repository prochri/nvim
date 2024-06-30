return {
  {
    "kylechui/nvim-surround",
    opts = {
      keymaps = {
        -- s in visual is the same as c, so just rebind it for easier access
        visual = "s",
      },
    },
    -- override flash accordingly
    dependencies = {
      "folke/flash.nvim",
      -- deactivate it, it is shitty for t and f, fucks up macros and the s to snipe does not work as expected
      enabled = false,
      keys = function()
        -- stylua: ignore
        local new_keys = {
          { "s",     mode = { "n" },      function() require("flash").jump() end,              desc = "Flash" },
          { "z",     mode = { "o", "x" }, function() require("flash").jump() end,              desc = "Flash" },
          { "S",     mode = { "n" },      function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
          { "Z",     mode = { "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
          { "r",     mode = { "o" },      function() require("flash").remote() end,            desc = "Remote Flash" },
          { "R",     mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
          { "<c-s>", mode = { "c" },      function() require("flash").toggle() end,            desc =
          "Toggle Flash Search" },
        }
        return new_keys
      end,
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    -- disable mini.pairs as this is a replacement
    dependencies = {
      "echasnovski/mini.pairs",
      enabled = false,
    },
  },
  {
    "Wansmer/sibling-swap.nvim",
    opts = {
      use_default_keymaps = false,
    },
    -- stylua: ignore
    keys = {
      { "<M-h>", function() require("sibling-swap").swap_with_left() end, mode = { "n", "v" }, },
      { "<M-l>", function() require("sibling-swap").swap_with_right() end, mode = { "n", "v" }, },
    },
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },
  {
    "LunarVim/bigfile.nvim",
    opts = {
      features = {
        "treesitter",
        "syntax",
      },
    },
  },
  {
    -- TODO: hide it if overlap
    "b0o/incline.nvim",
    config = function()
      require("incline").setup()
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "chrisgrieser/nvim-origami",
        event = "BufReadPost", -- later or on keypress would prevent saving folds
        opts = {
          pauseFoldsOnSearch = true,
          keepFoldsAcrossSessions = false,
          setupFoldKeymaps = false,
        },
      },
    },
    config = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
      require("ufo").setup({
        fold_virt_text_handler = function(text, lnum, endLnum, width)
          -- local suffix = "  "
          local suffix = " >>"
          local lines = ("(%d lines) "):format(endLnum - lnum)

          local cur_width = 0
          for _, section in ipairs(text) do
            cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
          end

          suffix = suffix .. (" "):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 3)

          table.insert(text, { suffix, "Comment" })
          table.insert(text, { lines, "Todo" })
          return text
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(spec, opts)
      opts.current_line_blame = true
      return opts
    end,
  },
  { "anuvyklack/hydra.nvim" },
  { "tpope/vim-rsi" },
  {
    "gw31415/deepl-commands.nvim",
    dependencies = {
      "gw31415/deepl.vim",
    },
    opts = function()
      vim.g.deepl_authkey = vim.fn.getenv("DEEPL_API_KEY")
      return {}
    end,
  },
  {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
  },
}
