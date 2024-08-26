local configurations = require("configurations")
local overlay = require("overlay")
local hud = require("hud")
local itemWindow = require("itemWindow")
local machinesManager = require("machinesManager")
local event = require("event")
local thread = require("thread")
local gimpHelper = require("gimpHelper")

local backend = {}

local threadManager
local updateThread = nil
local levelMaintThreads = {}

local function manageThreads()
    print("backend - line 21: manageThreads called")
    os.sleep(50)
    if (gimp_globals.configuringHUD_lock or gimp_globals.initializing_lock) and updateThread and updateThread:status() ~= "dead" then
        print("backend - line 24: Killing updateThread due to existing lock")
        updateThread:kill()
    end
    os.sleep(50)
    return manageThreads()
end

local function update()
    print("backend - line 33: update called")
    os.sleep(0)
    local success, error = pcall(overlay.update)
    if not success then
        print("backend - line 37: overlay.update call failed with error : " .. tostring(error))
    end
end

local function onUpdate()
    print("backend - line 43: onUpdate called")
    if updateThread and updateThread:status() ~= "dead" then
        print("backend - line 45: Killing updateThread due to it existing")
        updateThread:kill()
    end
    print("backend - line 48: Creating new updateThread")
    updateThread = thread.create(update)
    print("backend - line 50: waiting for locks to clear")
    while gimp_globals.initializing_lock or gimp_globals.configuringHUD_lock do
        print("backend - line 52: Still waiting for locks to clear")
        os.sleep(100)
    end
    print("backend - line 53: Starting updateThread")
    updateThread:resume()
end

local function makeLevelMaintThread(data)
local data = data

    print("backend - line 58: makeLevelMaintThread called")
    if not levelMaintThread or levelMaintThread:status() == "dead" then
        print("backend - line 60: Creating new levelMaintThread")
        levelMaintThread = thread.create(function()
            
        end)
        table.insert(levelMaintThreads, levelMaintThread)
    end
end

local function addLevelMaintThread(index)
    local data = {}
    local tbl1 = gimpHelper.loadTable("/home/programData/levelMaintainer.data")
    local tbl2 = gimpHelper.loadTable("/home/programData/levelMaintainerConfig.data")
    if tbl2 and tbl2[index] and tbl2[index].enabled then
        
    end



    print("backend - line 70: addLevelMaintThread called")
    makeLevelMaintThread(data)
end

event.listen("update_overlay", onUpdate)

threadManager = thread.create(manageThreads)
threadManager:resume()

return backend