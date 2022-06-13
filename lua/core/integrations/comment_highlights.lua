return vim.schedule_wrap(function()
    vim.cmd([[
        syntax match NeorgDevSectionComment /^\-\+>\s\+\zs\(\w\|\s\)\+\ze\s\+<\-\+$/
        syntax match NeorgDevAnnotationComment /^\-\+>\s\+\zs[^<]\+$/
    ]])
end)
