---@type lz.n.PluginSpec[]
return {
  {
    "blink.cmp",
    event = "DeferredUIEnter",
    after = function()
      local opts = {
        keymap = {
          ["<c-space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
          ["<C-e>"] = { "hide" },
          ["<CR>"] = { "select_and_accept", "fallback" },
          ["<tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<s-tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<c-j>"] = { "scroll_documentation_down", "fallback" },
          ["<c-k>"] = { "scroll_documentation_up", "fallback" },
        },
        completion = {
          ghost_text = {
            enabled = true,
          },
        },
        sources = {
          default = { "lsp", "path", "snippets" },
        },
      }
      require("blink.cmp").setup(opts)
    end,
  },
  {
    "conform.nvim",
    event = "DeferredUIEnter",
    after = function()
      ---@type conform.setupOpts
      local opts = {
        formatters = {
          mdformat = {
            append_args = { "--number" },
          },
        },
        formatters_by_ft = {
          bash = { "shfmt" },
          lua = { "stylua" },
          markdown = { "mdformat" },
          nix = { "nixfmt" },
          python = { "black" },
          sh = { "shfmt" },
        },
        format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      }

      require("conform").setup(opts)
    end,
  },
}
