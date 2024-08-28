local peripherals = peripheral.getNames()
for i, name in ipairs(peripherals) do
    if string.match(name, "interface") then
        interface = peripheral.wrap(name)
    
    end
end

function milkyway(address)
    local addressLength = #address
    interface.closeChevron()
   
    local start = interface.getChevronsEngaged() + 1
   
    for chevron = start,addressLength,1
    do
        local symbol = address[chevron]
        
        if chevron % 2 == 0 then
            interface.rotateClockwise(symbol)
        else
            interface.rotateAntiClockwise(symbol)
        end
        
        while(not interface.isCurrentSymbol(symbol))
        do
            sleep(0)
        end
		
        interface.endRotation();
        
        sleep(1)
        interface.openChevron()
		        
        sleep(0.5)
        if chevron < addressLength then
            interface.encodeChevron()
        end
		
        sleep(0.5)
        interface.closeChevron()
        sleep(1)
    end 
end