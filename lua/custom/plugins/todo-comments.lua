return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    signs = false,

    -- easy place to grow later
    keywords = {
      -- FIX: This is a fix line
      FIX = {
        icon = ' ',
        color = 'error',
        -- ISSUE: This is a FIX alt line
        alt = {
          'FIXME',
          'BUG',
          'FIXIT',
          'ISSUE',
        },
      },
      -- TODO: This is a todo line
      TODO = { icon = ' ', color = 'info' },
      -- HACK: This is a hack line
      HACK = { icon = ' ', color = 'warning' },
      -- WARN: This is a warn line
      WARN = { icon = ' ', color = 'warning' },
      -- NOTE: This is a note line
      NOTE = { icon = ' ', color = 'hint' },
      -- REFACTOR: This is a refactor line
      REFACTOR = {
        icon = '󰁨 ', -- wrench/structure vibe, nerdy but great
        color = 'test',
        alt = { 'CLEANUP', 'REWRITE', 'RESTRUCTURE' },
      },
      -- IDEA: This is an idea line
      IDEA = { icon = ' ', color = 'test', alt = { 'THINK', 'BRAINSTORM' } },
      -- Q: This is a question line
      QUESTION = { icon = ' ', color = 'info', alt = { 'Q', 'WHY' } },
      -- PERF: This is a performance line
      PERF = { icon = "󰓅 ", color = "warning", alt = { "OPTIM", "PERFORMANCE" } },
      -- VULN: This is a vulnurability line
      SECURITY = { icon = "󰒃 ", color = "error", alt = { "VULN", "SAFE" } },
      -- TEMP: This is a temp line
      TEMP = { icon = "󰒤 ", color = "hint", alt = { "TMP", "REMOVE" } },
      -- TEST: this is a test line
      TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "CHECK" } },
    },
  },
}
