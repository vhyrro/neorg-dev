return {
    gitsigns = function(config)
        make_plugin(plugin "gitsigns.nvim", {
            "lewis6991/gitsigns.nvim",
            config = function()
                require('gitsigns').setup(config)
            end,
        })
    end,
}
