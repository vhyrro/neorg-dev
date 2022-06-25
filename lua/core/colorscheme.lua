local colorscheme_manager = {}

colorscheme_manager.colorscheme = function(path, name)
    plugin(name) {
        path,
        config = function()
            vim.cmd("colorscheme " .. name)
        end,
    }
end

colorscheme_manager.colourscheme = colorscheme_manager.colorscheme

return colorscheme_manager
