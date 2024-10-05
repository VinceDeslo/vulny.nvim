local M = {}

local snyk_lsp = 'snyk_ls'
local snyk_binary = 'snyk-ls'
local mason = require('mason-lspconfig')
local mason_registry = require('mason-registry')

function M.setup(opts)
  opts = opts or {}

  local function list_contains(list, value)
      for _, v in ipairs(list) do
          if v == value then
              return true
          end
      end
      return false
  end

  local function is_lsp_active(server_name)
    local clients = vim.lsp.get_active_clients()
    local client_names = {}

    for _, client in pairs(clients) do
        table.insert(client_names, client.name)
    end
    vim.notify(vim.inspect(client_names), vim.log.levels.DEBUG)
    return list_contains(client_names, server_name)
  end

  local function is_mason_lsp_installed(server_name)
    vim.notify(string.format("Checking for %s installation", server_name))
    local installed_servers = mason.get_installed_servers()
    vim.notify(vim.inspect(installed_servers), vim.log.levels.DEBUG)
    return list_contains(installed_servers, server_name)
  end

  local function is_mason_lsp_available(server_name)
    vim.notify(string.format("Checking for %s availability", server_name))
    local available_servers = mason.get_available_servers()
    vim.notify(vim.inspect(available_servers), vim.log.levels.DEBUG)
    return list_contains(available_servers, server_name)
  end

  local function get_mason_package_path(binary_name)
    vim.notify(string.format("Checking for %s path", binary_name))
    local path = mason_registry.get_package(binary_name):get_install_path()
    vim.notify(vim.inspect(path), vim.log.levels.DEBUG)
    return path
  end

  -- Obtain snyk binary path
  local function snyk_binary_path()
    vim.notify("Running VulnyGetSnykPath")
    local path = get_mason_package_path(snyk_binary)
    vim.notify(string.format('Snyk LSP path: %s', path), vim.log.levels.INFO)
  end
  vim.api.nvim_create_user_command('VulnyGetSnykPath', snyk_binary_path, {})
  vim.keymap.set('n', '<leader>vgsp', snyk_binary_path, {})

  -- Checks if Snyk is present in lspconfig
  local function snyk_check_lsp()
    vim.notify("Running VulnyCheckSnykLSP")
    if is_lsp_active(snyk_lsp) then
      vim.notify('Snyk LSP active', vim.log.levels.INFO)
    else
      vim.notify('Snyk LSP not active', vim.log.levels.WARN)
    end
  end
  vim.api.nvim_create_user_command('VulnyCheckSnykLSP', snyk_check_lsp, {})
  vim.keymap.set('n', '<leader>vcsl', snyk_check_lsp, {})

  -- Checks if Snyk is present in mason
  local function snyk_check_mason()
    vim.notify("Running VulnyCheckSnykMason")
    if is_mason_lsp_installed(snyk_lsp) then
      vim.notify('Snyk LSP installed in Mason', vim.log.levels.INFO)
    else
      vim.notify('Snyk LSP not installed in Mason', vim.log.levels.WARN)
      if is_mason_lsp_available(snyk_lsp) then
        vim.notify('Snyk LSP available in Mason', vim.log.levels.INFO)
      else
        vim.notify('Snyk LSP not available in Mason', vim.log.levels.WARN)
      end
    end
  end
  vim.api.nvim_create_user_command('VulnyCheckSnykMason', snyk_check_mason, {})
  vim.keymap.set('n', '<leader>vcsm', snyk_check_mason, {})

  -- WIP: Install Snyk LSP to specific location
  local function snyk_install()
    vim.notify("Running VulnySnykInstall")
  end
  vim.api.nvim_create_user_command('VulnySnykInstall', snyk_install, {})
  vim.keymap.set('n', '<leader>vsi', snyk_install, {})

  -- WIP: Run snyk against the current project 
  local function snyk_run()
    vim.notify("Running VulnySnykRun")
  end
  vim.api.nvim_create_user_command('VulnySnykRun', snyk_run, {})
  vim.keymap.set('n', '<leader>vsr', snyk_run, {})
end

return M
