--  NOTE: mapleader must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- English spell-check
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

vim.keymap.set('n', '<leader>us', function() vim.o.spell = not vim.o.spell end, { desc = 'Toggle spell' })

local function loud_spell()
  vim.api.nvim_set_hl(0, 'SpellBad', {
    sp = '#f7768e',
    undercurl = true,
  })

  vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, sp = '#e0af68' })
  vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, sp = '#bb9af7' })
  vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, sp = '#7dcfff' })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = loud_spell,
})

loud_spell()

-- Relative line numbers
vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

-- OSC 52 clipboard: works reliably over SSH -> Windows Terminal
local osc52 = require 'vim.ui.clipboard.osc52'
vim.g.clipboard = {
  name = 'OSC 52',
  -- copy = {
  --   ['+'] = require('vim.ui.clipboard.osc52').copy '+',
  --   ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  -- },
  copy = {
    ['+'] = osc52.copy '+',
    ['*'] = osc52.copy '*',
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste '+',
    ['*'] = require('vim.ui.clipboard.osc52').paste '*',
  },
}

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 15

vim.o.confirm = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>v', '<C-v>', { desc = 'Visual block' })

-- terminal toggle (bottom split)
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  -- If window exists → close it
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end

  -- Open bottom split
  vim.cmd 'botright split'
  vim.cmd 'resize 12'

  term_win = vim.api.nvim_get_current_win()

  -- If buffer exists → reuse it
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(term_win, term_buf)
  else
    vim.cmd 'terminal'
    term_buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd 'startinsert'
end

vim.keymap.set('n', '<leader>t', toggle_terminal, { desc = 'Toggle terminal (bottom)' })

-- exit terminal mode easily
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  { 'NMAC427/guess-indent.nvim', opts = {} },

  {
    'folke/tokyonight.nvim', -- https://github.com/folke/tokyonight.nvim
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
        transparent = true,

        on_highlights = function(hl, c)
          -- Create a solid background group we can point windows to
          hl.NormalSolid = { bg = c.bg_dark, fg = c.fg }

          -- gutter
          hl.SignColumn = { bg = c.bg_dark }
          hl.LineNr = { bg = c.bg_dark }
          hl.CursorLineNr = { bg = c.bg_dark }
          hl.LineNrAbove = { bg = c.bg_dark }
          hl.LineNrBelow = { bg = c.bg_dark }

          -- cmdline / messages area (this is the “command bar” vibe)
          hl.MsgArea = { bg = c.bg_dark }
          hl.MsgSeparator = { bg = c.bg_dark }
          hl.Cmdline = { bg = c.bg_dark }
          hl.CmdlinePrompt = { bg = c.bg_dark }

          -- Messing around
          hl.FoldColumn = { bg = c.bg_dark }

          -- imports modification
          vim.api.nvim_create_autocmd('ColorScheme', {
            callback = function()
              vim.api.nvim_set_hl(0, '@keyword.import', { link = 'Keyword' })
              vim.api.nvim_set_hl(0, '@module', { link = 'Identifier' })
            end,
          })
        end,
      }
      vim.cmd.colorscheme 'tokyonight-moon'
      loud_spell()
    end,
  },

  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Best general-purpose folding in Neovim right now
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- Keep folds *available* but don't start with everything folded
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Optional: nicer fold text column behavior
vim.opt.foldcolumn = '1' -- shows fold markers in gutter
vim.opt.fillchars = { fold = ' ' } -- cleaner look

loud_spell()
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
