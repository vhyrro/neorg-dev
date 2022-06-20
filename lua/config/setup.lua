return function(is_fresh_install)
    local config_path = vim.fn.stdpath("config")

    package.loaded["config.environment"] = nil

    local isolated_environment = require("config.environment")

    -- TODO: Document why we leak this out into the global namespace
    _G.neorg_dev = {
        state = isolated_environment.state,
        plugin_data = {},
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
        autoremove = true,
    })

    packer.startup(function(use)
        local make_plugin = isolated_environment.make_plugin
        local plugin = isolated_environment.plugin

        make_plugin(plugin "packer.nvim", {
            "wbthomason/packer.nvim",
            opt = true,
        })

        -- Yes I do indeed spell colourscheme the bri'ish way
        if isolated_environment.state.colourscheme then
            make_plugin(plugin(isolated_environment.state.colourscheme.name), {
                isolated_environment.state.colourscheme.path,
                config = function()
                    vim.cmd("colorscheme " .. isolated_environment.state.colourscheme.name)
                end,
            })
        end

        for name, plugin_data in pairs(isolated_environment.plugins) do
            local real_plugin_name = plugin_data.packer_data[1]:match("/(.+)$")

            use(vim.tbl_deep_extend("keep", plugin_data.packer_data, { as = (real_plugin_name ~= name and name) }))
        end

        if is_fresh_install then
            vim.api.nvim_create_autocmd("User", {
                pattern = "PackerComplete",
                once = true,

                callback = function()
                    -- TODO: Do we need this?
                    -- for name in pairs(isolated_environment.plugins) do
                    --     vim.cmd("silent packadd " .. name)
                    -- end

                    vim.notify("Plugins have been installed - a restart of Neovim is heavily recommended.")
                end,
            })

            vim.notify("Installing plugins...")

            packer.sync()
        end
    end)
end
