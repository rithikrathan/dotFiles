return {

    --  for diagrams
    -- { "jbyuki/venn.nvim", ft = { "markdown", "text" } },
    { "jbyuki/venn.nvim" }, -- so it works with all kind of files???


    -- for colours
    {
        "uga-rosa/ccc.nvim",
        event = "VeryLazy",
        config = function()
            local ccc = require("ccc")
            local _mapping = ccc.mapping
            ccc.setup({
                highlighter = {
                    auto_enable = true,
                    lsp = true,
                },
            })
        end
    },

    -- todo comment highlights
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
        }
    },

    -- render markdown
    {
        'MeanderingProgrammer/render-markdown.nvim',
        event = "VeryLazy",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {},
        ft = { "markdown", "Reference", "gnote", "note", "scratch" }
    },
}
