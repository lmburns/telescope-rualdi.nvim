## Telescope-Rualdi

[`rualdi`](https://github.com/Jarsop/rualdi) is a directory tagging tool (Rust Aliasing Directory),
which allows for various directories to be given an alias and stored in a file. The user can
then use these aliases to do whatever they like. It is very similar to [`formarks`](https://github.com/wfxr/formarks).

### Extension

This extension is pretty simple and is pretty simple to setup.

**Packer**
```lua
use
  (
    {
      'lmburns/telescope-rualdi.nvim',
      config = [[require('telescope').load_extension('rualdi')]]
    }
  )
```

To use the extension, the following methods are available:

* Neovim command
```
:Telescope rualdi list
```

* Lua function
```lua
:lua require("telescope").extensions.rualdi.list()
```

### Options

Options that are respected as of this moment are:

```lua
require("telescope").setup({
  extensions = {
    rualdi = {
      prompt_title = "Rualdi",
      theme = "ivy",
      opener = "Lf", -- command to call as an opener for the default action (<CR>)
      alias_hl = "Normal", -- highlight group for the alias
      path_hl = "Comment", -- highlight group for the path
    }
  }
})
```

#### Notes

* This extension expects that `rualdi`'s configuration file is in its default location (i.e.,
`$XDG_DATA_HOME/rualdi/rualdi.toml`)
