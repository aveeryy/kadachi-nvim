local M = {}

local function merge_tables(table1, table2)
  for key, value in pairs(table2) do
    table1[key] = value
  end

  return table1
end

local function get_floating_window_size()
  local max_height = vim.o.lines - 1
  local max_width = vim.o.columns

  local win_height = math.ceil(max_height / 1.1)
  local start_row = math.floor((max_height - win_height) / 2)
  local win_width = math.ceil(max_width / 1.2)
  local start_col = math.floor((max_width - win_width) / 2)

  return {
    row = start_row,
    col = start_col,
    width = win_width,
    height = win_height,
  }
end

function M.open_floating_window(buf, title)
  local win =
    vim.api.nvim_open_win(buf, true, merge_tables({ relative = "editor", title = title }, get_floating_window_size()))

  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      vim.api.nvim_win_set_config(win, merge_tables(vim.api.nvim_win_get_config(win), get_floating_window_size()))
    end,
  })
end

return M
