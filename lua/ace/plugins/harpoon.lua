return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    local list = harpoon:list()

    -- add file
    vim.keymap.set('n', '<leader>a', function() list:add() end, { desc = 'Harpoon: Add file' })

    -- toggle menu
    vim.keymap.set('n', '<leader>j', function() harpoon.ui:toggle_quick_menu(list) end, { desc = 'Harpoon: Menu' })

    -- jump by index
    vim.keymap.set('n', '<leader>1', function() list:select(1) end, { desc = 'Harpoon: (file 1)' })
    vim.keymap.set('n', '<leader>2', function() list:select(2) end, { desc = 'Harpoon: (file 2)' })
    vim.keymap.set('n', '<leader>3', function() list:select(3) end, { desc = 'Harpoon: (file 3)' })
    vim.keymap.set('n', '<leader>4', function() list:select(4) end, { desc = 'Harpoon: (file 4)' })
    vim.keymap.set('n', '<leader>5', function() list:select(5) end, { desc = 'Harpoon: (file 5)' })

    -- move prev/next index
    vim.keymap.set('n', '<leader>h', function() list:prev() end, { desc = 'Harpoon prev' })
    vim.keymap.set('n', '<leader>l', function() list:next() end, { desc = 'Harpoon next' })
  end,
}
