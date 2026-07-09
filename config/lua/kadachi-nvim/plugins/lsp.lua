---@type lz.n.PluginSpec[]
return {
  {
    "luasnip",
    lazy = false,
    after = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.g.snippets_path } })
    end,
  },
  {
    "blink.cmp",
    event = "DeferredUIEnter",
    after = function()
      local opts = {
        keymap = {
          ["<c-space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
          ["<C-c>"] = { "hide" },
          ["<CR>"] = { "select_and_accept", "fallback" },
          ["<tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<s-tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<c-j>"] = { "scroll_documentation_down", "fallback" },
          ["<c-k>"] = { "scroll_documentation_up", "fallback" },
        },
        snippets = {
          preset = "luasnip",
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          providers = {
            snippets = {
              score_offset = 1,
            },
          },
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
          javascript = { "prettier" },
          lua = { "stylua" },
          markdown = { "mdformat" },
          nix = { "nixfmt" },
          python = { "black" },
          sh = { "shfmt" },
          typescript = { "prettier" },
          vue = { "prettier" },
        },
        format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      }

      require("conform").setup(opts)
    end,
  },
}
