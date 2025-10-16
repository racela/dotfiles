return {
	{
		"nordtheme/vim",
		name = "nord",
		lazy = false, -- load on startup
		priority = 1000, -- make sure it loads before other plugins
		config = function()
			-- vim.cmd([[colorscheme nord]])
		end,
	},
}
