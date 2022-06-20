return {
    -- TODO: Change function name to "neorg" once the `neorg` global is removed
    neorg_setup = function(options)
        -- Declare the plenary plugin
        local plenary = plugin "plenary.nvim"

        -- If the plugin is already defined then don't override its data.
        if not plenary.active then
            plenary {
                "nvim-lua/plenary.nvim",
                module = "plenary",
            }
        end

        -- Declare the neorg plugin
        local neorg = plugin "neorg"

        options = options or {}
        options.modules = options.modules or {
            ["core.defaults"] = {},
        }

        if options.workspaces then
            options.modules["core.norg.dirman"] = {
                config = {
                    workspaces = options.workspaces,
                }
            }
        end

        if options.treesitter then
            options.modules["core.integrations.treesitter"] = {
                config = {
                    parser_configs = options.treesitter,
                }
            }
        end

        -- Send the packaged plugin to be managed by packer
        neorg {
            options.path or "nvim-neorg/neorg",
            after = "nvim-treesitter",
            requires = { "plenary.nvim" },
            config = function()
                require("neorg").setup({
                    load = options.modules
                })
            end,
        }
    end,
}
