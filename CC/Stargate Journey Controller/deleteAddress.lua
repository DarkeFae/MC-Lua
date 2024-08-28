addresses = dofile("config/addresses.lua")

    print("Please enter the number of the address to remove:")
    for i, entry in ipairs(addresses) do 
        print(i .. ":" .. entry.addressName)
    end

    local input = tonumber(io.read())
    if input ~= nil and input > 0 and input <= #addresses then
        table.remove(addresses, input)
        print("Address removed.")

        -- Write the modified addresses table back to the file
        local file = io.open("config/addresses.lua", "w")
        file:write("return {\n")
        for i, entry in ipairs(addresses) do
            file:write('{addressName = "' .. entry.name .. '", addressNum = {' .. table.concat(entry.address, ', ') .. '}}')
            if i ~= #addresses then
                file:write(",\n")
            else
                file:write("\n")
            end
        end
        file:write("}\n")
        file:close()
        os.reboot()
    else
        print("Invalid selection")
    end
