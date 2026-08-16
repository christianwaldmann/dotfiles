-- only use this for lsp's that don't have their own formatter
return {
    'stevearc/conform.nvim',
    lazy = false,
    opts = {},
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                -- groovy = { "npm-groovy-lint" },
                -- go = { "gofmt" },
                -- terraform = { "terraform_fmt" },
                -- yaml = { "yamlfmt" }, -- or "yamlfmt"
                -- json = { "prettier" },
                -- markdown = { "prettier" },
                -- javascript = { "prettier" },
                -- typescript = { "prettier" },
                -- sh = { "shfmt" },
            }
        })

        local autocmd = vim.api.nvim_create_autocmd
        autocmd('LspAttach', {
            callback = function(e)
                vim.keymap.set("n", "<leader>lf", function() require("conform").format({ async = true }) end, { desc = "Format file" })
            end
        })
    end
}

