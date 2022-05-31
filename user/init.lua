template "default"

--> Imports
import "plugins" {
    "neorg",
}

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

--> Store undo information persistently under the following directory
undofile "/home/vhyrro/.cache/nvim/undo"

--> Colourscheme setup
colorscheme("rebelot/kanagawa.nvim", "kanagawa")

--> Keybinds
keybinds {
   ("n" / "<C-c>" / ":bd<CR>" +silent) % "closes the current buffer",
   ("n" / "<C-n>" / ":bn<CR>" +silent) % "cycles to the next buffer",
   ("n" / "<C-p>" / ":bp<CR>" +silent) % "cycles to the previous buffer",

   ("n" / "<Esc>" / ":noh<CR>" +silent) % "clears search highlights",

   ("n" / ":" ^ ";" +noremap),
}

-- TODO: languages "all"
languages {
    "lua",
    "cpp",
    "javascript",
}

-- neorg {}
