return {
  "echasnovski/mini.pairs",
  version = false,
  config = function()
    require("mini.pairs").setup()

    -- Smart <CR> inside {} [] ()
    vim.keymap.set("i", "<CR>", function()
      local col = vim.fn.col(".")
      local line = vim.fn.getline(".")
      local prev = line:sub(col - 1, col - 1)
      local next = line:sub(col, col)

      if (prev == "{" and next == "}")
        or (prev == "[" and next == "]")
        or (prev == "(" and next == ")") then
        return "<CR><Esc>O"
      end

      return "<CR>"
    end, { expr = true })
  end,
}
