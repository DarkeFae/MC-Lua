local file = io.open("config/addresses.lua", "r")
if file then
	file:close()
else
	file = io.open("config/addresses.lua", "w")
	file:write("return {\n")
	file:write('{addressName = "Abydos", addressNum = {26, 6, 14, 31, 11, 29, 0}}\n')
	file:write("}\n")
	file:close()
end

local addresses = dofile("config/addresses.lua")
function init(peripheralType)
    local peripherals = peripheral.getNames(peripheralType)
    for i, name in ipairs(peripherals) do
        if string.match(name, peripheralType) then
            print("Found " .. peripheralType .. ": " .. name)
            return peripheral.wrap(name)
        end
    end
    print("No " .. peripheralType .. " found.")
    print("Please connect a " .. peripheralType)
    sleep(20)
    shell.exit(404)
end

local config = dofile("config/config.lua")
local randomTexts = config.randomText
functions = require("functions")
local header = 3
monitor = init("monitor")
monitor.clear()


local width, height = monitor.getSize()
welcome = "Welcome to " .. config.base
local x, y = math.floor((width - #welcome) / 2), 1
monitor.setCursorPos(x, y)
monitor.setTextColor(colors.lime)
monitor.write(welcome)
monitor.setTextColor(colors.white)
local randomText = randomTexts[math.random(#randomTexts)]
monitor.setCursorPos(math.floor((width - #randomText) / 2), y + 1)
monitor.write(randomText)
monitor.setCursorPos(1, header)
functions.breakMonitor()
local addressRegions = {}
local columnWidth = math.floor(width / 2) -- adjust as needed

-- Define the regions for the close and reboot buttons
local closeRegion = {x1 = 1, y1 = height, x2 = math.floor(width / 2), y2 = height}
local rebootRegion = {x1 = math.floor(width / 2) + 1, y1 = height, x2 = width, y2 = height}

function printAddresses()
local x, y = 1, 1 + header
    for i, address in ipairs(addresses) do
        monitor.setCursorPos(x, y)
        local addressText = address.addressName
        if config.showAddressNum then
            addressText = addressText .. ": " .. table.concat(address.addressNum, "-")
        end

        local startX = x + math.floor((columnWidth - #addressText) / 2)

        if i % 2 == 0 then
            monitor.setBackgroundColor(colors.gray)
        else
            monitor.setBackgroundColor(colors.lightGray)
        end

        monitor.setCursorPos(x, y)
        monitor.write(string.rep(" ", columnWidth))

        monitor.setCursorPos(startX, y)
        monitor.write(" " .. addressText .. " ")

        monitor.setBackgroundColor(colors.black)
        addressRegions[i] = {x1 = x, y1 = y, x2 = x + columnWidth - 1, y2 = y}
        y = y + 1
        if y > height then
            y = 1
            x = x + columnWidth
            if x > width then x = 1 end
        end
    end
end
function printButtons()
    closeMSG = "Close Stargate"
    rebootMSG = "Reboot System"
    monitor.setCursorPos(math.floor(closeRegion.x2 - #closeMSG)/2, closeRegion.y1)
    monitor.write(closeMSG)
    monitor.setCursorPos(math.floor(rebootRegion.x1 + math.floor((rebootRegion.x2 - rebootRegion.x1 - #rebootMSG) / 2)), rebootRegion.y1)
    monitor.write("Reboot System")
end

local function terminalSide()
    term.clear()
    term.setCursorPos(1, 1)
    print("Press 'A' to add addresses")
    print("Press 'D' to delete addresses")
    while true do
        local event, key = os.pullEvent("key")
        print(key)
        if key == keys.a or key == keys.a - 32 then
            shell.run("addAddress")
        end
        if key == keys.d or key == keys.d - 32 then
            shell.run("deleteAddress")
        end
    end
end

function monitorSide()
    while true do
    	printAddresses()
        printButtons()
        local event, side, touchX, touchY = os.pullEvent("monitor_touch")
        for i, region in ipairs(addressRegions) do
            if touchX >= region.x1 and touchX <= region.x2 and touchY >= region.y1 and touchY <= region.y2 then


                monitor.setBackgroundColor(colors.green)
                monitor.setCursorPos(region.x1, region.y1)
                monitor.write(string.rep(" ", columnWidth))
                monitor.setCursorPos(region.x1 + math.floor((columnWidth - #addresses[i].addressName) / 2) + 1, region.y1)
                monitor.write(addresses[i].addressName)
                monitor.setBackgroundColor(colors.black)
                sleep(0.9)


                for line = header + 1, height do
                    monitor.setCursorPos(1, line)
                    monitor.clearLine()
                end
                monitor.setCursorPos(math.floor(width - #("Dialing " .. addresses[i].addressName)) /2, height / 2)
                monitor.clearLine()
                monitor.write("Dialing " .. addresses[i].addressName)
                dofile("dialing/dialing.lua")
                universal(addresses[i].addressNum)
    			monitor.clearLine()
                break
            end
        end


        -- Check if the close button was clicked
        if touchX >= closeRegion.x1 and touchX <= closeRegion.x2 and touchY >= closeRegion.y1 and touchY <= closeRegion.y2 then
            local interface = init("interface")
            interface.disconnectStargate()
        end

        -- Check if the reboot button was clicked
        if touchX >= rebootRegion.x1 and touchX <= rebootRegion.x2 and touchY >= rebootRegion.y1 and touchY <= rebootRegion.y2 then
            shell.run("reboot")
        end
    end
end

parallel.waitForAny(terminalSide, monitorSide)