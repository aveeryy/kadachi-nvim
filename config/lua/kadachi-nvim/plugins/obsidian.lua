return {
  {
    "obsidian.nvim",
    event = "DeferredUIEnter",
    after = function()
      local obsidian_config_file = vim.env.XDG_CONFIG_HOME .. "/obsidian/obsidian.json"
      local obsidian_workspaces = {}

      if vim.uv.fs_stat(obsidian_config_file) then
        local obsidian_config = vim.json.decode(vim.fn.readblob(obsidian_config_file))
        for _, vault in pairs(obsidian_config.vaults) do
          table.insert(obsidian_workspaces, { name = vim.fs.basename(vault.path), path = vault.path })
        end
      end

      if #obsidian_workspaces == 0 then
        return
      end

      require("obsidian").setup({
        workspaces = obsidian_workspaces,

        legacy_commands = false,

        completion = {
          default = true,
        },

        daily_notes = {
          folder = "Diarias",
          date_format = "YYYY/MM/YYYY-MM-DD",
        },

        frontmatter = {
          enabled = false,
        },

        ui = {
          enable = false,
        },
      })

      vim.keymap.set({ "n" }, "<leader>ow", "<cmd>Obsidian workspace<CR>")
      vim.keymap.set({ "n" }, "<leader>od", "<cmd>Obsidian today<CR>")
    end,
  },
}
