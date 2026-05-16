-- dummy comment
--
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- English spell-check
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

-- Relative line numbers
vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

-- OSC 52 clipboard: works reliably over SSH -> Windows Terminal
local osc52 = require 'vim.ui.clipboard.osc52'
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = osc52.copy '+',
    ['*'] = osc52.copy '*',
  },
  paste = {
    ['+'] = osc52.paste '+',
    ['*'] = osc52.paste '*',
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
vim.o.scrolloff = 10

vim.o.confirm = true

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

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  jump = { float = true },
}

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

require 'ace' -- NOTE: the actual config
require('lazy').setup({
  { import = 'ace.plugins' },
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
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
