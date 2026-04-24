-- Mappings for yanking the path of the current buffer to the clipboard

local git_root = require('util').git_root

vim.keymap.set('n', '<leader>y', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. git_root(), '')
  vim.fn.setreg('"', relative_filepath)
  vim.fn.setreg('*', relative_filepath)
  vim.notify('Yanked path of current buffer relative to git root: ' .. relative_filepath, vim.log.levels.INFO)
end, { desc = 'Yank the path of the current buffer relative to the git root' })

vim.keymap.set('n', '<leader>Y', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg('"', filepath)
  vim.fn.setreg('*', filepath)

  vim.notify('Yanked absolute path of current buffer: ' .. filepath, vim.log.levels.INFO)
end, { desc = 'Yank the absolute path of the current buffer' })

vim.keymap.set('n', '<leader>ys', function()
  local base_url = 'https://sourcegraph.iap.tmachine.io'
  -- local base_url = vim.env.SOURCEGRAPH_BASE_URL
  if not base_url then
    vim.notify('Unable to yank sourcegraph URL: SOURCEGRAPH_BASE_URL env var not set', vim.log.levels.ERROR)
    return
  end

  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. git_root(), '')

  local git_ref
  local upstream_branch = vim.trim(vim.system({ 'git', 'rev-parse', '--abbrev-ref', '@{upstream}' }):wait().stdout)
  if upstream_branch ~= '' then
    local remote_branch = upstream_branch:match('^origin/(.+)')
    if remote_branch then
      git_ref = remote_branch
    end
  else
    local tag = vim.trim(vim.system({ 'git', 'tag', '--points-at', 'HEAD' }):wait().stdout)
    if tag then
      git_ref = tag
    end
  end

  local git_ref_segment = git_ref and '@' .. git_ref or ''

  local line = unpack(vim.api.nvim_win_get_cursor(0))
  local url = string.format('%s%s/-/blob/%s?L%d', base_url, git_ref_segment, relative_filepath, line)
  vim.fn.setreg('"', url)
  vim.fn.setreg('*', url)
  vim.notify('Yanked sourcegraph URL: ' .. url, vim.log.levels.INFO)
end, { desc = 'Yank the sourcegraph URL to the current position in the buffer' })
