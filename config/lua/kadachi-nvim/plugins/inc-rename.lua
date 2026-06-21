return {
  {
    "inc-rename.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("inc_rename").setup({})

      vim.keymap.set(
        {
          "n",
        },
        "<leader>rr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        { desc = "Incremental rename" }
      )
      vim.keymap.set({ "n" }, "<leader>rr", ":IncRename ", { desc = "Incremental rename (clearing existing word)" })
    end,
  },
}
