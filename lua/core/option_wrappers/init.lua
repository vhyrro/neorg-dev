local variables = {}

function variables.set(what)
    if vim.startswith(what, "no") then
        vim.opt[what:sub(3)] = false
    else
        vim.opt[what] = true
    end
end

-- TODO: make these proper wrappers with proper errors
variables.opt = setmetatable({}, {
    __index = vim.opt,
    __newindex = vim.opt,

    __call = function(_, options)
        for key, value in pairs(options) do
            vim.opt[key] = value
        end
    end
})

variables.g = vim.g
variables.b = vim.opt_local

return variables
