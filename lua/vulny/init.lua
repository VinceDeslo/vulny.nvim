local M = {}

local snyk_lsp = 'snyk_ls'
local mason = require('mason-lspconfig')

function M.setup(opts)
  opts = opts or {}

  local function is_lsp_active(server_name)
    local clients = vim.lsp.get_active_clients()
    print(vim.inspect(clients))
    return vim.tbl_contains(clients, server_name)
  end

  local function is_mason_lsp_installed(server_name)
    local installed_servers = mason.get_installed_servers()
    vim.notify(vim.inspect(installed_servers))
    return installed_servers[server_name] ~= nil
  end

  local function is_mason_lsp_available(server_name)
    local available_servers = mason.get_available_servers()
    vim.notify(vim.inspect(available_servers))
    return available_servers[server_name] ~= nil
  end

  local function snyk_install()
    vim.notify("Running VulnySnykInstall")

    if is_mason_lsp_installed(snyk_lsp) then
      vim.notify('Snyk LSP installed in Mason', vim.log.levels.INFO)
      -- TODO: use LSP in Mason
    else
      vim.notify('Snyk LSP not installed in Mason', vim.log.levels.WARN)
      if is_mason_lsp_available(snyk_lsp) then
        vim.notify('Snyk LSP available in Mason', vim.log.levels.INFO)
        -- TODO: Install and use LSP in Mason
      else
        vim.notify('Snyk LSP not available in Mason', vim.log.levels.WARN)
      end
      -- TODO: pull down LSP some other way and set it up
    end
  end

  local function snyk_run()
    vim.notify("Running VulnySnykRun")

    if is_lsp_active(snyk_lsp) then
      vim.notify('Snyk LSP active', vim.log.levels.INFO)
      -- Check if LSP authed
      -- ... Do something with the LSP
    else
      vim.notify('Snyk LSP not active', vim.log.levels.WARN)
      -- Activate or install
    end
  end

  vim.api.nvim_create_user_command('VulnySnykInstall', snyk_install, {})
  vim.keymap.set('n', '<leader>vsi', snyk_install, {})

  vim.api.nvim_create_user_command('VulnySnykRun', snyk_run, {})
  vim.keymap.set('n', '<leader>vsr', snyk_run, {})
end

return M
