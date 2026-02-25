# azinck1125/nvim

My Neovim config, kickstart-based, tuned for daily driving (Python + TS/JS + general editing).

- **Plugin manager:** lazy.nvim (bootstrapped automatically)
- **Theme:** TokyoNight Moon (transparent background, with solid DAP UI highlight group)
- **Completion:** blink.cmp + LuaSnip
- **Formatting:** conform.nvim (manual format key)
- **LSP:** nvim-lspconfig + mason + mason-tool-installer
- **Syntax:** Treesitter (plus Treesitter-based folding)
- **QoL:** which-key, gitsigns, todo-comments, mini.nvim, guess-indent, telescope

---

## Requirements

- Neovim (current stable recommended)
- Git
- A Nerd Font (optional, but recommended)
- `ripgrep` (`rg`) for Telescope grep
- `make` (optional) if you want `telescope-fzf-native` compiled acceleration

---

## Install

> This repo is meant to be your `~/.config/nvim` (or the Windows equivalent).

### Linux / macOS

```bash
# backup existing config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true

# clone this repo
git clone https://github.com/azinck1125/nvim ~/.config/nvim

# run
nvim
```

---

## "How do I use this?"

### Leader Key

- Leader: `<Space>`

### Keybinds I touch
#### Terminal
- Terminal: `<leader>t` — Toggle terminal in bottom split

#### Visual block
- `<leader>v` — Because I use WSL/windows terminal + SSH and `ctrl+v`. . . doesn't work like that with windows terminal

#### Telescope (search)
- `<leader>sf` — Find files
- `<leader>sg` — Live grep (rip grep)
- `<leader>sw` — Grep word under cursor
- `<leader>sd` — Diagnostics picker
- `<leader>sr` — Resume last Telescope picker
- `<leader>sn` — Search inside Neovim config

#### Formatting
- `<leader>f` — Format buffer (async; LSP fallback)

#### LSP "go to / actions"

> [!NOTE]
> `<C-a>` means ctrl+a
> `<C-a/s>` means ctrl+a or ctrl+s

- `<leader>grn` — Rename
- `<leader>gra` — Code action
- `<leader>grr` — References
- `<leader>grd` — Definition
- `<leader>gri` — Implementation
- `<leader>grt` — Type definition

---

#### Window movement
- `<C-h/j/k/l>` — Move focus between splits

---

### Formatting behavior (conform.nvim)
Format-on-save is **off** (on purpose). Formatting is manual via `<leader>f`.

Configured formatters by filetype:
- Lua → `stylua`
- JS/TS/JSON/YAML/Markdown → `prettier`
- TOML → `taplo`
- Python → `ruff_format`

---

### LSP behavior (mason + lspconfig)
Enabled servers (currently)
- lua_ls
- pyright

Extras:
- LSP "document hightlight" is skipped for `pyright` because treesitter (I think) already does 'good enough'™

Tools installed via mason-tool-installer:
- `stylua`, `prettier`, `taplo`, `marksman`

---

### Treesitter + folding
Treesitter highlights + indents are enabled, and folds use Treesitter expressions
- foldmethod: `expr`
- foldexpr: `nvim_treesitter#foldexpr()`
- foldlevel defaults high so nothing starts collapsed

Installed parsers include Python, JS/TS/TSX, JSON/YAML/TOML, Bash, HTML/CSS, Dockerfile, Lua, Vim/Vimdoc, Markdown.

---

### Theme notes
TokyoNight Moon is loaded early, with transparent background.

There’s also a “solid Normal” highlight group used for DAP UI windows so they don’t inherit transparency weirdness. Ideally DAP UI would have a solid background but I haven't figured that out. If it gets annoying then I'll revisit the concept

---

### Extending the config
This config keeps the “kickstart modular hook” enabled:

- lua/custom/plugins/*.lua

If you drop plugin specs in there, they’ll get picked up automatically.

---

### Credits
This config started from:

- kickstart.nvim (the single-file kickstart baseline)

…and then got customized into what you see here.






