-- nvim-treesitter's main branch requires Neovim 0.12 or newer.
local ensure_installed = {
    "vimdoc", "javascript", "typescript", "c", "lua", "java", "markdown", "groovy",
    "jsdoc", "bash", "python", "go", "terraform", "yaml", "json", "dockerfile"
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })

        local available = {}
        for _, lang in ipairs(treesitter.get_available()) do
            available[lang] = true
        end

        local installing = {}

        local function is_disabled(buf, filetype)
            if filetype == "html" then
                print("disabled treesitter for html")
                return true
            end

            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                vim.notify(
                    "File larger than 100KB treesitter disabled for performance",
                    vim.log.levels.WARN,
                    { title = "Treesitter" }
                )
                return true
            end

            return false
        end

        local function activate(buf, lang)
            if not vim.api.nvim_buf_is_valid(buf) then
                return false
            end

            local ok = pcall(vim.treesitter.start, buf, lang)
            if ok then
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
            return ok
        end

        local function activate_open_buffers(lang)
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf)
                    and vim.treesitter.language.get_lang(vim.bo[buf].filetype) == lang
                    and not is_disabled(buf, vim.bo[buf].filetype)
                then
                    activate(buf, lang)
                end
            end
        end

        local function install(lang)
            if installing[lang] then
                return
            end
            installing[lang] = true
            treesitter.install({ lang }):await(function()
                installing[lang] = nil
                activate_open_buffers(lang)
            end)
        end

        for _, lang in ipairs(ensure_installed) do
            installing[lang] = true
        end
        treesitter.install(ensure_installed):await(function()
            for _, lang in ipairs(ensure_installed) do
                installing[lang] = nil
                activate_open_buffers(lang)
            end
        end)

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local filetype = vim.bo[args.buf].filetype
                if is_disabled(args.buf, filetype) then
                    return
                end

                local lang = vim.treesitter.language.get_lang(filetype)
                if not lang then
                    return
                end

                if not activate(args.buf, lang) and available[lang] then
                    install(lang)
                end
            end,
        })

        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            group = vim.api.nvim_create_augroup("treesitter_jenkinsfile_detect", { clear = true }),
            pattern = { "Jenkinsfile", "Jenkinsfile.*" },
            callback = function()
                vim.cmd("set filetype=groovy")
            end,
        })
    end,
}
