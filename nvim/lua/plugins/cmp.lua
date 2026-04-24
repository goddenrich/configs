return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-cmdline',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      -- 'hrsh7th/cmp-path',
      -- -- nvim-cmp source for neovim Lua API
      -- -- so that things like vim.keymap.set, etc. are autocompleted
      'hrsh7th/cmp-nvim-lua',
    },
  }
}
