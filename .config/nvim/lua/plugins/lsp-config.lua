return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"dockerls",
					"jsonls",
					"terraformls",
					"yamlls",
					"gh_actions_ls",
					"helm_ls",
					"stylua",
					"tflint",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("lua_ls", { capabilities = capabilities })
			vim.lsp.config("dockerls", { capabilities = capabilities })
			vim.lsp.config("jsonls", { capabilities = capabilities })
			vim.lsp.config("terraformls", { capabilities = capabilities })
			vim.lsp.config("yamlls", { capabilities = capabilities })
			vim.lsp.config("gh_actions_ls", { capabilities = capabilities })
			vim.lsp.config("helm_ls", { capabilities = capabilities })
			vim.lsp.config("stylua", { capabilities = capabilities })
			vim.lsp.config("tflint", { capabilities = capabilities })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
