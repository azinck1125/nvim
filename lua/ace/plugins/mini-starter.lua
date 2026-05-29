return {
  {
    'echasnovski/mini.starter',
    event = 'VimEnter',
    config = function()
      local starter = require 'mini.starter'
      local function get_version()
        local v = vim.version()
        return string.format('v%d.%d.%d', v.major, v.minor, v.patch)
      end
      local version = get_version()

      starter.setup {
        evaluate_single = true,
        header = table.concat({
          '',
          '                █████████     █████████  ██████████  ██  █████████           ',
          '               ███░░░░░███   ███░░░░░███░░███░░░░░█ ███ ███░░░░░███          ',
          '              ░███    ░███  ███     ░░░  ░███  █ ░ ░░░ ░███    ░░░           ',
          '              ░███████████ ░███          ░██████       ░░█████████           ',
          '              ░███░░░░░███ ░███          ░███░░█        ░░░░░░░░███          ',
          '              ░███    ░███ ░░███     ███ ░███ ░   █     ███    ░███          ',
          '              █████   █████ ░░█████████  ██████████    ░░█████████           ',
          '             ░░░░░   ░░░░░   ░░░░░░░░░  ░░░░░░░░░░      ░░░░░░░░░            ',
          '                                                                             ',
          '                                                                             ',
          '                                                                             ',
          '  ██████   █████ ██████████    ███████    █████   █████ █████ ██████   ██████',
          ' ░░██████ ░░███ ░░███░░░░░█  ███░░░░░███ ░░███   ░░███ ░░███ ░░██████ ██████ ',
          '  ░███░███ ░███  ░███  █ ░  ███     ░░███ ░███    ░███  ░███  ░███░█████░███ ',
          '  ░███░░███░███  ░██████   ░███      ░███ ░███    ░███  ░███  ░███░░███ ░███ ',
          '  ░███ ░░██████  ░███░░█   ░███      ░███ ░░███   ███   ░███  ░███ ░░░  ░███ ',
          '  ░███  ░░█████  ░███ ░   █░░███     ███   ░░░█████░    ░███  ░███      ░███ ',
          '  █████  ░░█████ ██████████ ░░░███████░      ░░███      █████ █████     █████',
          ' ░░░░░    ░░░░░ ░░░░░░░░░░    ░░░░░░░         ░░░      ░░░░░ ░░░░░     ░░░░░ ',
          '',
          version,
        }, '\n'),

        items = {
          { name = 'Find files', action = 'Telescope find_files', section = 'Actions' },
          {
            name = 'Open File Tree',
            action = function()
              require('neo-tree.command').execute {
                action = 'focus',
                source = 'filesystem',
                dir = vim.fn.getcwd(),
                reveal = false,
              }
            end,
            section = 'Actions',
          },
          -- { name = 'Recent files', action = 'Telescope oldfiles', section = 'Actions' },
          -- { name = 'Config', action = 'e ~/.config/nvim', section = 'Actions' },
          { name = 'Quit', action = 'qa', section = 'Actions' },
        },
        footer = '',
        -- footer = (function()
        --   local v = vim.version()
        --   return string.format('v%d.%d.%d', v.major, v.minor, v.patch)
        -- end)(),
        query_updaters = 'foq',
        content_hooks = {
          starter.gen_hook.aligning('center', 'center'),
        },
        silent = true,
      }
    end,
  },
}
