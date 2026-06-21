return {
  {
    "lualine.nvim",
    event = "DeferredUIEnter",
    after = function()
      local lualine = require("lualine")

      local function show_macro_recording()
        local recording_register = vim.fn.reg_recording()
        if recording_register ~= "" then
          return " REC @" .. recording_register
        end
        return ""
      end

      local catppuccin = require("catppuccin.utils.lualine")("mocha")

      lualine.setup({
        options = {
          theme = catppuccin,
          component_separators = "",
          section_separators = "",
          refresh = {
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
              "RecordingEnter",
              "RecordingLeave",
            },
          },
        },
        sections = {
          lualine_x = {
            {
              "macro-recording",
              fmt = show_macro_recording,
            },
          },
          lualine_y = {},
        },
      })
    end,
  },
  {
    "mini.icons",
    lazy = false,
    after = function()
      require("mini.icons").setup({})
    end,
  },
}
