--> Set up plugins if they don't exist
local is_fresh_install = false

do
	local install_dir = vim.fn.stdpath("data") .. "/site/pack/packer/"

	if vim.fn.isdirectory(install_dir) == 0 then
		vim.notify("Packer isn't installed! Setting it up...")

		vim.fn.mkdir(install_dir, "p")
		vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_dir .. "/opt/packer.nvim"})

		if vim.v.shell_error == 0 then
			is_fresh_install = true
			vim.notify("Packer set up successfully!")
		else
			vim.notify("Failed to install packer (make this error message better in the future)")
			os.exit(-1)
		end
	end
end

--> Set up functions specifically made for the user configuration

-- Setup
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.filetype.add({
	filename = {
		[vim.fn.stdpath("config") .. "/config"] = "lua",
		[vim.fn.stdpath("config") .. "/setup"] = "lua",
	}
})

local isolated_environment = require("config.environment")

-- Run the user configuration
setfenv(isolated_environment.wrap(dofile, vim.fn.stdpath("config") .. "/config"), setmetatable(_G, { __index = isolated_environment }))()

isolated_environment.post()

vim.cmd("packadd packer.nvim")

local packer = require('packer')
local packer_async = require('packer.async')

require('packer').startup(function(use)
	use {
		"wbthomason/packer.nvim",
		opt = true,
	}

	if is_fresh_install then
		-- Yes I do indeed spell colourscheme the bri'ish way
		if isolated_environment.colourscheme then
			use {
				isolated_environment.colourscheme.path,
				config = function()
					vim.cmd("colorscheme " .. isolated_environment.colourscheme.name)
				end,
			}
		end

		packer_async.wait(packer.sync())
	end
end)
