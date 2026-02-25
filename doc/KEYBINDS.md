# Neovim Keybinds + “you will use this” masterlist

Leader key: **Space** :contentReference[oaicite:1]{index=1}

This sheet is split into:

- **A. My config keybinds (the “truth”)**
- **B. Vim motions worth memorizing (aka: the real power)**
- **C. Plugin-native defaults you’ll likely use (Mini, completion, etc.)**
- **D. Quick ways to confirm anything on this sheet**

---

## A) Your config keybinds

### Core / QoL

- **Clear search highlight:** `<Esc>` :contentReference[oaicite:2]{index=2}
- **Visual BLOCK mode:** `v` (you’ve repurposed `v` to block-visual) :contentReference[oaicite:3]{index=3}

### Terminal

- **Toggle bottom terminal split:** `<leader>t` :contentReference[oaicite:4]{index=4}
- **Exit terminal-mode to normal:** `<Esc><Esc>` :contentReference[oaicite:5]{index=5}

### Diagnostics

- **Open diagnostics list (loclist/quickfix style):** `<leader>q` :contentReference[oaicite:6]{index=6}

### Window focus (splits)

- **Focus left/right/down/up:** `<C-h> / <C-l> / <C-j> / <C-k>` :contentReference[oaicite:7]{index=7}

---

## A2) Telescope (Search) — your “main menu”

All of these are in your Telescope config. :contentReference[oaicite:8]{index=8}

- `<leader>sh` — help tags
- `<leader>sk` — keymaps
- `<leader>sf` — find files
- `<leader>se` — find files (EVERYTHING: hidden + no_ignore)
- `<leader>ss` — Telescope builtins picker
- `<leader>sw` — grep word under cursor (normal + visual)
- `<leader>sg` — live grep
- `<leader>sd` — diagnostics picker
- `<leader>sr` — resume last Telescope picker
- `<leader>s.` — oldfiles / recent files
- `<leader>sc` — commands
- `<leader><space>` — buffers

Search inside current buffer:

- `/` — fuzzy find in current buffer (dropdown UI)

Search across open files:

- `<leader>s/` — live grep in open files only

Search your Neovim config:

- `<leader>sn` — find files in `stdpath("config")`

---

## A3) LSP (code navigation + actions)

### LSP “do stuff”

These are set on LspAttach. :contentReference[oaicite:9]{index=9}

- `grn` — rename symbol
- `gra` — code action (normal + visual)
- `grD` — goto declaration

### LSP navigation (Telescope-backed)

These are also set on LspAttach. :contentReference[oaicite:10]{index=10}

- `grr` — references
- `gri` — implementations
- `grd` — definitions
- `grt` — type definitions
- `gO` — document symbols
- `gW` — workspace symbols

### Inlay hints

- `<leader>h` — toggle inlay hints (only if server supports it) :contentReference[oaicite:11]{index=11}

---

## A4) Formatting (conform.nvim)

- `<leader>f` — format buffer (async, LSP fallback) :contentReference[oaicite:12]{index=12}

---

## B) Vim motions you will use the hell out of

### Movement (the “stop using arrows” pack)

- `h j k l` — left/down/up/right
- `w / b / e` — next word / prev word / end of word
- `W / B / E` — same but “big words” (space-delimited)
- `0` / `^` / `$` — start / first nonblank / end of line
- `gg` / `G` — top / bottom of file
- `{` / `}` — jump paragraphs
- `(` / `)` — jump sentences
- `%` — jump matching bracket/paren
- `f{char}` / `F{char}` — find char forward/back
- `t{char}` / `T{char}` — “to” char forward/back
- `;` / `,` — repeat last f/F/t/T forward/back
- `*` / `#` — search word under cursor forward/back
- `n` / `N` — next / previous search hit

### Editing (high ROI)

- `u` / `<C-r>` — undo / redo
- `dd` — delete line
- `D` — delete to end of line
- `cc` — change line (delete + insert)
- `C` — change to end of line
- `x` — delete char under cursor
- `p` / `P` — paste after / before cursor
- `r{char}` — replace single char
- `.` — repeat last change (insanely good)
- `ci"` / `ci'` / `ci(` / `ci{` / `ci[` — change inside quotes/parens/brackets
- `di"` / `di(` / etc. — delete inside
- `yi"` / `yi(` / etc. — yank inside
- `>>` / `<<` — indent / unindent line
- `=` — re-indent (try `=` with a motion: `=ap`)

### Visual mode (select like a god)

- `v` — visual
- `V` — visual line
- `<leader>v` — **visual block** (yours is mapped) :contentReference[oaicite:13]{index=13}
- In visual: `>` `<` — indent selection
- In visual: `y` — yank selection
- In visual: `p` — paste (replaces selection)

### “Operator + motion” mental model

These are the core:

- `d` delete
- `c` change
- `y` yank
- `g~` toggle case
- `gu` lowercase
- `gU` uppercase
- `>` indent
- `<` unindent

Examples:

- `dw` [d]elete [w]ord
- `ci(` [c]hange [i]nside parens
- `yap` [y]ank [a] [p]aragraph
- `d}` delete to end of paragraph
- `c$` change to end of line

### Search + replace (money)

- `/pattern` — search
- `:%s/old/new/g` — replace all
- `:%s/old/new/gc` — replace all w/ confirm
- In visual selection: `:'<,'>s/old/new/gc`

### Registers (copy/paste without pain)

- `"0` — last yank
- `"_d` — delete without yanking (black hole register)
- `"+y` / `"+p` — system clipboard yank/paste (you also have clipboard=unnamedplus) :contentReference[oaicite:14]{index=14}

### Marks (teleport points)

- `ma` — set mark a
- `'a` — jump to line of mark a
- `` `a `` — jump to exact position of mark a
- `:delmarks a` — delete mark a
- `:delmarks!` — delete ALL lowercase marks

---

## C) Plugin-native defaults you’ll probably love

### mini.surround (defaults)

Mini’s defaults should be in effect. :contentReference[oaicite:15]{index=15}

- `sa{motion}{char}` — add surrounding
  - Example: `saiw)` [s]urround [a]dd [i]nner [w]ord with `()`
- `sd{char}` — delete surrounding
  - Example: `sd'` [s]urround [d]elete single quotes
- `sr{from}{to}` — replace surrounding
  - Example: `sr)"` replace `()` with `""`

### mini.ai (defaults)

Also defaults; huge value because it makes “inside/around” smarter. :contentReference[oaicite:16]{index=16}

- Works with your normal `i` / `a` textobjects:
  - `if`, `af` (function)
  - `ic`, `ac` (class)
  - plus “next/last” style targets

### blink.cmp (completion)

I've set `preset = "none"` and made a keymap table. :contentReference[oaicite:17]{index=17}

I'll get to updating this part later, but you can `:Telescope keymaps` search `blink` for cmds

---

## D) Verify / generate the definitive list inside Neovim

If you want a 100% canonical dump, these are your best tools:

### 1) Telescope: keymaps (best)

- Run: `:Telescope keymaps`
- Search: `leader`, `gr`, `telescope`, `diagnostic`, etc. :contentReference[oaicite:18]{index=18}

### 2) Which-key (best for discovering)

- Hit `<leader>` and pause — you’ll see groupings (Search, Git Hunk, etc.) :contentReference[oaicite:19]{index=19}

### 3) Built-in mapping queries

- `:map` / `:nmap` / `:vmap` / `:imap` / `:tmap`
- `:verbose nmap <leader>f` (shows _where_ it was set)

---

## “If you only print one page”

Print sections:

- A2 (Telescope), A3 (LSP), A4 (Format), B (Movement+Editing), C (Surround)
