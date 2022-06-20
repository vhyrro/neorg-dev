return {
    neogit = function(config)
        -- TODO: Make a try_make_plugin or try_plugin function
        -- to abstract this boilerplate

        local plenary = plugin "plenary.nvim"

        if not plenary.active then
            plenary {
                "nvim-lua/plenary.nvim",
                module = "plenary",
            }
        end

        plugin "neogit" {
            "TimUntersberger/neogit",
            requires = { "plenary.nvim" },
            config = function()
                require("neogit").setup(config)
            end,
        }
    end,
}
