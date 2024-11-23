---@module 'noice'
vim.defer_fn(function()
  vim.cmd([[set cmdheight=1]])
end, 1000)

local experimental_cmp = false

return {
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  -- { "rcarriga/nvim-notify", enabled = false },
  {
    "folke/noice.nvim",
    enabled = false,
    opts = function(_, opts)
      opts.presets.bottom_search = false
      ---@type NoiceRouteConfig[]
      local routes = {
        {
          view = "notify",
          filter = {
            event = "notify",
            kind = "error",
            find = "vtsls.*inlayHint",
          },
          opts = {
            skip = true,
          },
        },
      }
      for _, route in ipairs(routes) do
        table.insert(opts.routes, route)
      end
      return opts
    end,
  },
  -- { "folke/trouble.nvim", enabled = false },
  {
    "echasnovski/mini.ai",
    opts = function(_, opts)
      local ai = require("mini.ai")
      opts.custom_textobjects.f = opts.custom_textobjects.u
      opts.custom_textobjects.F = opts.custom_textobjects.U
      opts.custom_textobjects.c = opts.custom_textobjects.u
      opts.custom_textobjects.C = opts.custom_textobjects.U
      -- opts.custom_textobjects.t = ai.gen_spec.treesitter({
      --   a = "@jsxtag.outer",
      --   i = "@jsxtag.inner",
      -- })
      opts.search_method = "cover"
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "storm",
      light_style = "day",
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify", "OverseerList", "edgy" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },
    keys = function(spec, old_keys)
      table.remove(old_keys)
      table.remove(old_keys)
      table.insert(old_keys, { "<leader>ft", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true })
      table.insert(old_keys, { "<leader>fT", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- keys[#keys + 1] = { "K", "<cmd>lua _G.prochri.smart_hover()<cr>" }
      keys[#keys + 1] = { "K", false }
    end,
    -- opts = function(_spec, opts)
    --   opts.inlay_hints = {
    --     enabled = true,
    --   }
    --   return opts
    -- end,
  },
  { import = "lazyvim.plugins.extras.coding.luasnip" },
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    enabled = not experimental_cmp,
    -- branch = "perf",
    dependencies = { "hrsh7th/cmp-emoji", { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" } } },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      opts.experimental = {
        ghost_text = false,
      }
      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" }, { name = "git" } }))
      opts.sources = vim.list_extend(opts.sources, { { name = "emoji" }, { name = "git" } })
      opts.mapping["<C-j>"] =
        cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" })
      opts.mapping["<C-k>"] =
        cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" })
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }
          local is_insert_mode = function()
            ---@diagnostic disable-next-line: undefined-field
            return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          end
          if is_insert_mode() then -- prevent overwriting brackets
            confirm_opts.behavior = cmp.ConfirmBehavior.Insert
          end
          if cmp.confirm(confirm_opts) then
            return -- success, exit early
          end
        end
        fallback() -- if not exited early, always fallback
      end)
      opts.mapping["<C-h>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.abort()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end)
      opts.mapping["<C-Enter>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert })
        else
          fallback()
        end
      end)
      opts.mapping["<C-l>"] = cmp.mapping(function(_)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        end
      end)
      opts.mapping["<C-d>"] = cmp.mapping.scroll_docs(4)
      opts.mapping["<C-u>"] = cmp.mapping.scroll_docs(-4)
      opts.mapping["<CR>"] = nil
    end,
    init = function(_)
      require("cmp_git").setup({
        filetypes = { "NeogitCommitMessage" },
      })
      require("cmp").setup.filetype({ "sql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "cmp-dbee" },
          { name = "buffer" },
          { name = "git" },
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    enabled = experimental_cmp,
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",

    -- use a release tag to download pre-built binaries
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",

      -- experimental auto-brackets support
      accept = { auto_brackets = { enabled = true } },

      -- experimental signature help support
      trigger = { signature_help = { enabled = true } },

      windows = {
        documentation = {
          auto_show = true,
          auto_show_delay = 100,
        },
      },
      keymap = {
        select_next = { "<Down>", "<C-j>" },
        select_prev = { "<Up>", "<C-k>" },
        scroll_documentation_down = { "<C-d>" },
        scroll_documentation_up = { "<C-u>" },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "./snippets" },
      })
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "~/.config/nvim/snippets" },
      })
    end,
    keys = function(_, _)
      return {
        {
          "<C-h>",
          function()
            print("jumpable back", require("luasnip").jumpable(-1))
            require("luasnip").jump(-1)
          end,
          mode = "s",
        },
        {
          "<C-l>",
          function()
            require("luasnip").jump(1)
          end,
          mode = "s",
        },
      }
    end,
  },
}
