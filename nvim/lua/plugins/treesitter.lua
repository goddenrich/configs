return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'master',
    opts = {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "go" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
