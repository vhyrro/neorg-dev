return {
    telescope = function(config)
        local plenary = plugin "plenary.nvim"

        if not plenary.active then
            plenary {
                "nvim-lua/plenary.nvim",
                module = "plenary",
            }
        end

        plugin "telescope.nvim" {
            "nvim-telescope/telescope.nvim",
            cmd = "Telescope",
            config = function()
                require("telescope").setup(config)
            end,
        }
    end,
}
