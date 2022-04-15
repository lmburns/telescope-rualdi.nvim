local ok, telescope = pcall(require, "telescope")
if not ok then
    error("This plugins requires nvim-telescope/telescope.nvim")
end

if not vim.fn.executable("rualdi") then
    vim.notify("rualdi is not found on your system", vim.log.levels.ERROR)
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local builtin = require("telescope.builtin")
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values
-- local themes = require("telescope.themes")

local Path = require("plenary.path")

-- local F = vim.F
local fn = vim.fn
local cmd = vim.cmd

local config = require("telescope._extensions.rualdi.config")

local aliases =
    (function()
    local dirty = {}
    local found = false
    for line in io.lines(config.path) do
        if line:match("^%[") then
            found = false
        end

        if line:match("^%[aliases%]$") then
            found = true
            goto continue
        end

        if found then
            table.insert(dirty, line)
        end
        ::continue::
    end

    local ret =
        vim.tbl_map(
        function(line)
            local pair = {}
            if line ~= "" then
                for token in line:gmatch("([^%s*=%s*]+)") do
                    local cleaned = token:gsub('"', "")

                    if cleaned ~= "" then
                        table.insert(pair, cleaned)
                    end
                end

                return pair
            end
        end,
        dirty
    )

    return ret
end)()

local alias_width = 0
for _, alias in ipairs(aliases) do
    if alias[1] then
        alias_width = #alias[1] > alias_width and #alias[1] or alias_width
    end
end

---Main rualdi funciton which lists the aliases and paths
---@param opts table Options to override the setup function or default
local function list(opts)
    vim.validate {
        opts = {opts, "table", true}
    }

    -- Set the configuration theme if it exists
    local defaults = (function()
        if config.theme then
            return require("telescope.themes")["get_" .. config.theme](config)
        else
            return vim.deepcopy(config)
        end
    end)()

    -- Set the options theme if it exists (since it was applied after the configuration)
    opts = (function()
        if opts.theme then
            return require("telescope.themes")["get_" .. opts.theme](opts)
        else
            return vim.deepcopy(opts)
        end
    end)()

    -- Extend the default configuration
    opts = vim.tbl_deep_extend("force", defaults, opts or {})

    local displayer =
        entry_display.create {
        separator = "",
        items = {
            {width = alias_width + 1},
            {remaining = true}
        }
    }

    local make_display = function(entry)
        return displayer {
            {entry.alias, opts.alias_hl},
            {entry.path, opts.path_hl}
        }
    end

    pickers.new(
        opts,
        {
            prompt_title = opts.prompt_title,
            finder = finders.new_table {
                results = aliases,
                entry_maker = function(e)
                    return {
                        value = e,
                        display = make_display,
                        ordinal = e[1] .. " " .. e[2],
                        alias = e[1],
                        path = e[2]
                    }
                end
            },
            sorter = sorters.get_fzy_sorter(opts),
            previewer = conf.file_previewer(opts),
            attach_mappings = function(prompt_bufnr, map)
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                actions.select_default:replace(
                    function()
                        local selection = action_state.get_selected_entry()
                        local path = Path:new(selection.path)
                        if not path:exists() then
                            vim.notify(("%s doesn't exist"):format(selection.path), vim.log.levels.ERROR)
                            return
                        end

                        actions.close(prompt_bufnr)

                        if fn.exists((":%s"):format(opts.opener)) then
                            cmd((":%s %s"):format(opts.opener, selection.path))
                            cmd("normal A")
                        else
                            vim.notify(("opener %s doesn't exist"):format(opts.opener))
                        end
                    end
                )

                local open_grep = function()
                    local selection = action_state.get_selected_entry()
                    actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
                    builtin.live_grep({cwd = selection.path, initial_mode = "insert"})
                end

                local open_finder = function()
                    local selection = action_state.get_selected_entry()
                    -- Initial mode as insert isn't working
                    actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
                    builtin.find_files({cwd = selection.path, initial_mode = "insert"})
                end

                map("i", "<C-g>", open_grep)
                map("i", "<C-f>", open_finder)
                return true
            end
        }
    ):find()
end

return telescope.register_extension {
    setup = config.setup,
    exports = {
        list = list
    }
}
