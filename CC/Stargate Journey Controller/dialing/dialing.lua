local peripherals = peripheral.getNames()
for i, name in ipairs(peripherals) do
	if string.match(name, "interface") then
		interface = peripheral.wrap(name)
	
	end
end

function universal(address)
	local addressLength = #address
	local start = interface.getChevronsEngaged() + 1

	for chevron = start,addressLength,1
	do
		local symbol = address[chevron]
		interface.engageSymbol(symbol)
	end
end