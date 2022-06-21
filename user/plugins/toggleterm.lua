return {
    toggleterm = function(config)
        plugin "toggleterm.nvim" {
            "akinsho/toggleterm.nvim",
            module = "toggleterm",
            cmd = "ToggleTerm",

            config = function()
                require("toggleterm").setup(config)
            end,
        }
    end,
}
