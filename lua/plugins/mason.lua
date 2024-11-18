return {
	"neovim/nvim-lspconfig",
	enabled = true,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate",
			config = function()
				require("mason").setup()
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				-- ensure_installed = require("utils").servers,
				automatic_installation = { exclude = require("utils").lservers },
			},
		},
		{
			"folke/neodev.nvim",
		},
	},
	config = function()
		require("neodev").setup()
		require("mason-lspconfig").setup()

		local lspconfig = require("lspconfig")

		-- Setting up border for LspInfo
		require("lspconfig.ui.windows").default_options.border = "none"

		-- Setting up icons for diagnostics
		local signs = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "" },
			{ name = "DiagnosticSignInfo", text = "󰋽" },
		}
		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
		end

		vim.diagnostic.config({
			virtual_text = { spacing = 4, prefix = "●" },
			signs = {
				active = signs,
			},
			update_in_insert = true,
			severity_sort = true,
			float = {
				focusable = false,
				border = "none",
				source = "if_many",
				header = "",
				prefix = "",
				suffix = "",
			},
		})

		M = {}
		function M.hover(_, result, ctx, config)
			config = config or {}
			config.focus_id = ctx.method
			if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
				-- Ignore result since buffer changed. This happens for slow language servers.
				return
			end
			if not (result and result.contents) then
				if config.silent ~= true then
					vim.notify("No information available")
				end
				return
			end
			local format = "markdown"
			local contents ---@type string[]
			if type(result.contents) == "table" and result.contents.kind == "plaintext" then
				format = "plaintext"
				contents = vim.split(result.contents.value or "", "\n", { trimempty = true })
			else
				contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
			end
			if vim.tbl_isempty(contents) then
				if config.silent ~= true then
					vim.notify("No information available")
				end
				return
			end

			config.max_width = 80
			return vim.lsp.util.open_floating_preview(contents, format, config)
		end

		-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(M.hover, {
		-- 	border = "none",
		-- })
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "none",
		})

		local on_attach = function(_, bufnr)
			-- Setting keymaps for lsp

			local attach_opts = { silent = true, buffer = bufnr }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, attach_opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, attach_opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, attach_opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, attach_opts)

			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, attach_opts)
			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, attach_opts)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, attach_opts)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, attach_opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, attach_opts)
			vim.keymap.set("n", "so", require("telescope.builtin").lsp_references, attach_opts)

			-- vim.keymap.set("n", "gT", "<cmd>Telescope lsp_type_definitions<CR>", attach_opts)
			-- vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", attach_opts)
			-- vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", attach_opts)
			vim.keymap.set("n", "<leader>dg", vim.diagnostic.open_float, attach_opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, attach_opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, attach_opts)
			vim.keymap.set("n", "<leader>td", "<cmd>Telescope diagnostics<cr>", attach_opts)
			vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, attach_opts)
			vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, attach_opts)
			vim.keymap.set("n", "<leader>li", vim.cmd.LspInfo, attach_opts)

			-- Eslint specific settings
			if _.name == "eslint" then
				vim.keymap.set("n", "<leader>le", vim.cmd.EslintFixAll, attach_opts)
			end

			-- Typescript specific settings
			if _.name == "ts_ls" then
				_.server_capabilities.documentFormattingProvider = false
			end

			-- if _.name == "ruff_lsp" then
			-- 	_.server_capabilities.hoverProvider = false
			-- 	_.server_capabilities.signatureHelpProvider = false
			-- end
			--
			-- if _.name == "pyright" then
			-- 	_.server_capabilities.hoverProvider = true
			-- 	_.server_capabilities.signatureHelpProvider = false
			-- end
			--
			-- if _.name == "jedi_language_server" then
			-- 	_.server_capabilities.hoverProvider = false
			-- 	_.server_capabilities.signatureHelpProvider = true
			-- 	-- _.server_capabilities.textDocument.signatureHelpProvider = true
			-- end
		end

		-- nvim-cmp supports additional completion capabilities
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		-- capabilities.textDocument.completion.completionItem.snippetSupport = true

		local Servers = require("utils").servers
		for _, i in ipairs(require("utils").lservers) do
			table.insert(Servers, i)
		end

		for _, lsp in ipairs(Servers) do
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		-- Setting up emmet-ls
		lspconfig.emmet_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"svelte",
				"pug",
				"typescriptreact",
				"vue",
			},
			init_options = {
				html = {
					options = {
						-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
						["bem.enabled"] = true,
					},
				},
			},
		})

		-- Setting up lua server
		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "nvim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		------------- LSP Quick Fix -------------
		-- vim.keymap.set("n", "<leader>fa", "<cmd>lua vim.lsp.buf.code_action()<CR>")

		-- Enable the following language servers
		-- lspconfig["jedi_language_server"].setup({
		-- 	on_attach = function(client, bufnr)
		-- 		client.server_capabilities.signatureHelpProvider = true
		-- 		on_attach(client, bufnr)
		-- 	end,
		-- 	capabilities = capabilities,
		-- 	filetypes = { "python" },
		-- })

		lspconfig["rust_analyzer"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig["clangd"].setup({
			on_attach = function(client, bufnr)
				client.server_capabilities.signatureHelpProvider = false
				on_attach(client, bufnr)
			end,
			capabilities = capabilities,
			cmd = { "clangd" },
			-- for clangd on windows config.yaml for configuration and target set to windows gnu
		})

		lspconfig["cssls"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				css = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				scss = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				less = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		})

		lspconfig["bashls"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = { "bash-language-server", "start" },
			filetypes = { "bash", "sh", "zsh" },
		})

		-- Python

		lspconfig["ruff"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				client.server_capabilities.hoverProvider = false
			end,
		})

		-- Pyright setup
		--
		-- lspconfig["ccls"].setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = function(client, bufnr)
		-- 		on_attach(client, bufnr)
		-- 	end,
		-- })

		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				-- client.server_capabilities.hoverProvider = false
			end,
			settings = {
				pyright = {
					disableLanguageServices = false,
					typeCheckingMode = "off",
					useLibraryCodeForTypes = true,
					-- disableOrganizeImports = true,
				},
				python = {
          -- use active python environment
					pythonPath = vim.fn.exepath("python3"),
				},
			},
			filetypes = { "python" },
		})
	end,
}
