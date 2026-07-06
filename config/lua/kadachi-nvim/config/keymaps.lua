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

-- Diagnostics
vim.keymap.set({ "n" }, "<leader>gd", "<C-]>", { desc = "Go to definition under cursor" })
vim.keymap.set({ "n" }, "<leader>dp", getDiagnosticJumpFunction(-1), { desc = "Go to previous diagnostic" })
vim.keymap.set({ "n" }, "<leader>dn", getDiagnosticJumpFunction(1), { desc = "Go to next diagnostic" })

-- Tools
vim.keymap.set({ "n" }, "<leader>lg", ":terminal lazygit<CR>", { desc = "Open lazygit" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system's clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system's clipboard" })
