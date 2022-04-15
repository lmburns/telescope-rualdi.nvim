## Telescope-Rualdi

[`rualdi`](https://github.com/Jarsop/rualdi) is a directory tagging tool (Rust Aliasing Directory),
which allows for various directories to be given an alias and stored in a file. The user can
then use these aliases to do whatever they like. It is very similar to [`formarks`](https://github.com/wfxr/formarks).

### Extension

This extension is pretty simple and is pretty simple to setup.

**Packer**
```lua
use(
    {
        "nvim-telescope/telescope.nvim",
        config = function()
            -- configuration stuff
        end,
        after = {"popup.nvim", "plenary.nvim"},
        requires = {
            {
                "lmburns/telescope-rualdi.nvim",
                after = {"telescope.nvim"},
                config = [[require("telescope").load_extension("rualdi")]]
            }
        }
    }
)
```

To use the extension, the following methods are available:

* Neovim command
```lua
-- Options are read from the default telescope setup
:Telescope rualdi list
```

* Lua function
```lua
-- A table of options are able to be passed to this command
:lua require("telescope").extensions.rualdi.list({})
```

### Options

Options respected by this plugin as of this moment are:

* Used with the default telescope setup

```lua
require("telescope").setup({
  extensions = {
    rualdi = {
      prompt_title = "Rualdi", -- title of the prompt
      theme = "ivy", -- override default theme
      opener = "Lf", -- command to call as an opener for the default action (<CR>)
      alias_hl = "Normal", -- highlight group for the alias
      path_hl = "Comment", -- highlight group for the path
    }
  }
})
```

* One-shot function call

```lua
-- Example to open the directory with NvimTree
map("n", "<Leader>rr", ":lua require('telescope').extensions.rualdi.list({ opener = 'NvimTree' })")
```

Any options that are given to the `require("telescope.pickers").new()` function are also supported.

### Mappings

Two mappings are overridden.

* `<C-g>` will open a `live_grep` picker in the hovered directory
* `<C-f>` will open a `find_files` picker in the hovered directory

#### Notes

* This extension expects that `rualdi`'s configuration file is in its default location (i.e.,
`$XDG_DATA_HOME/rualdi/rualdi.toml`)

#### TODO

* [ ] Add support for more customized mappings
* [ ] Change color/options of previewer
* [ ] Fix start on insert
