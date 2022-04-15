local F = vim.F

---@class TelescopeRualdiConfig
---@field setup function: setup Rualdi's configuration (default: |config|)
---@field path string Configuration file path
---@field alias_hl string Highlight group for the alias
---@field path_hl string Highlight group for the path
---@field prompt_title string Title of the Rualdi prompt
---@field opener string Default command to open path with
---@field mappings table Default telescope mappings
---@field theme string Default theme to use
local config = {}
config.path = ("%s/rualdi/rualdi.toml"):format(vim.env.XDG_DATA_HOME)

-- TODO: Use these actions in `attach_mappings`
-- local rualdi_actions = {}
--
-- rualdi_actions.open_grep = function(prompt_bufnr)
--     local current_picker = action_state.get_current_picker(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
--     builtin.live_grep({cwd = selection.path, initial_mode = "insert"})
-- end
--
-- rualdi_actions.open_finder = function(prompt_bufnr)
--     local current_picker = action_state.get_current_picker(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     -- Initial mode as insert isn't working
--     actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
--     builtin.find_files({cwd = selection.path, initial_mode = "insert"})
-- end
--
-- config.mappings = {
--     ["i"] = {
--         ["<C-f>"] = rualdi_actions.open_finder,
--         ["<C-g>"] = rualdi_actions.open_grep
--     }
-- }

config.setup = function(opts)
    -- config.mappings = vim.tbl_deep_extend("force", config.mappings, require("telescope.config").values.mappings)
    config.prompt_title = F.if_nil(opts.prompt_title, "Rualdi")
    config.alias_hl = F.if_nil(opts.alias_hl, "Function")
    config.path_hl = F.if_nil(opts.path_hl, "Comment")
    config.opener = F.if_nil(opts.opener, "Lf")
    config.theme = F.if_nil(opts.theme, require("telescope.config").values.theme)
    config = vim.tbl_deep_extend("force", config, opts)
end

return config
