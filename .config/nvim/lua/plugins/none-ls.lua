return {
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			local mason_null_ls = require("mason-null-ls") -- require your null-ls config here (example below)

			mason_null_ls.setup({
				ensure_installed = {
					"terraform",
					"trivy",
					"kube-linter",
					"actionlint",
					"yamllint",
					"yamlfmt",
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.completion.spell,
					null_ls.builtins.diagnostics.terraform_validate,
					null_ls.builtins.diagnostics.trivy,
					null_ls.builtins.formatting.terraform_fmt,
					null_ls.builtins.diagnostics.kube_linter,
					null_ls.builtins.diagnostics.actionlint,
					null_ls.builtins.diagnostics.yamllint,
					null_ls.builtins.formatting.ymlfmt,
				},
			})

			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		end,
	},
}
