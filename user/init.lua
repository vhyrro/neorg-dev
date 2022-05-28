template "default"

editing {
	indent = 4
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

opt.inccommand = "split"

opt.virtualedit = "block"

--> Store undo information persistently under the following directory
undofile "/home/vhyrro/.cache/nvim/undo"

--> Colourscheme setup

colorscheme("rebelot/kanagawa.nvim", "kanagawa")
-- colorscheme("sainnhe/gruvbox-material", "gruvbox-material")
