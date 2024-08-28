function clearTerm()
	term.clear()
	term.setCursorPos(1,1)
end

if fs.exists("disk/") then 
	print("Disk Found, would you like to update the program? (y/n)")
	local input = io.read()
	if input == "yes" or input == "y" then
		shell.run("disk/update.lua")
		clearTerm()
		print("Update Complete, Please remove the disk...")
		sleep(5)
		os.reboot()
	elseif input == "no" or input == "n" then
		clearTerm()
		shell.run("main.lua")

	else
		print("Invalid input, please try again.")
	end
else
	clearTerm()
	shell.run("main.lua")
end
