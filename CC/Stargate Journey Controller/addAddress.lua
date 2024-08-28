addresses = dofile("config/addresses.lua")

    print("Please enter the name of the address:")
    local name = io.read()
    print("Please enter the address (end with 0):")
    local address = {}
    local i = 1
    while true do
        local suffix = "th"
        if i == 1 then
            suffix = "st"
        elseif i == 2 then
            suffix = "nd"
        elseif i == 3 then
            suffix = "rd"
        end
        print("Please enter the " .. i .. suffix .. " number:")
        local num = tonumber(io.read())
        if num == 0 or i == 9 then
            address[i] = 0
            break
        end
        address[i] = num
        i = i + 1
    end
    if #address < 7 then
		clearTerm()
        print("Address is too short. It must be between 7 and 9 symbols.")
		sleep(5)
        return
    end
    table.insert(addresses, {addressName = name, addressNum = address})
    file = io.open("config/addresses.lua", "w")
    file:write("return {\n")
    for i, entry in ipairs(addresses) do
        file:write('{addressName = "' .. entry.addressName .. '", addressNum = {' .. table.concat(entry.addressNum, ', ') .. '}}')
        if i ~= #addresses then
            file:write(",\n")
        else
            file:write("\n")
        end
    end
    file:write("}\n")
    file:close()
    os.reboot()

