local widgetsAreUs = require("widgetsAreUs")
local event = require("event")
local metricsDisplays = require("metricsDisplays")
local s = require("serialization")
local sleeps = require("sleepDurations")

local hud = {}
hud.elements = {}
hud.elements.battery = nil
hud.savedCoordinates = {}
hud.savedCoordinates.battery = {}

hud.hide = nil
hud.show = nil

local verbosity = true
local print = print

if not verbosity then
    print = function()
        return false
    end
end

local initMessages = {}

function hud.init()
    print("hud - Line 15: Initializing HUD.")
    local success, err = pcall(function()
        gimp_globals.configuringHUD_lock = true
        print("hud - Line 18: Configuring HUD lock set to true.")
        initMessages = {}
        table.insert(initMessages, widgetsAreUs.initText(200, 162, "Left or Right click to set location"))
        table.insert(initMessages, widgetsAreUs.initText(200, 187, "Middle click to accept"))
        if hud.elements.battery then
            hud.elements.battery.remove()
            os.sleep(sleeps.yield)
            hud.elements.battery = nil
        end
        hud.elements.battery = metricsDisplays.battery.create(1, 1)
        while true do
            local eventType, _, _, x, y, button = event.pull(nil, "hud_click")
            print("HUD - init : click event detected")
            if eventType == "hud_click" then
                if button == 0 then  -- Left click
                    print("hud - Line 25: Left click detected, setting battery location.")
                    if hud.elements.battery then
                        hud.elements.battery.remove()
                        hud.elements.battery = nil
                    end
                    hud.elements.battery = metricsDisplays.battery.create(x, y)
                    hud.savedCoordinates.battery = {x = x, y = y}
                    os.sleep(sleeps.one)
                elseif button == 1 then  -- Right click
                    print("hud - Line 34: Right click detected, adjusting battery location.")
                    if hud.elements.battery then
                        hud.elements.battery.remove()
                        hud.elements.battery = nil
                    end
                    local xModified = x - 203
                    local yModified = y - 183
                    hud.elements.battery = metricsDisplays.battery.create(xModified, yModified)
                    hud.savedCoordinates.battery = {x = xModified, y = yModified}
                    os.sleep(sleeps.one)
                elseif button == 2 then  -- Middle click
                    print("hud - Line 44: Middle click detected, finalizing battery location.")
                    break
                end
            end
            os.sleep(sleeps.yield)
        end

        print("hud - Line 51: Hiding HUD and removing initialization messages.")
        hud.hide()
        for _, v in ipairs(initMessages) do
            v.remove()
        end
        initMessages = nil
        gimp_globals.configuringHUD_lock = false
        print("hud - Line 58: Configuring HUD lock set to false.")
    end)
    if not success then
        print("hud - Line 59: Error in hud.init: " .. tostring(err))
    end
    print("") -- Blank line for readability
end

function hud.hide()
    print("hud - Line 65: Hiding HUD elements.")
    local success, err = pcall(function()
        hud.elements.battery.setVisible(false)
    end)
    if not success then
        print("hud - Line 69: Error in hud.hide: " .. tostring(err))
    end
    print("") -- Blank line for readability
end

function hud.show()
    print("hud - Line 74: Showing HUD elements.")
    local success, err = pcall(function()
        hud.elements.battery.setVisible(true)
    end)
    if not success then
        print("hud - Line 78: Error in hud.show: " .. tostring(err))
    end
    print("") -- Blank line for readability
end

function hud.modemMessageHandler(port, message)
    local success, err = pcall(function()
        if port == 202 then
            local unserializedTable = s.unserialize(message)
            hud.elements.battery.update(unserializedTable)
        end
    end)
    if not success then
        print("hud - Line 91: Error in hud.modemMessageHandler: " .. tostring(err))
    end
end

function hud.persist_through_soft_reset()
    hud.elements.battery = metricsDisplays.battery.create(hud.savedCoordinates.battery.x, hud.savedCoordinates.battery.y)
end

return hud