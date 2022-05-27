local environment = require("config.utilities")

environment.state = {}

environment.set = function(what)
	if vim.startswith(what, "no") then
		vim.opt[what:sub(3)] = false
	else
		vim.opt[what] = true
	end
end

environment.template = function(template_name)
	environment.match(template_name) {
		["sane-defaults"] = environment.wrap(require, "config.default")
	}
end

environment.editing = function(options)
	local function set_options(keys, value)
		return function()
			for _, key in ipairs(keys) do
				vim.opt[key] = value
			end
		end
	end

	for key, value in pairs(options) do
		environment.match(key) {
			indent = set_options({ "shiftwidth", "tabstop", "softtabstop" }, value)
		}
	end
end

environment.undofile = function(location)
	state.undofile = true
	environment.opt.undodir = location
end

environment.post = function()
	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(data)
			if environment.state.undofile then
				vim.api.nvim_buf_set_option(data.buf, "undofile", true)
			end
		end
	})
end

-- TODO: make these proper wrappers with proper errors
environment.opt = setmetatable({}, {
	__index = vim.opt,
	__newindex = vim.opt,

	__call = function(_, options)
		for key, value in pairs(options) do
			vim.opt[key] = value
		end
	end
})

environment.g = vim.g
environment.b = vim.opt_local

return environment
