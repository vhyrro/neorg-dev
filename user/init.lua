--> Core Imports
import "core"
import "core.integrations"

--> Import
import "plugins" {
    "neorg",
    "gitsigns",
    "neogit",
    "toggleterm",
    "presence",
    "telescope",
    "neogen",
}

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
g.maplocalleader = ","

--> Make substitution (:s) commands preview changes in realtime
opt.inccommand = "split"

--> Enable virtualedit only when in visual block mode
opt.virtualedit = "block"

--> Don't autoclose folds
opt.foldlevel = 999

--> Synchronize the system clipboard and Neovim's clipboard
opt.clipboard = "unnamedplus"

--> Enable full concealing by default
opt.conceallevel = 2

--> Make scrolling much more convenient
opt.scrolloff = 999

--> Disable Neovim's default mouse behaviours
opt.mouse = ""

--> Store undo information persistently under the following directory
undofile (vim.fn.stdpath("cache") .. "/nvim/undo")

--> Colourscheme setup
colorscheme ("rebelot/kanagawa.nvim", "kanagawa")
-- colorscheme ("rose-pine/neovim", "rose-pine")
-- colorscheme("Shadorain/shadotheme", "shado")
-- colorscheme ("catppuccin/nvim", "catppuccin")

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

    ("nv" / ":" ^ ";" +noremap),
}

languages {
    "lua", -- Chad level 999 (plus one to account for one based indexing)
    "cpp", -- Where did my borrow checker go
    "javascript", -- For Treesitter development, don't be mad at me
    "zig", -- Objectively the best, don't @ me
}

neorg_setup {
    path = "~/dev/neorg/",
    -- treesitter = {
    --     norg = {
    --         url = "~/dev/tree-sitter-norg",
    --     }
    -- },

    modules = {
        ["core.defaults"] = {},
        -- ["core.semantic-analyzer"] = {},
        -- ["core.norg.esupports.metagen"] = {
        --     config = {
        --         type = "empty",
        --     },
        -- },
        -- ["core.export.markdown"] = {
        --     config = {
        --         extensions = "all",
        --     },
        -- },
        -- ["core.extern"] = {},
        ["core.norg.concealer"] = {},
        -- ["core.gtd.base"] = {
        --     config = {
        --         workspace = "main",
        --     }
        -- }
    },

    workspaces = {
        main = "~/neorg/",
    },
}

gitsigns {}

neogit {
    keybinds {
        ("n" / "<Leader>g" / "<cmd>Neogit<CR>") % "activate neogit",
    },
}

toggleterm {
    keybinds {
        ("n" / "<Leader>t" / function() return "<cmd>" .. tostring(vim.v.count1) .. "ToggleTerm direction=float<CR>" end +expr +silent) % "toggle the terminal",
        ("t" / "<C-n>" / "<C-\\><C-n>" +noremap) % "moves to normal mode in a terminal view",

        -- Treesitter development related (TODO: move into different section)
        ("nt" / "<Leader>yg" / [[<cmd>TermExec cmd="tree-sitter generate" direction=float<CR>]]) % "runs the equivalent of 'yarn gen' in a terminal",
        ("nt" / "<Leader>yp" / [[<cmd>TermExec cmd="tree-sitter parse test.norg" direction=float<CR>]]) % "runs the equivalent of 'yarn parse test.norg' in a terminal",
        ("nt" / "<Leader>yt" / [[<cmd>TermExec cmd="tree-sitter test" direction=float<CR>]]) % "runs the equivalent of 'yarn test' in a terminal",
        ("nt" / "<Leader>yd" / [[<cmd>TermExec cmd="tree-sitter parse -d test.norg" direction=float<CR>]]) % "runs the equivalent of 'yarn parse -d test.norg' in a terminal",
    }
}

presence {
    neovim_image_text = "Emacs Sucks Balls, Respectfully",
    enable_line_number = true,
    main_image = "file",
}

telescope {
    keybinds {
        ("n" / "<Leader>ff" / "<cmd>Telescope find_files<CR>") % "fuzzy searches through files using telescope",
        ("n" / "<Leader>lg" / "<cmd>Telescope live_grep<CR>") % "live greps through the current working directory with telescope",
        ("n" / "<Leader>fh" / "<cmd>Telescope help_tags<CR>") % "fuzzy searches through help tags using telescope",
    }
}

neogen {
    keybinds {
        ("n" / "<Leader>d" / "<cmd>Neogen<CR>") % "generates documentation for the current function",
    }
}

plugin "playground" {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",

    keybinds {
        ("n" / "<Leader>p" / "<cmd>TSPlaygroundToggle<CR>") % "toggles the TS playground",
    },
}

-- TODO: Export this to something much less ugly
plugin "nvim-lspconfig" {
    "neovim/nvim-lspconfig",
    config = function()
        -- Mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        local opts = { noremap=true, silent=true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }

            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', '<space>fo', vim.lsp.buf.format, bufopts)
        end

        local lspconfig = require("lspconfig")

        for _, lang in ipairs({"zls", "norg_lsp", "clangd"}) do
            lspconfig[lang].setup({
                on_attach = on_attach,
            })
        end
    end,
}

plugin "lsp_lines" {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
        vim.diagnostic.config({
            virtual_text = false,
        })
        require("lsp_lines").setup()
    end,

    keybinds {
        ("n" / "<Leader>lt" / function() require("lsp_lines").toggle() end) % "toggles `lsp_lines`",
    }
}
