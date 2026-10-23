# Neovim config

Personal Neovim setup, originally based on
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and split into modules.
Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim); versions are pinned
in `lazy-lock.json`.

### TODO

- Learn about linters, lsp, mason, telescope, treesitter, lspconfig.

## Install

Stowed from the dotfiles repo:

```bash
make stow-config   # links ~/.config/nvim to this folder
```

Open `nvim` and lazy.nvim installs the plugins. Mason installs LSP servers, formatters and
debug adapters on first use. Run `:checkhealth` if something is missing.

### Dependencies

- `git`, `make`, `unzip`, a C compiler (`clang`)
- `ripgrep` and `fd` for Telescope
- a Nerd Font (JetBrainsMono Nerd Font)
- `lazygit` for `<leader>gg`
- `tree-sitter-cli` for Treesitter parsers
- Language toolchains for their LSPs: the Dart SDK (`dartls` is not installed by Mason),
  a JDK for `jdtls`, Go for `gopls`/`delve`, Python for `debugpy`

## Layout

```
init.lua                 loads config/*, then lazy.nvim with the plugin groups
lua/config/
  options.lua            editor options (2-space indent)
  keymaps.lua            leader is <Space>, general maps
  autocmds.lua
  lazy.lua               bootstraps lazy.nvim
lua/plugins/
  ui/                    tokyonight, lualine, neo-tree, which-key, alpha, indent guides
  editor/                mini.nvim, autopairs, guess-indent, todo-comments
  lsp/                   lspconfig + Mason, completion, conform (formatting), nvim-lint, treesitter
  git/                   gitsigns, lazygit
  tools/                 telescope (+ multigrep), DAP debugging, dadbod (SQL), tmux navigator
  ai/                    copilot
  session/               auto-session
lua/scripts/             personal helpers
```

Add a plugin by dropping a file that returns a lazy.nvim spec into the matching
`lua/plugins/<group>/` folder.

## Key mappings

Leader is `<Space>`. Press it and wait for which-key to list everything.

| Keys | Action |
| --- | --- |
| `<leader>sf` | Find files |
| `<leader>sg` | Grep (type two spaces to also filter by file) |
| `<leader><leader>` | Open buffers |
| `<leader>gg` | LazyGit |
| `<leader>dr` | Debug: start / continue |
| `<leader>db` | Debug: toggle breakpoint |
| `F1` / `F2` / `F3` | Debug: step into / over / out |

## Formatting and linting

`make check` in the dotfiles repo runs `stylua --check` on this folder. Format with:

```bash
stylua config/nvim/.config/nvim
```
