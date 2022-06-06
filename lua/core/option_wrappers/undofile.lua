local undofile_module = {}

function undofile_module.undofile(location)
    state.undofile = true
    require "core.option_wrappers".opt.undodir = location
end

return undofile_module
