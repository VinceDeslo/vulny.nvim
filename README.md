# vulny.nvim

This little project aims to incorporate a vulnerability scanner into my local Neovim setup.

Due to my predisposition to use Snyk (due to my employment), I will start by integrating with that LSP and aim to make this generic enough to expand to other vulnerability scanning tools.

> Note: This is a personal project outside of my professional work. Consider this effort as community implementation.

## Local dev of the plugin

```lua
{
  dir = "~/<your-repo-dir>/vulny.nvim",
  opts = {},
  config = function(_, opts)
    require('vulny').setup(opts)
  end,
},
```

## Debugging

```
:messages
```

## Snyk LSP setup

- Install `snyk_ls` using `:MasonInstall snyk-ls`.
- Validate that the LSP is hooked on a buffer of the desired filetype as expected with `:LspInfo`.
- Run `snyk auth` in the CLI.
- Run `snyk config get api` in the CLI to find your token.

### .config/nvim/init.lua
```lua
-- Setup Snyk Language Server
require('lspconfig').snyk_ls.setup {
  cmd = { "snyk-ls" },
  filetypes = { "javascript", "typescript" },  -- Define relevant filetypes
  root_dir = function (name)
   return require('lspconfig').util.find_git_ancestor(name)
  end,
  init_options = {
    token = "<SNYK TOKEN>"
  }
}
```

### Diagnostics

If everything was properly configured you should be able to inspect diagnostics with Neovims built in diagnostics.
```
:lua vim.print(vim.diagnostic.get(0)[1].user_data.lsp.data.additionalData. cwe)
```

### Roadmap
- [ ] Telescope browsing of diagnostics reported by Snyk.
- [ ] Better automation around auth injection.
- [ ] Visualize HTML output of Snyk vuln details.
- [ ] Make the framework generic.
- [ ] Implement some separate scanners.
