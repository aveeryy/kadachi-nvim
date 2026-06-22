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
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        { desc = "Incremental rename", expr = true }
      )
      vim.keymap.set({ "n" }, "<leader>rr", ":IncRename ", { desc = "Incremental rename (clearing existing word)" })
    end,
  },
}
