local utils = {}

function utils.packer_command_chain(command, ...)
    if not command then
        return
    end

    local args = { ... }

    vim.api.nvim_create_autocmd("User", {
        pattern = { "PackerComplete", "PackerCompileDone" },
        once = true,

        callback = function()
            utils.packer_command_chain(unpack(args))
        end,
    })

    command()
end

return utils
