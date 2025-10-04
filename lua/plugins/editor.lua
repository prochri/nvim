return {
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    submodules = false, -- not needed, submodules are required only for tests

    -- you can specify also another config if you want @prochri
    config = function()
      require("gx").setup({
        open_browser_app = "open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
        open_browser_args = {}, -- specify any arguments, such as --background for macOS' "open".
        handlers = {
          plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
          github = true, -- open github issues
          brewfile = true, -- open Homebrew formulaes and casks
          package_json = true, -- open dependencies from package.json
          search = true, -- search the web/selection on the web if nothing else is found
          go = true, -- open pkg.go.dev from an import statement (uses treesitter)
          rust = { -- custom handler to open rust's cargo packages
            name = "rust", -- set name of handler
            filetype = { "toml" }, -- you can also set the required filetype for this handler
            filename = "Cargo.toml", -- or the necessary filename
            handle = function(mode, line, _)
              local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

              if crate then
                return "https://crates.io/crates/" .. crate
              end
            end,
          },
        },
        handler_options = {
          search_engine = "duckduckgo", -- you can select between google, bing, duckduckgo, ecosia and yandex
          select_for_search = false, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link
          git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
          git_remote_push = true,
        },
      })
    end,
  },
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
    "shushtain/nvim-treesitter-incremental-selection",
    config = function()
      local tsis = require("nvim-treesitter-incremental-selection")

      ---@type TSIS.Config
      tsis.setup({
        ignore_injections = false,
        loop_siblings = false,
        fallback = false,
        quiet = false,
      })
      vim.keymap.set("n", "<CR>", tsis.init_selection)
      vim.keymap.set("v", "<CR>", tsis.increment_node)
      vim.keymap.set("v", "<BS>", tsis.decrement_node)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    -- disable mini.pairs as this is a replacement
    dependencies = {
      "nvim-mini/mini.pairs",
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
    "chrisgrieser/nvim-origami",
    enabled = true,
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = {
      pauseFoldsOnSearch = true,
      foldKeymaps = {
        setup = true,
        hOnlyOpensOnFirstColumn = true,
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    dependencies = {
      "kevinhwang91/promise-async",
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
  -- { "anuvyklack/hydra.nvim" },
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
