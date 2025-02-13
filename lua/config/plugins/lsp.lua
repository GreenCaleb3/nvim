return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local capabilities = require('blink.cmp').get_lsp_capabilities()
			require("lspconfig").lua_ls.setup { capabilities = capabilities }

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end

					---@diagnostic disable-next-line: missing-parameter
					if client.supports_method('textDocument/formatting') then
						-- Format the current buffer on save
						vim.api.nvim_create_autocmd('BufWritePre', {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
							end,
						})
					end
				end,
			})
		end,
	}
}

--return {
--	"neovim/nvim-lspconfig",
--	dependencies = {
--		"williamboman/mason.nvim",
--		"williamboman/mason-lspconfig.nvim",
--		"hrsh7th/cmp-nvim-lsp",
--		"hrsh7th/cmp-buffer",
--		"hrsh7th/cmp-path",
--		"hrsh7th/cmp-cmdline",
--		"hrsh7th/nvim-cmp",
--		"L3MON4D3/LuaSnip",
--		"saadparwaiz1/cmp_luasnip",
--		"j-hui/fidget.nvim",
--	},
--
--	config = function()
--		local cmp = require('cmp')
--		local cmp_lsp = require("cmp_nvim_lsp")
--		local capabilities = vim.tbl_deep_extend(
--			"force",
--			{},
--			vim.lsp.protocol.make_client_capabilities(),
--			cmp_lsp.default_capabilities())
--
--		require("fidget").setup({})
--		require("mason").setup()
--		require("mason-lspconfig").setup({
--			ensure_installed = {
--				"lua_ls",
--				"rust_analyzer",
--				"gopls",
--			},
--			handlers = {
--				function(server_name)         -- default handler (optional)
--					require("lspconfig")[server_name].setup {
--						capabilities = capabilities
--					}
--				end,
--
--				zls = function()
--					local lspconfig = require("lspconfig")
--					lspconfig.zls.setup({
--						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
--						settings = {
--							zls = {
--								enable_inlay_hints = true,
--								enable_snippets = true,
--								warn_style = true,
--							},
--						},
--					})
--					vim.g.zig_fmt_parse_errors = 0
--					vim.g.zig_fmt_autosave = 0
--				end,
--				["lua_ls"] = function()
--					local lspconfig = require("lspconfig")
--					lspconfig.lua_ls.setup {
--						capabilities = capabilities,
--						settings = {
--							Lua = {
--								runtime = { version = "Lua 5.1" },
--								diagnostics = {
--									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
--								}
--							}
--						}
--					}
--				end,
--			}
--		})
--
--		local cmp_select = { behavior = cmp.SelectBehavior.Select }
--
--		cmp.setup({
--			snippet = {
--				expand = function(args)
--					require('luasnip').lsp_expand(args.body)           -- For `luasnip` users.
--				end,
--			},
--			mapping = cmp.mapping.preset.insert({
--				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--				['<C-y>'] = cmp.mapping.confirm({ select = true }),
--				["<C-Space>"] = cmp.mapping.complete(),
--			}),
--			sources = cmp.config.sources({
--				{ name = 'nvim_lsp' },
--				{ name = 'luasnip' },         -- For luasnip users.
--			}, {
--				{ name = 'buffer' },
--			})
--		})
--
--		vim.diagnostic.config({
--			-- update_in_insert = true,
--			float = {
--				focusable = false,
--				style = "minimal",
--				border = "rounded",
--				source = "always",
--				header = "",
--				prefix = "",
--			},
--		})
--	end
--}
