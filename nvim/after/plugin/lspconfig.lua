
local util = require('lspconfig.util')

-- Enable the following language servers
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

---@param plz_root string
---@return string? goroot
---@return string? errmsg
local function plz_goroot(plz_root)
  local gotool_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'config', 'plugin.go.gotool' }):wait()
  local gotool = 'go'
  if gotool_res.code == 0 then
    gotool = vim.trim(gotool_res.stdout)
  elseif not gotool_res.stderr:match('Settable field not defined') then
    return nil, string.format('querying value of plugin.go.gotool: %s', gotool_res.stderr)
  end

  if vim.startswith(gotool, ':') or vim.startswith(gotool, '//') then
    gotool = gotool:gsub('|go$', '')
    local gotool_output_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'output', gotool }):wait()
    if gotool_output_res.code > 0 then
      return nil, string.format('querying output of plugin.go.gotool target %s: %s', gotool, gotool_output_res.stderr)
    end
    return vim.fs.joinpath(plz_root, vim.trim(gotool_output_res.stdout))
  end

  if vim.startswith(gotool, '/') then
    if not vim.uv.fs_stat(gotool) then
      return nil, string.format('plugin.go.gotool %s does not exist', gotool)
    end
    local goroot_res = vim.system({ gotool, 'env', 'GOROOT' }):wait()
    if goroot_res.code == 0 then
      return vim.trim(goroot_res.stdout)
    else
      return nil, string.format('%s env GOROOT: %s', gotool, goroot_res.stderr)
    end
  end

  local build_paths_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'config', 'build.path' }):wait()
  if build_paths_res.code > 0 then
    return nil, string.format('querying value of build.path: %s', build_paths_res.stderr)
  end
  local build_paths = vim.trim(build_paths_res.stdout)
  for build_path in vim.gsplit(build_paths, '\n') do
    for build_path_part in vim.gsplit(build_path, ':') do
      local go = vim.fs.joinpath(build_path_part, gotool)
      if vim.uv.fs_stat(go) then
        local goroot_res = vim.system({ go, 'env', 'GOROOT' }):wait()
        if goroot_res.code == 0 then
          return vim.trim(goroot_res.stdout)
        else
          return nil, string.format('%s env GOROOT: %s', go, goroot_res.stderr)
        end
      end
    end
  end

  return nil, string.format('plugin.go.gotool %s not found in build.path %s', gotool, build_paths:gsub('\n', ':'))
end

local servers = {
  yamlls = {},
  vimls = {},
  bashls = {},
  intelephense = {},
  gopls = {
    settings = {
      gopls = {
        directoryFilters = { '-plz-out', '-.git', '-plz.d', '-experimental' },
        -- linksInHover = false,
        -- usePlaceholders = false,
        semanticTokens = true,
        -- codelenses = {
        --   gc_details = true,
        -- },
      },
    },
    -- cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { ".plzconfig", "go.mod", ".git" },
    -- cmd = {
    --   "env", 
    --   "GOPACKAGESDRIVER=/home/rgodden/repos/go-rules/plz-out/bin/tools/driver/plz-gopackagesdriver",
    --   "PLZ_GOPACKAGEDRIVER_VERBOSITY=debug",
    --   "PLZ_GOPACKAGESDRIVER_LOG_FILE=/home/rgodden/gopkg_nvim.log",
    --   "gopls"
    -- },
    -- cmd = { 
    --         "env", 
    --         "GOPACKAGESDRIVER=/home/rgodden/repos/go-rules/plz-out/bin/tools/driver/plz-gopackagesdriver",
    --         "PLZ_GOPACKAGEDRIVER_VERBOSITY=debug",
    --         "PLZ_GOPACKAGESDRIVER_LOG_LEVEL=debug", -- Extra verbosity
    --         "PLZ_GOPACKAGESDRIVER_LOG_FILE=/home/rgodden/gopkg_nvim.log",
    --         -- Force gopls to use the driver for ALL operations
    --         "GOPACKAGESDRIVER_TIMEOUT=60s",
    --         "gopls",
    --         "-vv", -- Very Verbose gopls logging
    --         "-rpc.trace",
    --         "serve",
    -- },
    -- cmd_env = {
    --     GOPACKAGESDRIVER = "/home/rgodden/repos/go-rules/plz-out/bin/tools/driver/plz-gopackagesdriver",
    --     PLZ_GOPACKAGEDRIVER_VERBOSITY = "debug",
    --     PLZ_GOPACKAGESDRIVER_LOG_FILE = vim.fn.expand("~") .. "/gopkg_nvim.log",
    -- },
    -- root_dir = function(fname)
    --   local gowork_or_gomod_dir = util.root_pattern('go.work', 'go.mod')(fname)
    --   if gowork_or_gomod_dir then
    --     return gowork_or_gomod_dir
    --   end
    --
    --   local plz_root = util.root_pattern('.plzconfig')(fname)
    --   if plz_root and vim.fs.basename(plz_root) == 'src' then
    --     vim.env.GOPATH = string.format('%s:%s/plz-out/go', vim.fs.dirname(plz_root), plz_root)
    --     vim.env.GO111MODULE = 'off'
    --     local goroot, err = plz_goroot(plz_root)
    --     if not goroot then
    --       vim.notify(string.format('Determining GOROOT for plz repo %s: %s', plz_root, err), vim.log.levels.WARN)
    --     elseif not vim.uv.fs_stat(goroot) then
    --       vim.notify(string.format('GOROOT for plz repo %s does not exist: %s', plz_root, goroot), vim.log.levels.WARN)
    --     else
    --       vim.env.GOROOT = goroot
    --     end
    --     -- return plz_root .. '/vault' -- hack to work around slow monorepo
    --     return plz_root -- hack to work around slow monorepo
    --   end
    --
    --   return vim.fn.getcwd()
    -- end,
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          typeCheckingMode = 'standard',
          verboseOutput = true,
          logLevel = 'Trace',
          extraPaths = {
            'plz_out/gen',
            'plz-out/gen',
            'plz-out/python/venv',
          },
        },
      },
    },
    on_new_config = function(config, root_dir)
      if util.root_pattern('.plzconfig') then
        config.settings = vim.tbl_deep_extend('force', config.settings, {
          python = {
            analysis = {
              extraPaths = {
                vim.fs.joinpath(root_dir, 'plz-out/python/venv'),
              },
              exclude = { 'plz-out' },
            },
          },
        })
      end
    end,
    root_dir = function()
      return vim.fn.getcwd()
    end,
  },
  lua_ls = {
    -- cmd = {...},
    -- filetypes { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu
require('mason').setup()

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua', -- Used to format lua code
  { 'black', version = '23.7.0' },
  'goimports',
  'prettier',
})
require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP Specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
    capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
end

for server_name, server_config in pairs(servers) do
    -- Merge your server-specific settings with global capabilities
    local config = vim.tbl_deep_extend('force', {
        capabilities = capabilities,
    }, server_config)

    -- NEW: In 0.11+, we use the global lsp engine directly
    -- This registers the "how" to start the server
    vim.lsp.config(server_name, config)

    -- This registers the "when" (the filetypes) and "where" (the root_dir)
    -- Without this, the server is configured but never attached to a buffer
    vim.lsp.enable(server_name)
end

-- Defines and sets up the the please language server (this is the only one that is not inlcuded in lspconfig.configs by
-- default, and is also not included in mason)
vim.lsp.config('please', {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = util.root_pattern('.plzconfig'),
    capabilities = capabilities,
})
vim.lsp.enable('please')


require('mason-lspconfig').setup({
  ensure_installed = vim.tbl_keys(servers),
})

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'go',
--   callback = function(args)
--     -- Check if a client is already attached to avoid duplicates
--     local clients = vim.lsp.get_clients({ bufnr = args.buf, name = 'gopls' })
--     if #clients == 0 then
--       vim.lsp.start(servers.gopls)
--     end
--   end,
-- })

-- -- Immediate check: if we are currently in a go file, start it NOW
-- if vim.bo.filetype == 'go' then
--     vim.lsp.start(servers.gopls)
-- end
vim.lsp.log.set_level('trace')
