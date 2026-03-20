return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview: Open' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diffview: Close' },
  },
  opts = {},
}
