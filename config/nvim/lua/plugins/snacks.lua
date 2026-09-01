-- snacks.nvim tweaks, mostly to make the file explorer (<leader>e) tighter and
-- to keep Unity's .meta spam out of the tree

-- snacks' tree formatter hardcodes a 2-space "blank" for ancestor levels that
-- have no more siblings, so shrinking the tree icons alone would leave the
-- indent jagged. patch that one function so every level is exactly 1 column.
local function compact_tree()
	local ok, format = pcall(require, "snacks.picker.format")
	if not ok then
		return
	end
	format.tree = function(item, picker)
		local icons = picker.opts.icons.tree
		local indent = {} ---@type string[]
		local node = item
		while node and node.parent do
			local icon
			if node ~= item then
				icon = node.last and " " or icons.vertical
			else
				icon = node.last and icons.last or icons.middle
			end
			table.insert(indent, 1, icon)
			node = node.parent
		end
		return { { table.concat(indent), "SnacksPickerTree" } }
	end
end

return {
	{
		"folke/snacks.nvim",
		opts = function(_, opts)
			compact_tree()
			return vim.tbl_deep_extend("force", opts or {}, {
				picker = {
					icons = {
						-- defaults are 2 cells wide ("│ ", "├╴", "└╴"); these
						-- are 1, so one nesting level == one column
						tree = {
							vertical = "│",
							middle = "├",
							last = "└",
						},
					},
					formatters = {
						file = {
							-- default 2 pads a blank column after the filetype
							-- icon; 1 butts the name right up against it
							icon_width = 1,
						},
					},
					sources = {
						explorer = {
							-- globs are matched against the full path and
							-- anchored at the end, so "*.meta" is anything
							-- ending in .meta. add more here as needed.
							exclude = {
								"*.meta",
								"*.csproj",
								"*.sln",
								"*.slnx",
							},
						},
					},
				},
			})
		end,
	},
}
