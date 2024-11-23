---@see https://github.com/LazyVim/LazyVim/pull/2198
return {
  { import = "lazyvim.plugins.extras.lang.rust" },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        load_vscode_settings = true,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      },
    },
    --   function(spec, opts)
    --   opts.server.load_vscode_settings = true
    --   return opts
    -- end,
  },
}
