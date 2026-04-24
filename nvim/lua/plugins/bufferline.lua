return {
	'akinsho/bufferline.nvim',
	dependencies = { "nvim-tree/nvim-web-devicons"},
	event = "VeryLazy",
    keys = {
      { "<leader>l", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Tab" },
      { "<leader>h", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Tab" },
    },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant", -- options: "slant" | "thick" | "thin"
        show_buffer_close_icons = false,
        show_close_icon = false
      }
    }
}
