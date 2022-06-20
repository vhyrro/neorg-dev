return {
    neogit = function(config)
        -- TODO: Make a try_make_plugin or try_plugin function
        -- to abstract this boilerplate

        local plenary = "plenary.nvim"

        if not plenary.active then
            make_plugin(plenary, {
                "nvim-lua/plenary.nvim",
                module = "plenary",
            })
        end

        local neogit = plugin "neogit" {
            data = config,
        }

        make_plugin(neogit, {
            config = function()
                -- TODO:
            end,
        })
    end,
}
