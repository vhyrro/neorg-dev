return {
    presence = function(config)
        plugin "presence.nvim" {
            "andweeb/presence.nvim",
            config = function()
                require("presence"):setup(config)
            end,
        }
    end,
}
