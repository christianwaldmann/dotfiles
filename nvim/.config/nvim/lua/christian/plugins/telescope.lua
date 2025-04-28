-- provide shortcuts for finding text and files
return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    lazy = false,
    dependencies = { 'nvim-telescope/telescope-ui-select.nvim', "nvim-lua/plenary.nvim", { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
    config = function()
        require('telescope').setup({
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                }
            }
        })
        local builtin = require('telescope.builtin')
        local previewers = require('telescope.previewers')
        vim.keymap.set('n', '<leader>f', builtin.find_files, { silent = true })
        vim.keymap.set('n', '<leader>h', builtin.git_files, { silent = true })
        vim.keymap.set("n", "<leader>g", builtin.live_grep, { silent = true })
        vim.keymap.set('n', '<leader>H', builtin.help_tags, { desc = 'Telescope help tags' })
        vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<CR>", { silent = true })
        require('telescope').load_extension('fzf')
        require("telescope").load_extension("ui-select")
    end
}

