return {
  {
    "fzf-lua",
    event = "DeferredUIEnter",
    after = function()
      local fzf_lua = require("fzf-lua")

      fzf_lua.setup()

      vim.ui.select = require("fzf-lua.providers.ui_select").ui_select

      vim.keymap.set({ "n" }, "<leader>bb", fzf_lua.buffers)
      vim.keymap.set({ "n" }, "<leader>ca", function()
        fzf_lua.lsp_code_actions({
          filter = function(code_action, _)
            return not code_action.disabled
          end,
          previewer = "none",
        })
      end)
      vim.keymap.set({ "n" }, "<leader>dg", function()
        fzf_lua.diagnostics_document({
          multiline = 1,
          previewer = "none",
        })
      end)
      vim.keymap.set({ "n" }, "<leader>ff", fzf_lua.files)
      vim.keymap.set({ "n" }, "<leader>fg", fzf_lua.live_grep)
    end,
  },
}
