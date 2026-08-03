local utils = require("kadachi-nvim.utils")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local function getDiagnosticJumpFunction(count)
  return function()
    vim.diagnostic.jump({
      count = count,
      severity = {
        min = vim.diagnostic.severity.WARN,
      },
      wrap = true,
    })
  end
end

-- Keep screen centered on jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- LSP
vim.keymap.set({ "n" }, "gd", vim.lsp.buf.definition, { desc = "Go to definition under cursor" })
vim.keymap.set({ "n" }, "<leader>dp", getDiagnosticJumpFunction(-1), { desc = "Go to previous diagnostic" })
vim.keymap.set({ "n" }, "<leader>dn", getDiagnosticJumpFunction(1), { desc = "Go to next diagnostic" })

-- Tools
vim.keymap.set({ "n" }, "<leader>lg", function()
  local buf = vim.api.nvim_create_buf(false, true)
  utils.open_floating_window(buf, "lazygit")
  vim.api.nvim_command(":terminal lazygit")
end, { desc = "Open lazygit in a floating window" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system's clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system's clipboard" })
