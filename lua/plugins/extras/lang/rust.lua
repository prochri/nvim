---@see https://github.com/LazyVim/LazyVim/pull/2198
return {
  { import = "lazyvim.plugins.extras.lang.rust" },
  {
    "mrcjkb/rustaceanvim",
    opts = function(spec, opts)
      opts.server.load_vscode_settings = true
      opts.server.capabilities = vim.lsp.protocol.make_client_capabilities()
      -- opts.server.default_settings["rust-analyzer"].procMacro.ignored = {}
      return opts
    end,
    --   function(spec, opts)
    --   opts.server.load_vscode_settings = true
    --   return opts
    -- end,
  },
}
