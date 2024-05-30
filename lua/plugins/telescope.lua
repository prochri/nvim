return {
  {
    "nvim-telescope/telescope.nvim",
    -- change some options
    opts = function(_, opts)
      local _, actions = pcall(require, "telescope.actions")
      opts.defaults.path_display = { "truncate" }
      opts.defaults.dynamic_preview_title = true
      opts.defaults.cache_picker = opts.defaults.cache_picker or {}
      opts.defaults.cache_picker.num_pickers = 100
      opts.pickers = {}
      opts.pickers.find_files = {}
      opts.pickers.find_files.hidden = false
      opts.pickers.commands = {
        theme = "ivy",
      }
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
      local ok, trouble = pcall(require, "trouble.sources.telescope")
      if ok then
        opts.defaults.mappings.i["<C-t>"] = trouble.open
        opts.defaults.mappings.n["<C-t>"] = trouble.open
      end
      opts.defaults.mappings.i["<D-v>"] = { "<C-r>+", type = "command" }
      local history = require("telescope-picker-history-action")
      opts.defaults.mappings.i["<C-,>"] = history.prev_picker
      opts.defaults.mappings.i["<C-.>"] = history.next_picker
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
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      { "tsakirist/telescope-lazy.nvim" },
      {
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        config = function()
          require("telescope").load_extension("smart_open")
          local config = require("smart-open").config
          config.match_algorithm = "fzf"
          config.show_scores = true
        end,
        dependencies = {
          "kkharji/sqlite.lua",
        },
      },
      {
        "jonarrien/telescope-cmdline.nvim",
      },
    },
    keys = function(_, keys)
      keys[#keys + 1] = { "<leader>sl", "<cmd>Telescope lazy<cr>", desc = "Lazy Plugins" }
      return keys
    end,
  },
  {
    dir = "~/git/telescope-picker-history-action",
    dependencies = { "nvim-telescope/telescope.nvim" },
    lazy = true,
    opts = true,
  },
  {
    dir = "~/git/telescope-all-recent.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim", "kkharji/sqlite.lua", "stevearc/dressing.nvim" },
    opts = {
      -- debug = true,
      pickers = {
        ["lazy#lazy"] = {
          disable = false,
          use_cwd = false,
        },
      },
      vim_ui_select = {
        kinds = {
          overseer_template = {
            use_cwd = true,
            prompt = "Task template",
            name_include_prompt = true,
          },
          overseer_task_options = {
            use_cwd = true,
            name_include_prompt = true,
          },
          resession_load = {
            use_cwd = false,
          },
          codeaction = {
            use_cwd = false,
          },
        },
        -- only fallback, if no kind exists or is found
        prompts = {
          ["Load session"] = {
            use_cwd = false,
          },
        },
      },
    },
  },
}
