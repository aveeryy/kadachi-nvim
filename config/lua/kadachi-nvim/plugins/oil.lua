return {
  {
    "oil.nvim",
    lazy = false,
    after = function()
      require("oil").setup()

      vim.keymap.set({ "n" }, "<leader>fe", "<cmd>Oil --float<CR>")
    end,
  },
}
