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

vim.keymap.set({ "n" }, "<leader>gd", "<C-]>", { desc = "Go to definition under cursor" })
vim.keymap.set({ "n" }, "<leader>dp", getDiagnosticJumpFunction(-1), { desc = "Go to previous diagnostic" })
vim.keymap.set({ "n" }, "<leader>dn", getDiagnosticJumpFunction(1), { desc = "Go to next diagnostic" })
