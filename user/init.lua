template "default"

editing {
	indent = 4,
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
keybinds {}
