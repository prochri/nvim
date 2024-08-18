local Util = require("lazyvim.util")

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(spec, old_opts)
      -- add full relative path to lualine
      local lualine_c = old_opts.sections.lualine_c
      local function mypretty_path(self)
        local path = vim.fn.expand("%:p") --[[@as string]]

        if path == "" then
          return ""
        end
        local root = Util.root.get({ normalize = true })
        local cwd = Util.root.cwd()

        if path:find(cwd, 1, true) == 1 then
          path = path:sub(#cwd + 2)
        else
          path = path:sub(#root + 2)
        end
        return path
      end
      lualine_c[#lualine_c] = mypretty_path
      return old_opts
    end,
  },
  {
    "akinsho/bufferline.nvim",
    enabled = true,
    opts = function(_, opts)
      -- only show if there are multiple tabs
      opts.options.mode = "tabs"
      return opts
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    opts = function(spec, opts)
      -- NOTE: not an override, but I need to require manually here
      local builtin = require("statuscol.builtin")
      return {
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
        },
      }
    end,
  },
  {
    "folke/noice.nvim",
    ---@param old_opts NoiceConfig
    opts = function(_, old_opts)
      if not old_opts.lsp then
        ---@diagnostic disable-next-line: inject-field
        old_opts.lsp = {}
      end
      if not old_opts.lsp.hover then
        old_opts.lsp.hover = {}
      end
      old_opts.lsp.hover.opts = {
        close = {
          keys = { "q", "<Esc>" },
        },
      }
      return old_opts
    end,
  },
  { import = "lazyvim.plugins.extras.ui.edgy" },
  {
    "folke/edgy.nvim",
    opts = function(_, opts)
      if not opts.animate then
        ---@diagnostic disable-next-line: inject-field
        opts.animate = {}
      end
      opts.animate.enabled = false
      -- opts.animate.cps = 180

      opts.left = vim.tbl_filter(function(item)
        return item.title ~= "Neo-Tree Git" and item.title ~= "Neo-Tree Buffers"
      end, opts.left)
      table.insert(opts.left, {
        title = "Overseer",
        ft = "OverseerList",
        pinned = true,
        open = "OverseerOpen",
      })
      return opts
    end,
    config = function(_, opts)
      require("edgy").setup(opts)
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      direction = "float",
      float_opts = {
        border = "none",
      },
    },
  },
  { "voldikss/vim-floaterm" },
  { "FabijanZulj/blame.nvim", opts = true },
  {
    "lewis6991/hover.nvim",
    config = function()
      -- require("hover").setup({
      --   init = function()
      --     -- Require providers
      --     require("hover.providers.lsp")
      --     require("hover.providers.gh")
      --     require("hover.providers.gh_user")
      --     -- require('hover.providers.jira')
      --     -- require("hover.providers.man")
      --     -- require('hover.providers.dictionary')
      --   end,
      --   preview_opts = {
      --     border = "none",
      --   },
      --   mouse_delay = 500,
      -- })
      -- vim.keymap.set("n", "<MouseMove>", function()
      --   require("hover").hover_mouse()
      -- end, { desc = "hover.nvim (mouse)" })
      -- vim.o.mousemoveevent = true
    end,
  },
  {
    "simnalamburt/vim-mundo",
    dependencies = {
      "kevinhwang91/nvim-fundo",
      opts = true,
      build = function()
        require("fundo").install()
      end,
    },
  },
  -- tasks
  {
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    opts = {
      task_list = {
        bindings = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<TAB>"] = "TogglePreview",
          ["q"] = "<cmd>q<cr>",
          ["<ESC>"] = "<cmd>wincmd p<cr>",
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      overseer.add_template_hook(nil, function(task_defn, util)
        p(task_defn)
      end)
      overseer.add_template_hook({ dir = os.getenv("HOME") .. "/Monorepo/Portal" }, function(task_defn, util)
        if task_defn.args[1] == "run" and task_defn.args[2] == "generate" then
          util.add_component(task_defn, { "prochri.on_complete_vim_cmd", vim_cmd = "LspNameRestart graphql" })
        end
      end)
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("bqf").setup({
        func_map = {
          pscrollup = "<C-u>",
          pscrolldown = "<C-d>",
          ptogglemode = "P",
          ptoggleauto = "p",
          ptoggleitem = "zp",
        },
      })
      local start_telescope = function()
        vim.cmd("cclose")
        require("telescope.builtin").quickfix()
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<C-t>",
            "<cmd>lua _G.prochri.start_telescope_qf()<cr>",
            { nowait = true, noremap = true }
          )
          vim.api.nvim_buf_set_keymap(0, "n", "<esc>", "<cmd>wincmd p<cr>", { nowait = true, noremap = true })
          -- -- let treesitter use bash highlight for zsh files as well
          -- require("nvim-treesitter.highlight").attach(0, "bash")
        end,
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    opts = {
      disable_commit_confirmation = true,
      integrations = {
        telescope = true,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = false,
          ["<M-h>"] = "actions.select_split",
        },
        view_options = {
          show_hidden = true,
        },
      })

      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { import = "lazyvim.plugins.extras.util.octo" },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = true,
      default_merge_method = "commit",
      picker = "telescope",
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Issues (Octo)" },
      { "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Octo)" },
      { "<leader>gp", desc = "+pull request (Octo)" },
      { "<leader>gpp", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
      { "<leader>gpP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
      { "<leader>gpc", "<cmd>Octo pr create<CR>", desc = "Create PR (Octo)" },
      { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Octo)" },
      { "<leader>gS", "<cmd>Octo search<CR>", desc = "Search (Octo)" },

      { "<leader>a", "", desc = "+assignee (Octo)", ft = "octo" },
      { "<leader>c", "", desc = "+comment/code (Octo)", ft = "octo" },
      { "<leader>l", "", desc = "+label (Octo)", ft = "octo" },
      { "<leader>i", "", desc = "+issue (Octo)", ft = "octo" },
      { "<leader>r", "", desc = "+react (Octo)", ft = "octo" },
      { "<leader>p", "", desc = "+pr (Octo)", ft = "octo" },
      { "<leader>v", "", desc = "+review (Octo)", ft = "octo" },
      { "@", "@<C-x><C-o>", mode = "i", ft = "octo", silent = true },
      { "#", "#<C-x><C-o>", mode = "i", ft = "octo", silent = true },
    },
    config = function(spec, opts)
      require("prochri.octo")
      require("octo").setup(opts)
    end,
  },

  "sindrets/diffview.nvim",
  {
    "fredeeb/tardis.nvim",
    depndencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = true,
  },
}
