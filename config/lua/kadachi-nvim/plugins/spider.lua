return {
  {
    "nvim-spider",
    event = "DeferredUIEnter",
    after = function()
      local s = require("spider")
      s.setup({ subwordMovement = true })

      vim.keymap.set({ "n", "o", "x" }, "b", function()
        s.motion("b")
      end)

      vim.keymap.set({ "n", "o", "x" }, "w", function()
        s.motion("w")
      end)

      vim.keymap.set({ "n", "o", "x" }, "e", function()
        s.motion("e")
      end)

      vim.keymap.set({ "n", "o", "x" }, "ge", function()
        s.motion("ge")
      end)
    end,
  },
}
