-- git_root returns the absolute path of the root of the git repository that path is in.
-- if path is not provided it defaults to the path of the current buffer.
local M = {}
M.git_root = function(path)
  if not path then
    path = vim.api.nvim_buf_get_name(0)
  end

  local dot_git_path = vim.fn.finddir('.git', path .. ';')
  if not dot_git_path then
    vim.notify('failed to find git root', vim.log.levels.WARN)
    return
  end
  -- for some reason providing :p:h or :h:p doesn't work, so we just chain them instead...
  return vim.fn.fnamemodify(vim.fn.fnamemodify(dot_git_path, ':h'), ':p')
end

return M
