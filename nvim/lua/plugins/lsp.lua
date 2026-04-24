return {
  -- 1. The Package Manager (Install LSPs)
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- 2. The Bridge (Automatic Setup)
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "gopls" }, -- Automatically install gopls if missing
    },
  },

  -- 3. The Configurator (Connects Neovim to gopls)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- ensures that LSPs and formatters are installed when opening neovim for the first time.
    },
    config = function()
    vim.lsp.config('gopls', {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_markers = { "go.work", "go.mod", ".git" },
    })

    -- To actually start the server for the current buffer
    vim.lsp.enable('gopls')
    end,
  },
}
