return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neotest/nvim-nio',
    'nvim-treesitter/nvim-treesitter',
    'marilari88/neotest-vitest',
  },
  root = function(path)
    return require('neotest.lib').files.match_root_pattern(
      'vitest.config.ts',
      'vitest.config.js',
      'vitest.config.mts',
      'vitest.config.mjs'
    )(path)
  end,
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-vitest' {
          -- optional; usually auto-detects fine
          -- vitestCommand = 'npx vitest',
        },
      },
      status = {
        enabled = true,
        signs = false,
        virtual_text = true,
      },

      diagnostic = {
        enabled = true,
      },
    }

    local neotest_ns = vim.api.nvim_create_namespace 'neotest'
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic) return diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '') end,
      },
    }, neotest_ns)

    vim.keymap.set('n', '<leader>ut', function() require('neotest').run.run() end, { desc = 'Run nearest test' })

    vim.keymap.set('n', '<leader>uf', function() require('neotest').run.run(vim.fn.expand '%') end, { desc = 'Run test file' })

    vim.keymap.set('n', '<leader>uo', function() require('neotest').output.open { enter = true, auto_close = true } end, { desc = 'Open test output' })

    vim.keymap.set('n', '<leader>ui', function() require('neotest').summary.toggle() end, { desc = 'Toggle test summary' })

    vim.keymap.set('n', '<leader>ul', function() require('neotest').run.run_last() end, { desc = 'Run last test' })
  end,
}
