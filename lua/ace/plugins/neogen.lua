return {
  'danymat/neogen',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'L3MON4D3/LuaSnip',
  },
  config = function()
    require('neogen').setup {
      snippet_engine = 'luasnip',
      languages = {
        python = {
          template = {
            annotation_convention = 'google_docstrings',
          },
        },
      },
    }

    -- main command: :Docstring [type]
    vim.api.nvim_create_user_command('Docstring', function(opts)
      local arg = opts.args

      local map = {
        func = 'func',
        class = 'class',
        type = 'type',
        file = 'file',
      }

      if arg == '' then
        require('neogen').generate()
        return
      end

      local t = map[arg]

      if not t then
        vim.notify('Docstring: invalid type (func/class/type/file)', vim.log.levels.WARN)
        return
      end

      require('neogen').generate { type = t }
    end, {
      nargs = '?',
      complete = function() return { 'func', 'class', 'type', 'file' } end,
    })
  end,
}
