return {
  {
    "catppuccin-nvim",
    lazy = false,
    priority = 1,
    after = function()
      local C = require("catppuccin.palettes").get_palette("mocha")

      local opts = {
        flavour = "mocha",
        no_italic = true,
        transparent_background = true,
        float = {
          transparent = true,
        },
        integrations = {
          fzf = true,
          lualine = {
            all = {
              normal = {
                x = { bg = C.mantle, fg = C.red, gui = "bold" },
              },
              insert = {
                x = { bg = C.mantle, fg = C.red, gui = "bold" },
              },
              terminal = {
                x = { bg = C.mantle, fg = C.red, gui = "bold" },
              },
              command = {
                x = { bg = C.mantle, fg = C.red, gui = "bold" },
              },
              visual = {
                x = { bg = C.mantle, fg = C.red, gui = "bold" },
              },
              replace = {
                x = { bg = C.mantle, fg = C.red, gui = "bold" },
              },
            },
          },
        },
      }

      require("catppuccin").setup(opts)

      vim.cmd.colorscheme("catppuccin-nvim")
    end,
  },
}
