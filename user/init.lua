template "default"

--> Imports
import "plugins.neorg"
import "core.languages"

editing {
    indent = 4,
    spaces = true,
}

--> Option clusters

-- Neovim Update Intervals
opt {
    timeoutlen = 500,
    ttimeoutlen = 5,
    updatetime = 100,
}

-- Splitting behaviour
opt {
    splitbelow = true,
    splitright = true,
}

--> Set <Leader> to <Space>
g.mapleader = " "

--> Make substitution (:s) commands preview changes in realtime
opt.inccommand = "split"

--> Enable virtualedit only when in visual block mode
opt.virtualedit = "block"

--> Don't autoclose folds
opt.foldlevel = 999

--> Store undo information persistently under the following directory
undofile(vim.fn.stdpath("cache") .. "/nvim/undo")

--> Colourscheme setup
colorscheme("rebelot/kanagawa.nvim", "kanagawa")

--> Keybinds
keybinds {
   ("n" / "<C-c>" / "<cmd>bd<CR>" +silent) % "closes the current buffer",
   ("n" / "<C-n>" / "<cmd>bn<CR>" +silent) % "cycles to the next buffer",
   ("n" / "<C-p>" / "<cmd>bp<CR>" +silent) % "cycles to the previous buffer",

   ("n" / "<C-h>" / "<C-w>h" +noremap) % "moves to the leftside split",
   ("n" / "<C-l>" / "<C-w>l" +noremap) % "moves to the rightside split",

   ("n" / "<Esc>" / "<cmd>noh<CR>" +silent) % "clears search highlights",

   ("n" / ":" ^ ";" +noremap),
}

-- TODO: languages "all"
languages {
    "lua", -- Chad level 999 (plus one to account for one based indexing)
    "cpp", -- Where did my borrow checker go
    "javascript", -- For Treesitter development, don't be mad at me
}

neorg_setup {
    path = "~/dev/neorg/",

    modules = {
        ["core.defaults"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = {
            config = {
                extensions = "all",
            },
        },
        -- ["core.norg.concealer"] = {},
    },

    workspaces = {
        main = "~/neorg/",
    },
}

make_plugin(plugin "playground", {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
})
