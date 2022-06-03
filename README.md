# \[WIP\] Neovim Configuration for Neorg Developers
This configuration serves as a stable way to develop for Neorg.
## Features
Honestly nothing special, it's just a Neovim configuration after all - Neovim configs
all boil down to plugins in the end.
One thing that _does_ set `neorg-dev` aside from typical configurations is that it's not
scared to abstract things away - although some may consider this bad, in the current era of
Neovim plugins where things love to break having abstractions helps the user a lot.
Aside from abstraction `neorg-dev` operates on a kind of client-server model, where the user
is provided with a `user/init.lua` (the client) and may interact with the server (`neorg-dev`)
APIs if it so chooses.
## Quirks to Note
**TODO**