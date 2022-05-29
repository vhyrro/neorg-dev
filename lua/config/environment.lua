local environment = require("config.utilities")

environment.state = {}

environment.set = function(what)
    if vim.startswith(what, "no") then
        vim.opt[what:sub(3)] = false
    else
        vim.opt[what] = true
    end
end

environment.template = function(template_name)
    -- TODO: Better errors
    pcall(require, "templates." .. template_name)
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

environment.undofile = function(location)
    state.undofile = true
    environment.opt.undodir = location
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
            if keybind_data.remove then
                vim.keymap.del(keybind_data.modes, keymap)
            else
                vim.keymap.set(keybind_data.modes, keymap, keybind_data.rhs, keybind_data.attributes)
            end
        end
    end
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
        pattern = vim.fn.stdpath("config") .. "/user/*.lua",
        callback = function()
            require("config.setup")()

            local p = require("packer")
            require("utils").packer_command_chain(p.clean, p.install, p.compile)
        end
    })
end

-- TODO: make these proper wrappers with proper errors
environment.opt = setmetatable({}, {
    __index = vim.opt,
    __newindex = vim.opt,

    __call = function(_, options)
        for key, value in pairs(options) do
            vim.opt[key] = value
        end
    end
})

environment.g = vim.g
environment.b = vim.opt_local

environment.silent = "silent"
environment.expr = "expr"
environment.script = "script"
environment.nowait = "nowait"
environment.noremap = "noremap"

return environment
