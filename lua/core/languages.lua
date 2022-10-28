local module = {}

function module.languages(language_list)
    local treesitter_languages = {}

    for _, language in ipairs(language_list) do
        if type(language) == "string" then
            table.insert(treesitter_languages, language)
        end
    end

    if not vim.tbl_isempty(treesitter_languages) then
        plugin "nvim-treesitter" {
            "nvim-treesitter/nvim-treesitter",
            run = ":silent! TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = treesitter_languages,

                    highlight = {
                        enable = true,
                    },
                })
            end,
        }
    end
end

return module
