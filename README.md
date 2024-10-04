# vulny.nvim

This little project aims to incorporate a vulnerability scanner into my local Neovim setup.

Due to my predisposition to use Snyk (due to my employment), I will start by integrating with that LSP and aim to make this generic enough to expand to other vulnerability scanning tools.

> Note: This is a personal project outside of my professional work. Consider this effort as community implementation.

## Local dev

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
