local environment = require("config.utilities")

environment.state = {}
environment.plugins = {}

environment.require = function(module_path)
    package.loaded[module_path] = nil
    return require(module_path)
end

environment.template = function(template_name)
    -- TODO: Better errors
    pcall(environment.require, "templates." .. template_name)
end

environment.editing = function(options)
    local function set_options(keys, value)
        return function()
            for _, key in ipairs(keys) do
                vim.opt[key] = value
            end
        end
    end

    for key, value in pairs(options) do
        environment.match(key) {
            indent = set_options({ "shiftwidth", "tabstop", "softtabstop" }, value),
            spaces = set_options({ "expandtab" }, value)
        }
    end
end

environment.colorscheme = function(path, name)
    environment.state.colourscheme = {
        path = path,
        name = name,
    }
end

environment.colourscheme = environment.colorscheme

environment.keybinds = function(keybinds)
    for _, keybind_data in ipairs(keybinds) do
        for _, keymap in ipairs(keybind_data.keymaps) do
            if keybind_data.swap then
                vim.keymap.set(keybind_data.modes, keymap, keybind_data.swap, keybind_data.attributes)
                vim.keymap.set(keybind_data.modes, keybind_data.swap, keymap, keybind_data.attributes)
            elseif keybind_data.remove then
                vim.keymap.del(keybind_data.modes, keymap)
            else
                vim.keymap.set(keybind_data.modes, keymap, keybind_data.rhs, keybind_data.attributes)
            end
        end
    end
end

environment.import = function(file_or_prefix)
    local ok, module = pcall(environment.require, file_or_prefix)

    local function override_global_metatable(contents)
        local global_metatable = getmetatable(_G)

        global_metatable.__index = vim.tbl_deep_extend("error", global_metatable.__index, contents)
    end

    if ok then
        override_global_metatable(module)
    end

    return function(modules)
        for _, module_name in ipairs(modules) do
            module = environment.require(file_or_prefix .. "." .. module_name)
            override_global_metatable(module)
        end
    end
end

environment.plugin = function(name)
    if environment.plugins[name] then
        return environment.plugins[name]
    end

    _G.neorg_dev.plugin_data[name] = {}

    return setmetatable({
        name = name,
        packer_data = {},
        data = {},
        active = false,
    }, {
        __call = function(self, data)
            self = vim.tbl_deep_extend("force", self, data)
            _G.neorg_dev.plugin_data[name] = self.data
            return self
        end,
    })
end

environment.make_plugin = function(plugin, packer_data)
    plugin.packer_data = packer_data
    plugin.active = true
    environment.plugins[plugin.name] = plugin
end

environment.post = function()
    local augroup = vim.api.nvim_create_augroup("NeorgDev", {})

    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        callback = function(data)
            if environment.state.undofile then
                vim.api.nvim_buf_set_option(data.buf, "undofile", true)
            end
        end
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = augroup,
        pattern = vim.fn.stdpath("config") .. "/user/**.lua",
        callback = function()
            if not _G.packer_plugins then
                return
            end

            local old_plugin_count = vim.tbl_count(environment.plugins)

            local ok, err = pcall(require("config.setup"))

            if not ok then
                vim.api.nvim_err_writeln(err)
                return
            end

            local current_plugin_count = vim.tbl_count(environment.plugins)
            local packer_plugin_count = vim.tbl_count(_G.packer_plugins)
            local packer = require("packer")

            if current_plugin_count > old_plugin_count or current_plugin_count > packer_plugin_count then
                packer.sync()
            elseif current_plugin_count < old_plugin_count or current_plugin_count < packer_plugin_count then
                packer.clean()
                packer.compile()
            end
        end
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        group = augroup,
        callback = function()
            if not _G.packer_plugins then
                return
            end

            local current_plugin_count = vim.tbl_count(environment.plugins)
            local packer_plugin_count = vim.tbl_count(_G.packer_plugins)
            local packer = require("packer")

            if current_plugin_count > packer_plugin_count then
                packer.sync()
            elseif current_plugin_count < packer_plugin_count then
                packer.clean()
                packer.compile()
            end
        end,
    })
end

environment.silent = "silent"
environment.expr = "expr"
environment.script = "script"
environment.nowait = "nowait"
environment.noremap = "noremap"

return environment
