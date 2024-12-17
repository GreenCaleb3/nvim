return {
	"tpope/vim-fugitive",

	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

		local my_fugitive = vim.api.nvim_create_augroup("my_fugitive", {})

		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
		local autocmd = vim.api.nvim_create_autocmd

		autocmd("BufWinEnter", {
			group = my_fugitive,
			pattern = "*",

			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "<leader>p", function()
					vim.cmd.Git('push')
				end, opts)

				-- rebase
				vim.keymap.set("n", "<leader>P", function()
					vim.cmd.Git({ 'pull', '--rebase' })
				end, opts)

				vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
			end,
		})

		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
	end
}
