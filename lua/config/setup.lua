return function(is_fresh_install)
	local config_path = vim.fn.stdpath("config")

	package.loaded["config.environment"] = nil
	local isolated_environment = require("config.environment")

	-- Run the user configuration
	setfenv(isolated_environment.wrap(dofile, config_path .. "/user/init.lua"), setmetatable(_G, { __index = isolated_environment }))()

	-- Run post scripts
	isolated_environment.post()

	vim.cmd("packadd packer.nvim")

	local packer = require('packer')
	local packer_async = require('packer.async')

	packer.init({
		autoremove = true
	})

	packer.startup(function(use)
		use {
			"wbthomason/packer.nvim",
			opt = true,
		}

		use {
			"nvim-neorg/neorg"
		}

		-- Yes I do indeed spell colourscheme the bri'ish way
		if isolated_environment.state.colourscheme then
			use {
				isolated_environment.state.colourscheme.path,
				config = "vim.cmd 'colorscheme " .. isolated_environment.state.colourscheme.name .. "'",
			}
		end

		if is_fresh_install then
			vim.api.nvim_create_autocmd("User", {
				pattern = "PackerComplete",
				once = true,

				callback = function()
					vim.notify("Plugins installed")
				end,
			})

			vim.notify("Installing plugins...")

			packer.sync()
		end
	end)
end
