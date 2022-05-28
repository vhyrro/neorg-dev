--> Set up plugins if they don't exist
local is_fresh_install = false
local config_path = vim.fn.stdpath("config")

do
    local install_dir = vim.fn.stdpath("data") .. "/site/pack/packer/"

    if vim.fn.isdirectory(install_dir) == 0 then
        vim.notify("Packer isn't installed! Setting it up...")

        vim.fn.delete(config_path .. "/plugin/packer_compiled.lua")
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

-- Enable filetype.lua / disable filetype.vim
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.filetype.add({
    filename = {
        [config_path .. "/user/init.lua"] = "lua",
    }
})

-- Make `user/` part of the lua path
package.path = package.path .. ";" .. config_path .. "/user/?.lua;" .. config_path .. "/user/?/init.lua;"

--> Configure the isolated environment
require("config.setup")(is_fresh_install)
