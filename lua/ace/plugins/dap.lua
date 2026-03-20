return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- UI
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
      },

      -- Inline values
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },

      -- Python helper (installs/uses debugpy)
      { 'mfussenegger/nvim-dap-python' },

      -- Adapter installer
      { 'williamboman/mason.nvim' },
      { 'jay-babu/mason-nvim-dap.nvim' },
    },
    keys = {
      -- breakpoints
      { '<F9>', function() require('dap').toggle_breakpoint() end, desc = 'DAP: Toggle breakpoint' },
      { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'DAP: Toggle breakpoint' },
      { '<leader>B', function() require('dap').clear_breakpoints() end, desc = 'DAP: Clear all breakpoints' },
      {
        '<leader>dB',
        function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        desc = 'DAP: Conditional breakpoint',
      },

      -- run control
      { '<F5>', function() require('dap').continue() end, desc = 'DAP: Continue' },
      { '<F6>', function() require('dap').step_over() end, desc = 'DAP: Step over' },
      { '<F8>', function() require('dap').step_into() end, desc = 'DAP: Step into' },
      { '<F10>', function() require('dap').terminate() end, desc = 'DAP: Terminate' },
      { '<S-F11>', function() require('dap').step_out() end, desc = 'DAP: Step out' },

      -- UI + helpers
      { '<leader>du', function() require('dapui').toggle() end, desc = 'DAP: Toggle UI' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'DAP: REPL' },
      { '<leader>dl', function() require('dap').run_last() end, desc = 'DAP: Run last' },
      { '<leader>dh', function() require('dap.ui.widgets').hover() end, desc = 'DAP: Hover' },
      { '<leader>dp', function() require('dap.ui.widgets').preview() end, desc = 'DAP: Preview' },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Install adapters via Mason
      require('mason').setup()
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        ensure_installed = {
          'python', -- debugpy
          -- add more later (node2, chrome, etc.) if you want
        },
      }

      -- Solid background for DAP UI windows (transparent Normal doesn't apply here)
      local dapui_hl = 'Normal:NormalSolid,SignColumn:NormalSolid,EndOfBuffer:NormalSolid'

      local function apply_dapui_bg()
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft:match '^dapui_' or ft == 'dap-repl' then vim.wo[win].winhighlight = dapui_hl end
          end
        end)
      end

      vim.api.nvim_create_autocmd('BufWinEnter', {
        pattern = '*',
        callback = function()
          local ft = vim.bo.filetype
          if ft:match '^dapui_' or ft == 'dap-repl' then vim.wo.winhighlight = dapui_hl end
        end,
      })

      -- Persistent DAP terminal — survives dapui.close(), cleaned up on next launch
      local dap_term = { buf = nil, win = nil }

      local function cleanup_dap_term()
        if dap_term.win and vim.api.nvim_win_is_valid(dap_term.win) then vim.api.nvim_win_close(dap_term.win, true) end
        if dap_term.buf and vim.api.nvim_buf_is_valid(dap_term.buf) then vim.api.nvim_buf_delete(dap_term.buf, { force = true }) end
        dap_term = { buf = nil, win = nil }
      end

      local function find_dap_terminal_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal' then
            local name = vim.api.nvim_buf_get_name(buf)
            if name:match 'dap%-terminal' then return buf end
          end
        end
        return nil
      end

      local function persist_dap_terminal()
        if dap_term.win and vim.api.nvim_win_is_valid(dap_term.win) then return end
        local buf = find_dap_terminal_buf()
        dapui.close()
        if not buf then return end
        vim.cmd 'botright split'
        vim.cmd 'resize 12'
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        vim.wo[win].winhighlight = dapui_hl
        dap_term.buf = buf
        dap_term.win = win
        vim.cmd 'wincmd p'
      end

      -- UI setup
      dapui.setup {
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.35 },
              { id = 'breakpoints', size = 0.20 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.20 },
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 12,
            position = 'bottom',
          },
        },
      }

      -- Auto open/close UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
        apply_dapui_bg()
      end
      dap.listeners.after.event_terminated['dapui_config'] = persist_dap_terminal
      dap.listeners.after.event_exited['dapui_config'] = persist_dap_terminal

      -- Nicer signs (optional)
      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })

      -- Python configuration
      -- mason-nvim-dap installs debugpy; nvim-dap-python needs a path to the python that has debugpy.
      -- This uses Mason's debugpy venv automatically.
      local mason_path = vim.fn.stdpath 'data' .. '/mason'
      local debugpy_python = mason_path .. '/packages/debugpy/venv/bin/python'
      require('dap-python').setup(debugpy_python)

      -- For CLI tools: prompt for args when launching
      require('dap-python').test_runner = 'pytest' -- harmless; you can change later

      -- Add a convenient "debug file" config that asks for args
      dap.configurations.python = dap.configurations.python or {}
      table.insert(dap.configurations.python, 1, {
        type = 'python',
        request = 'launch',
        name = 'Python: file (args prompt)',
        program = '${file}',
        console = 'integratedTerminal',
        args = function()
          local input = vim.fn.input 'Args: '
          if input == nil or input == '' then return {} end
          -- simple shell-ish split
          return vim.fn.split(input, ' ')
        end,
      })

      -- Override launch keymaps to clean up persisted terminal BEFORE starting a new session
      vim.keymap.set('n', '<F5>', function()
        cleanup_dap_term()
        dap.continue()
      end, { desc = 'DAP: Continue' })
      vim.keymap.set('n', '<leader>dl', function()
        cleanup_dap_term()
        dap.run_last()
      end, { desc = 'DAP: Run last' })
    end,
  },
}
