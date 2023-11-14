return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "storm",
      light_style = "day",
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
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
      -- keys[#keys + 1] = { "K", "<cmd>lua _G.xonuto.smart_hover()<cr>" }
      keys[#keys + 1] = { "K", false }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/playground" },
    opts = function(_, opts)
      opts.playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    -- change some options
    opts = function(_, opts)
      local _, actions = pcall(require, "telescope.actions")
      opts.defaults.path_display = { "truncate" }
      opts.pickers = {}
      opts.pickers.find_files = {}
      opts.pickers.find_files.hidden = false
      opts.pickers.commands = {
        theme = "ivy",
      }
      p(opts.previewers)
      -- opts.pickers.lsp_definitions = {
      --   theme = "cursor",
      -- }
      -- opts.pickers.lsp_references = {
      --   theme = "cursor",
      -- }
      opts.pickers.buffers = {}
      opts.pickers.buffers.initial_mode = "insert"
      opts.pickers.buffers.mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["<C-d>"] = actions.delete_buffer,
          ["dd"] = actions.delete_buffer,
        },
      }
      opts.defaults.mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<PageUp>"] = actions.cycle_history_prev,
          ["<PageDown>"] = actions.cycle_history_next,
          ["<ESC>"] = actions.close,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<PageUp>"] = actions.cycle_history_prev,
          ["<PageDown>"] = actions.cycle_history_next,
        },
      }
      local ok, trouble = pcall(require, "trouble.providers.telescope")
      if ok then
        opts.defaults.mappings.i["<C-t>"] = trouble.open_with_trouble
        opts.defaults.mappings.n["<C-t>"] = trouble.open_with_trouble
      end
      opts.extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      }
      opts.defaults = require("telescope.themes").get_ivy(opts.defaults)
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "./snippets" },
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
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      opts.experimental = {
        ghost_text = false,
      }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
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
      opts.mapping["<C-l>"] = cmp.mapping(function(_)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        end
      end)
      opts.mapping["<CR>"] = nil
    end,
  },
}
