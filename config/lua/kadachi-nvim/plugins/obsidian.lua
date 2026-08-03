return {
  {
    "obsidian.nvim",
    event = "DeferredUIEnter",
    after = function()
      local config_path = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
      local obsidian_config_file = config_path .. "/obsidian/obsidian.json"
      local obsidian_workspaces = {}
      local isInsideWorkspace = false

      if vim.uv.fs_stat(obsidian_config_file) then
        local obsidian_config = vim.json.decode(vim.fn.readblob(obsidian_config_file))
        for _, vault in pairs(obsidian_config.vaults) do
          table.insert(obsidian_workspaces, { name = vim.fs.basename(vault.path), path = vault.path })
          if vim.env.PWD:match(vault.path) then
            isInsideWorkspace = true
          end
        end
      end

      if #obsidian_workspaces == 0 then
        return
      end

      local obsidian = require("obsidian")

      obsidian.setup({
        workspaces = obsidian_workspaces,

        legacy_commands = false,

        checkbox = {
          enabled = true,
          create_new = true,
          order = { " ", "/", "x" },
        },

        completion = {
          default = true,
        },

        daily_notes = {
          folder = "Diarias",
          date_format = "YYYY/MM/YYYY-MM-DD",
        },

        footer = {
          enabled = false,
        },

        frontmatter = {
          enabled = false,
        },

        ui = {
          enable = false,
        },
      })

      vim.keymap.set({ "n" }, "<leader>ow", "<cmd>Obsidian workspace<CR>")
      vim.keymap.set({ "n" }, "<leader>of", "<cmd>Obsidian quick_switch<CR>")
      vim.keymap.set({ "n" }, "<leader>og", "<cmd>Obsidian search<CR>")
      vim.keymap.set({ "n" }, "<leader>od", "<cmd>Obsidian today<CR>")

      vim.api.nvim_create_autocmd("User", {
        pattern = "ObsidianNoteEnter",
        callback = function()
          vim.keymap.set({ "n", "v", "i" }, "<C-l>", "<cmd>Obsidian toggle_checkbox<cr>", {
            buffer = true,
            desc = "Toggle checkbox",
          })
        end,
      })

      -- Set the default workspace if not inside one
      if not isInsideWorkspace then
        if vim.env.PWD:match(vim.env.HOME .. "/Trabajo") or vim.uv.os_gethostname() == "mizuki" then
          obsidian.Workspace.set("Trabajo")
        else
          obsidian.Workspace.set("Personal")
        end
      end
    end,
  },
}
