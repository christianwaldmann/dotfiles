-- syntax highlighting
local function augroup(name) return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true }) end

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "vimdoc", "javascript", "typescript", "c", "lua", "java", "markdown", "groovy",
                "jsdoc", "bash", "python", "go", "terraform", "yaml", "json", "dockerfile"
            },
            sync_install = false,
            auto_install = true,
            indent = {
                enable = true
            },
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    if lang == "html" then
                        print("disabled treesitter for html")
                        return true
                    end
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify(
                            "File larger than 100KB treesitter disabled for performance",
                            vim.log.levels.WARN,
                            { title = "Treesitter" }
                        )
                        return true
                    end
                end,
            },
        })
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            group = augroup("jenkinsfile_detect"),
            pattern = { "Jenkinsfile", "Jenkinsfile.*" },
            callback = function()
                vim.cmd("set filetype=groovy")
            end
        })
    end
}
