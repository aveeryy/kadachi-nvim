return {
  {
    "grug-far.nvim",
    event = "DeferredUIEnter",
    after = function()
      local grug_far = require("grug-far")
      grug_far.setup({})

      vim.keymap.set({ "n" }, "<leader>fr", function()
        grug_far.open({ transient = true })
      end)
    end,
  },
}
