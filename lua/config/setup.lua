return function(is_fresh_install)
    local config_path = vim.fn.stdpath("config")

    package.loaded["config.environment"] = nil
    local isolated_environment = require("config.environment")

    local string_metatable = debug.getmetatable("")
    local old_string_metatable = vim.deepcopy(string_metatable)

    string_metatable.__div = function(a, b)
        if type(a) == "string" then
            local keymaps = (type(b) == "string" and { b } or b)
            local modes = {}

            for mode in a:gmatch("%w") do
                table.insert(modes, mode)
            end

            return setmetatable({
                modes = modes,
                keymaps = keymaps,
                attributes = {},
            }, {
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

    debug.setmetatable("", string_metatable)

    -- Run the user configuration
    setfenv(isolated_environment.wrap(dofile, config_path .. "/user/init.lua"), setmetatable(_G, { __index = isolated_environment }))()

    debug.setmetatable("", old_string_metatable)

    -- Run post scripts
    isolated_environment.post()

    vim.cmd("packadd packer.nvim")

    local packer = require('packer')
    local packer_async = require('packer.async')

    packer.init({
        autoremove = true
    })

    packer.startup(function(use)
        use {
            "wbthomason/packer.nvim",
            opt = true,
        }

        use {
            "nvim-neorg/neorg"
        }

        -- Yes I do indeed spell colourscheme the bri'ish way
        if isolated_environment.state.colourscheme then
            use {
                isolated_environment.state.colourscheme.path,
                config = "vim.cmd 'colorscheme " .. isolated_environment.state.colourscheme.name .. "'",
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
