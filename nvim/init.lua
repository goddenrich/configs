require("config.lazy")
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
local snap_go_path = "/snap/go/current/bin"
if vim.fn.isdirectory(snap_go_path) == 1 then
	vim.env.PATH = snap_go_path .. ":" .. vim.env.PATH
end
