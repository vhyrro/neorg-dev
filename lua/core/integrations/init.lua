local highlight_comments = require "core.integrations.comment_highlights"

return {
    integrations = function(integrations)
        if integrations == "all" then
            integrations = { "highlights" }
        end

        if vim.tbl_contains(integrations, "highlights") then
            new_hook({ "config_open", "post" }, function()
                highlight_comments()
            end)
        end
    end,

    integrations_highlights = function(highlights)
        vim.api.nvim_set_hl(0, "NeorgDevSectionComment", {
            link = highlights.sections or "TSUnderline",
        })

        vim.api.nvim_set_hl(0, "NeorgDevAnnotationComment", {
            link = highlights.annotations or "TSStrong",
        })
    end,
}
