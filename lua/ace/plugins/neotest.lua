return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neotest/nvim-nio',
    'nvim-treesitter/nvim-treesitter',
    'marilari88/neotest-vitest',
  },
  config = function()
    local lib = require 'neotest.lib'

    --- Walk up from `path` to find the monorepo root.
    --- Prefers vitest workspace files, then falls back to package.json with "workspaces",
    --- then falls back to .git root. This makes it work across different monorepo layouts.
    ---@param path string
    ---@return string|nil
    local function find_monorepo_root(path)
      -- 1. Vitest workspace file → definitive monorepo root
      local ws_root = lib.files.match_root_pattern(
        'vitest.workspace.ts',
        'vitest.workspace.js',
        'vitest.workspace.mts',
        'vitest.workspace.mjs'
      )(path)
      if ws_root then
        return ws_root
      end

      -- 2. Walk up looking for a package.json with a "workspaces" field (npm/yarn/pnpm)
      local dir = vim.fn.fnamemodify(path, ':p:h')
      while dir and dir ~= '/' do
        local pj = dir .. '/package.json'
        local ok, content = pcall(lib.files.read, pj)
        if ok then
          local parsed = vim.json.decode(content)
          if parsed and parsed.workspaces then
            return dir
          end
        end

        -- Also check for pnpm-workspace.yaml
        if vim.uv.fs_stat(dir .. '/pnpm-workspace.yaml') then
          return dir
        end

        dir = vim.fn.fnamemodify(dir, ':h')
      end

      -- 3. Fallback: git root (covers non-workspace monorepos)
      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.fnamemodify(path, ':h')) .. ' rev-parse --show-toplevel')[1]
      if vim.v.shell_error == 0 and git_root and git_root ~= '' then
        return git_root
      end

      return nil
    end

    require('neotest').setup {
      adapters = {
        require 'neotest-vitest' {
          ---Resolve cwd: use the nearest vitest config dir (sub-package),
          ---falling back to the monorepo root. This ensures vitest runs with
          ---the right config for each package in a workspace monorepo.
          cwd = function(path)
            -- Prefer nearest vitest/vite config (sub-package level)
            local config_root = lib.files.match_root_pattern(
              'vitest.config.ts',
              'vitest.config.js',
              'vitest.config.mts',
              'vitest.config.mjs',
              'vite.config.ts',
              'vite.config.js'
            )(path)
            if config_root then
              return config_root
            end

            -- Fall back to monorepo root
            return find_monorepo_root(path) or vim.uv.cwd()
          end,

          -- Skip directories that will never contain tests
          filter_dir = function(name, _relpath, _root)
            return name ~= 'node_modules'
              and name ~= '.git'
              and name ~= 'dist'
              and name ~= 'build'
              and name ~= 'coverage'
              and name ~= '.nx'
              and name ~= 'cdk.out'
          end,
        },
      },
      -- Use the monorepo root for the test tree so all packages appear under one tree
      discovery = {
        enabled = true,
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

