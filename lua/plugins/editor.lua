return {
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "ggandor/flit.nvim",
    enabled = false,
    keys = function()
      ---@type LazyKeysSpec[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" } }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  {
    "ggandor/leap.nvim",
    enabled = true,
    keys = {
      { "s", "<Plug>(leap-forward)", mode = { "n" }, desc = "Leap Forward" },
      { "S", "<Plug>(leap-backward)", mode = { "n" }, desc = "Leap Backward" },
      { "z", "<Plug>(leap-forward)", mode = { "x", "o" }, desc = "Leap Forward" },
      { "Z", "<Plug>(leap-backward)", mode = { "x", "o" }, desc = "Leap Backward" },
      { "gs", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
    end,
  },
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
  -- {
  --   "LunarVim/bigfile.nvim",
  --   opts = {
  --     features = {
  --       "treesitter",
  --       "syntax",
  --     },
  --   },
  -- },
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
    "hesom/multihover.nvim",
    config = function()
      require("multihover").setup({
        include_diagnostics = true,
        show_titles = false,
        popup_config = {
          focusable = true,
          focus_id = "textDocument/hover",
        },
      })
      vim.lsp.buf.hover = require("multihover").hover
    end,
  },
  {
    "lewis6991/hover.nvim",
    enabled = false,
    config = function()
      require("hover").setup({
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.gh_user")
          -- require('hover.providers.jira')
          require("hover.providers.dap")
          require("hover.providers.fold_preview")
          require("hover.providers.diagnostic")
          -- require('hover.providers.man')
          -- require('hover.providers.dictionary')
        end,
        preview_opts = {
          border = "none",
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = true,
        title = true,
        mouse_providers = {
          "LSP",
        },
        mouse_delay = 1000,
      })

      -- Setup keymaps
      vim.keymap.set("n", "K", function(opts)
        prochri.smart_hover(opts)
      end, { desc = "hover.nvim" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
      vim.keymap.set("n", "<C-p>", function()
        require("hover").hover_switch("previous")
      end, { desc = "hover.nvim (previous source)" })
      vim.keymap.set("n", "<C-n>", function()
        require("hover").hover_switch("next")
      end, { desc = "hover.nvim (next source)" })

      -- Mouse support
      vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
      vim.o.mousemoveevent = true
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(spec, opts)
      opts.current_line_blame = true
      return opts
    end,
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
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
