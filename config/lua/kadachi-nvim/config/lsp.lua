local servers = {
    lua_ls = {},
    nil_ls = {},
}

for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end
