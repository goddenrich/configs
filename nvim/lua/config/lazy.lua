local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.guicursor = ""
vim.opt.number = true
-- " -----------Buffer Management---------------
-- " Close the current buffer and move to the previous one
-- " This replicates the idea of closing a tab
vim.cmd("nmap <leader>q :bp <BAR> bd #<CR>")
--
-- " Use arrow keys to navigate window splits
vim.cmd("noremap <leader><Right> :wincmd l <CR>")
vim.cmd("noremap <leader><Left> :wincmd h <CR>")
vim.cmd("noremap <leader><Up> :wincmd k <CR>")
vim.cmd("noremap <leader><Down> :wincmd j <CR>")

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- When pressing tab expand it into n spaces (unless this is overwridden for the filetype)
vim.opt.expandtab = true

vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Go to References" })

vim.opt.clipboard = "unnamedplus"

vim.o.termguicolors = true
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = {
        enabled = true,
        notify = false,
  },
})
