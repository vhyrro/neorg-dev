return {
    neogen = function(config)
        plugin "neogen" {
            "danymat/neogen",
            cmd = "Neogen",
            config = function()
                require("neogen").setup(config)
            end,
        }
    end,
}
