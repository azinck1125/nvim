return {
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
        hl.TerminalNormal = { bg = '#0C0D14' }

        -- Messing around
        hl.FoldColumn = { bg = c.bg_dark }

        -- imports modification
        vim.api.nvim_create_autocmd('ColorScheme', {
          callback = function()
            vim.api.nvim_set_hl(0, '@keyword.import', { link = 'Keyword' })
            vim.api.nvim_set_hl(0, '@module', { link = 'Identifier' })
          end,
        })
        vim.api.nvim_set_hl(0, 'AutoSaveOn', { fg = c.green2, bold = false }) -- green
        vim.api.nvim_set_hl(0, 'AutoSaveIgnored', { fg = c.warning, bold = false }) -- green
        vim.api.nvim_set_hl(0, 'AutoSaveOff', { fg = c.blue, bold = false }) -- red
      end,
    }
    vim.cmd.colorscheme 'tokyonight-moon'
  end,
}
