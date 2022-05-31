return function(is_fresh_install)
    local config_path = vim.fn.stdpath("config")

    package.loaded["config.environment"] = nil

    local isolated_environment = require("config.environment")

    -- TODO: Document why we leak this out into the global namespace
    _G.neorg_dev = {
        state = isolated_environment.state,
    }

    local string_metatable = debug.getmetatable("")
    local old_string_metatable = vim.deepcopy(string_metatable)

    string_metatable.__div = function(a, b)
        if type(a) == "string" then
            local keymaps = (type(b) == "string" and { b })
            local modes = {}

            for mode in a:gmatch("%w") do
                table.insert(modes, mode)
            end

            return setmetatable(keymaps and {
                modes = modes,
                keymaps = keymaps,
                attributes = {},
            } or vim.tbl_deep_extend("force", {
                modes = modes,
                attributes = {},
                keymaps = {}
            }, b), {
                __add = string_metatable.__add,
                __div = string_metatable.__div,
                __mod = string_metatable.__mod,
            })
        elseif type(a) == "table" and a.modes and a.keymaps then
            a.rhs = b
            return a
        else
            -- error
            return {}
        end
    end

    string_metatable.__add = function(a, b)
        a.attributes[b] = true
        return a
    end

    string_metatable.__mod = function(a, b)
        a.attributes.desc = b
        return a
    end

    string_metatable.__sub = function(a, b)
        local keymaps = (type(b) == "string" and { b } or b)
        local modes = {}

        for mode in a:gmatch("%w") do
            table.insert(modes, mode)
        end

        return {
            modes = modes,
            keymaps = keymaps,
            remove = true,
        }
    end

    string_metatable.__unm = function(a)
        return {
            keymaps = { a },
            modes = "",
            remove = true,
        }
    end

    string_metatable.__pow = function(a, b)
        return {
            keymaps = (type(a) == "string" and { a } or a),
            swap = b,
        }
    end

    debug.setmetatable("", string_metatable)

    --> Run the user configuration
    -- NOTE: `setfenv` does not work as intended here and always breaks. To
    -- combat this, we're globally setting _G's metatable here temporarily
    -- instead.
    setmetatable(_G, { __index = isolated_environment })

    dofile(config_path .. "/user/init.lua")

    -- Reset the global variable's metatable to not accidentally leak globals
    -- into other parts of code.
    setmetatable(_G, nil)

    debug.setmetatable("", old_string_metatable)

    -- Run post scripts
    isolated_environment.post()

    vim.cmd("packadd packer.nvim")

    local packer = require('packer')
    local packer_async = require('packer.async')

    packer.init({
        autoremove = true
    })

    packer.startup(function(packer_use)
        local use = function(...)
            packer_use(...)
            isolated_environment.state.plugin_count = isolated_environment.state.plugin_count + 1
        end

        isolated_environment.state.plugin_count = 0

        use {
            "wbthomason/packer.nvim",
            opt = true,
        }

        -- Yes I do indeed spell colourscheme the bri'ish way
        if isolated_environment.state.colourscheme then
            use {
                isolated_environment.state.colourscheme.path,
                config = "vim.cmd 'colorscheme " .. isolated_environment.state.colourscheme.name .. "'",
            }
        end

        if isolated_environment.state.treesitter_language_list then
            use {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                config = function()
                    require("nvim-treesitter.configs").setup({
                        ensure_installed = _G.neorg_dev.state.treesitter_language_list,

                        highlight = {
                            enable = true,
                        }
                    })
                end
            }
        end

        if is_fresh_install then
            vim.api.nvim_create_autocmd("User", {
                pattern = "PackerComplete",
                once = true,

                callback = function()
                    vim.notify("Plugins installed")
                end,
            })

            vim.notify("Installing plugins...")

            packer.sync()
        end
    end)
end
