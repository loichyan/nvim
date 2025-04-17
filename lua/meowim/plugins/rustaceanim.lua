---@type MeoSpec
return {
    "mrcjkb/rustaceanvim",
    event = "LazyFile",
    config = function() vim.g.rustaceanvim = { server = {} } end,
}
