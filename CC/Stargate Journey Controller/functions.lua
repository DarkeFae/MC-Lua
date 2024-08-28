return {
	clearTerm = function()
		term.clear()
		term.setCursorPos(1,1)
	end,
	breakTerm = function()
		local width, height = term.getSize()
		monitor.setTextColor(colors.gray)
		for i = 1, width do
			monitor.write("-")
		end
		monitor.setTextColor(colors.white)
	end,
	breakMonitor = function()
		local width, height = monitor.getSize()
		monitor.setTextColor(colors.gray)
		for i = 1, width do
			monitor.write("-")
		end
		monitor.setTextColor(colors.white)
	end
}