return {
  {
    "catppuccin-nvim",
    lazy = false,
    priority = 2000,
    after = function()
      local opts = {
        flavour = "mocha",
        no_italic = true,
        transparent_background = true,
      }

      require("catppuccin").setup(opts)

      vim.cmd.colorscheme("catppuccin-nvim")
    end,
  },
}
