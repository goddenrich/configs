return {
          {
    'tpope/vim-fugitive', -- General purpose git interface
    config = function()
      vim.keymap.set('n', '<leader>gb', '<cmd>:Git blame<cr>')
    end,
  },
}
