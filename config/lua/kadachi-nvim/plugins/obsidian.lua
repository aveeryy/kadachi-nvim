local obsidian_config_file = vim.env.XDG_CONFIG_HOME .. "/obsidian/obsidian.json"
local obsidian_workspaces = {}

if vim.uv.fs_stat(obsidian_config_file) then
  local obsidian_config = vim.json.decode(vim.fn.readblob(obsidian_config_file))
  for _, vault in pairs(obsidian_config.vaults) do
    table.insert(obsidian_workspaces, { name = vim.fs.basename(vault.path), path = vault.path })
  end
end

return {
  {
    "obsidian.nvim",
    enabled = #obsidian_workspaces > 0,
    ft = { "markdown" },
    after = function()
      require("obsidian").setup({
        workspaces = obsidian_workspaces,

        completion = {
          default = true,
        },
      })
    end,
  },
}
