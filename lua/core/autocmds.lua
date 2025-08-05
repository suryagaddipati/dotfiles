local augroup = vim.api.nvim_create_augroup("DevConfig", {})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		-- Get the last position from the mark
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)

		-- Only restore if the position is valid and not at the start of the file
		if mark[1] > 0 and mark[1] <= lcount then
			vim.api.nvim_win_set_cursor(0, mark)
			-- Center the screen on the cursor position
			vim.cmd("normal! zz")
			-- Open folds if the line is in a fold
			vim.cmd("silent! normal! zv")
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	command = "%s/\\s\\+$//e",
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "python",
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

-- Enhanced buffer management
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "*",
	callback = function()
		-- Auto-close location list if it's the last window
		if vim.fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
			vim.cmd("q")
		end
	end,
})

-- Intelligent buffer closing - don't close if it's the last buffer
vim.api.nvim_create_autocmd("BufDelete", {
	group = augroup,
	pattern = "*",
	callback = function(event)
		local buf = event.buf

		-- Skip for special buffers, temporary buffers, or plugin buffers
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
		local bufname = vim.api.nvim_buf_get_name(buf)

		-- Skip if it's not a normal file buffer
		if
			buftype ~= ""
			or filetype == "fzf"
			or filetype == "fzf-lua"
			or string.match(bufname, "fzf")
			or string.match(bufname, "term://")
			or string.match(bufname, "nvim%-tree")
			or not vim.api.nvim_get_option_value("buflisted", { buf = buf })
		then
			return
		end

		-- Only proceed if we're deleting a listed, normal file buffer
		vim.schedule(function()
			local buffers = vim.fn.getbufinfo({ buflisted = 1 })
			local normal_buffers = 0

			for _, buffer in ipairs(buffers) do
				local bt = vim.api.nvim_get_option_value("buftype", { buf = buffer.bufnr })
				if bt == "" then
					normal_buffers = normal_buffers + 1
				end
			end

			if normal_buffers == 0 then
				vim.cmd("enew") -- Create new empty buffer
			end
		end)
	end,
})

-- Better window behavior
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	pattern = "*",
	command = "wincmd =", -- Auto-resize splits on terminal resize
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 300,
		})
	end,
})

-- Auto-save functionality
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	group = augroup,
	pattern = "*",
	callback = function()
		if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			vim.cmd("silent! update")
		end
	end,
})

-- Auto-format on save for specific filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = { "*.lua", "*.js", "*.ts", "*.jsx", "*.tsx", "*.py", "*.json" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- Better quickfix experience
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = augroup,
	pattern = { "[^l]*", "l*" },
	callback = function()
		vim.cmd("cwindow")
	end,
})

-- Auto-reload files when changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose" }, {
	group = augroup,
	pattern = "*",
	callback = function()
		if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
			vim.cmd("silent! checktime")
		end
	end,
})

-- Silent file reload when changed externally
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	group = augroup,
	pattern = "*",
	command = 'echon ""',
})
