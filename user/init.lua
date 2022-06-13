--> Core Imports
import "core"
import "core.integrations"

--> Import
import "plugins.neorg"

editing {
    indent = 4,
    spaces = true,
}

--------------------------------------> BASIC OPTIONS <--------------------------------------

-- `set` is used to simply toggle an option on/off.
-- It's syntax sugar for `opt.option = true` or `opt.option = false`
--
-- To enable an option, simply type `set "optionname"`
-- To disable an option, type `set "nooptionname"`

-- Enable line numbers for buffers
set "number"

-- Make the line numbers relative
set "relativenumber"

-- Make horizontal splits show up at the bottom of the screen by default.
set "splitbelow"

-- Make vertical splits show up on the right of the screen by default.
set "splitright"

-- Disable wrapping (usually not good for coding, useful for writing though)
set "nowrap"

-- Enables richer colouring for terminals that support it (this assumes you have
-- a fairly modern terminal emulator)
set "termguicolors"

-- Make Neovim case-insensitive (applies to many places, including search, completions etc.)
set "ignorecase"

--------------------------------------> OPTION CLUSTERS <--------------------------------------

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

------------------------------------------------------------------------------------------------

--> Set <Leader> to <Space>
g.mapleader = " "

--> Make substitution (:s) commands preview changes in realtime
opt.inccommand = "split"

--> Enable virtualedit only when in visual block mode
opt.virtualedit = "block"

--> Don't autoclose folds
opt.foldlevel = 999

--> Store undo information persistently under the following directory
undofile (vim.fn.stdpath("cache") .. "/nvim/undo")

--> Colourscheme setup
colorscheme ("rebelot/kanagawa.nvim", "kanagawa")

--> Enable `neorg-dev` integrations with this init.lua file
integrations "all"

integrations_highlights {
    sections = "TSStrong",
    annotations = "TSUnderline",
}

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
