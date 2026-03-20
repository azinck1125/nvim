local group = vim.api.nvim_create_augroup('autosave', { clear = true })

vim.opt.updatetime = 300
vim.g.autosave_enabled = true

local ignore_paths = {
  vim.fn.stdpath('config'),
}

local function is_ignored(filepath)
  if filepath == nil or filepath == '' then
    return true
  end

  filepath = vim.fs.normalize(filepath)

  for _, path in ipairs(ignore_paths) do
    path = vim.fs.normalize(path)

    -- only ignore if file is actually inside that directory
    if filepath == path or filepath:find(path .. '/', 1, true) == 1 then
      return true
    end
  end

  return false
end

function _G.autosave_is_active()
  if not vim.g.autosave_enabled then
    return false
  end

  local filepath = vim.fn.expand '%:p'

  if is_ignored(filepath) then
    return false
  end

  if vim.bo.filetype == 'gitcommit' then
    return false
  end

  if vim.bo.buftype ~= '' then
    return false
  end

  if not vim.bo.modifiable then
    return false
  end

  return true
end

local function save()
  if not _G.autosave_is_active() then
    return
  end

  if vim.bo.modified then
    pcall(vim.cmd, 'silent write')
  end
end

vim.api.nvim_create_autocmd({ 'InsertLeave', 'CursorHold' }, {
  group = group,
  callback = save,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'FileType' }, {
  group = group,
  callback = function()
    vim.cmd 'redrawstatus'
  end,
})

vim.keymap.set('n', '<leader>ua', function()
  vim.g.autosave_enabled = not vim.g.autosave_enabled
  vim.cmd 'redrawstatus'

  local msg
  if not vim.g.autosave_enabled then
    msg = 'OFF'
  elseif _G.autosave_is_active() then
    msg = 'ON'
  else
    msg = 'OFF (BUFFER)'
  end

  print('Autosave: ' .. msg)
end, { desc = 'Toggle autosave' })

return {}
