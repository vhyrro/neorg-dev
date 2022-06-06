local module = {}

function module.languages(language_list)
    local use_lsp = true
    local use_treesitter = true

    local treesitter_languages = {}
    -- TODO: LSP setup

    for _, language in ipairs(language_list) do
        if type(language) == "string" then
            table.insert(treesitter_languages, language)
        end
    end

    if use_treesitter then
        local treesitter = plugin "nvim-treesitter" {
            data = {
                languages = treesitter_languages,
            }
        }

        make_plugin(treesitter, {
            "nvim-treesitter/nvim-treesitter",
            run = ":silent! TSUpdate",
            config = function()
                local language_list = neorg_dev.plugin_data["nvim-treesitter"].languages

                require("nvim-treesitter.configs").setup({
                    ensure_installed = language_list,

                    highlight = {
                        enable = true,
                    },
                })
            end,
        })
    end
end

return module
