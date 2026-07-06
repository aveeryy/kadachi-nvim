vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
  desc = "Automatically resize windows when the host window size changes.",
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "BufWinEnter", "WinEnter", "TermOpen" }, {
  pattern = "term://*",
  callback = function()
    vim.api.nvim_command("startinsert")
  end,
})

vim.api.nvim_create_autocmd({ "TermClose" }, {
  pattern = "term://*",
  callback = function()
    vim.api.nvim_input("<CR>")
  end,
  desc = "Press ENTER when closing a terminal to skip the 'Process exited' text",
})
