# azinck1125/nvim

My daily-driver Neovim config, originally kickstart-based and then pushed toward a setup that feels good for Python, TS/JS, general editing, debugging

It’s built around:
- `lazy.nvim` for plugin management
- `tokyonight-moon` for the colorscheme
- `blink.cmp` + `LuaSnip` for completion/snippets
- `nvim-lspconfig` + Mason for LSP/tooling
- Treesitter for syntax + folding
- Telescope / Neo-tree / Harpoon for navigation
- Conform for manual formatting
- nvim-dap for Python debugging

---

## Features

- Transparent TokyoNight Moon setup with a few custom highlight tweaks
- OSC52 clipboard config for better SSH / terminal copy behavior
- Manual formatting only (`<leader>f`) — no format-on-save
- Treesitter-based folding with a high default foldlevel
- Telescope-powered search for files, grep, diagnostics, commands, keymaps, and config files
- Neo-tree explorer with reveal behavior
- Harpoon for quick file pinning and jumping
- Python-friendly LSP/debug setup
- Markdown rendering toggle
- Neogen docstring generation
- Todo-comments with expanded custom keywords
- DAP UI configured with solid-background handling for transparent themes

---

## Requirements

- Neovim stable
- Git
- A Nerd Font
- `ripgrep` (`rg`) for Telescope grep
- `make` for native Telescope FZF acceleration and optional snippet regex support

Useful external tools:
- `stylua`
- `prettier`
- `taplo`
- `ruff` / `ruff_format`
- language servers you want Mason to manage

Recommended:
[install] git ripgrep fd nodejs npm python python-pip

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

## Repo layout

```
.
├── init.lua
├── lua
│   └── ace
│       ├── init.lua
│       ├── remap.lua
│       └── plugins
│           ├── colors.lua
│           └── ...
└── README.md
```

### Current structure note
This repo is in a bit of an in-between state:

`init.lua` still owns most of the core bootstrap / options / lazy setup

`lua/ace/` exists and is where remaps + plugin files are being organized

So this is partially modularized already, but not fully moved over yet.


---

## "How do I use this?"

### Leader Key

- Leader: `<Space>`

### Keybinds I touch
#### Terminal
- Terminal: `<leader>t` — Toggle terminal in bottom split

#### Visual block
- `<leader>v` — Because I use WSL/windows terminal + SSH and `ctrl+v`... doesn't work like that with windows terminal

#### Telescope (search)

> [!NOTE]
> `<C-a>` means ctrl+a
> `<C-a/s>` means ctrl+a or ctrl+s

- `<leader>sf` — Find files
- `<leader>ss` — Find git-tracked files
- `<leader>sk` — Find keymaps
- `<leader>sg` — Live grep (rip grep)
- `<leader>sw` — Grep word under cursor
- `<leader>sd` — Diagnostics
- `<leader>sr` — Resume last Telescope picker
- `<leader>sn` — Search inside Neovim config
- `/` — fussy search current buffer
- `<C-v>` — open in vertical split from telescope
- `<C-t>` — open in horizontal split from telescope

#### Formatting
- `<leader>f` — Format buffer (async; LSP fallback)

#### LSP "go to / actions"

- `<leader>grn` — Rename
- `<leader>gra` — Code action
- `<leader>grr` — References
- `<leader>grd` — Definition
- `<leader>grD` — Declaration
- `<leader>gO` — document symbols
- `<leader>gri` — Implementation
- `<leader>grt` — Type definition

#### Neo-tree
- `<leader>e` — Toggle explorer
- `<leader>r` — Reveal current file in explorer
- `<leader>be` — open Neo-tree buffer

#### Harpoon (file nav)
- `<leader>a` — add file
- `<leader>j` — show harpoon buffer (`dd` to remove entry, `:w` to save)
- `<leader>1`..`5` — jump to Harpoon file slot
- `<leader>h`/`<leader>h` — prev/next Harpoon item

#### Marks (line nav)
- `mj` — add `j` to marks at current line
- `'j` — go to `j` line
- I mostly stick to `j`/`k`/`l`/`;` for file marks

#### DAP (python)
- `<leader>b` — set/clear breakpoint at current line
- `<leader>B` — clear all breakpoints
- `<f5>` — open run menu
- `<f8>` — step into
- `<f10>` — terminate
- `<leader>du` — toggle ui


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






