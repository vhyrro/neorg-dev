local undofile_module = {}

function undofile_module.undofile(location)
    require "core.option_wrappers".opt.undodir = location

    new_hook("post", function()
        vim.api.nvim_buf_set_option(0, "undofile", true)
    end)
end

return undofile_module
