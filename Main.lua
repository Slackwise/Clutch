--[[
DOCUMENTATION USED:
http://wowprogramming.com/docs/events/UNIT_ENTERED_VEHICLE
http://wowprogramming.com/docs/events/UNIT_EXITED_VEHICLE
http://wowprogramming.com/docs/api/SetOverrideBinding
http://wowprogramming.com/docs/api/ClearOverrideBindings
FrameXML/Bindings.xml
]]


--INITIALIZE
local addon = LibStub("AceAddon-3.0"):NewAddon(
    "Clutch", "AceConsole-3.0", "AceEvent-3.0")
_G["Clutch"] = addon
local db_defaults = {
    profile = {
        bindings = { "1", "2", "3", "4", "5", "6" }
    }
}
local db
local frame = CreateFrame("Frame") --For override bindings.


--ACE ADDON HANDLERS
function addon:OnInitialize()
    print("==========ADDON_LOADED==========")
    addon.db = LibStub("AceDB-3.0"):New("ClutchDB", db_defaults, true)
    db = addon.db.profile
end

function addon:OnEnable()
    addon:RegisterEvent("UNIT_ENTERED_VEHICLE")
    addon:RegisterEvent("UNIT_EXITED_VEHICLE")
    addon:RegisterChatCommand("clutch", "SlashCmdHandler")
end

function addon:OnDisable()
end


--MAIN FUNCTIONS
function addon:SlashCmdHandler(input)
    local arg = addon:GetArgs(input)
    if arg == "clear" then
        print("Clutch bindings cleared!")
        ClearOverrideBindings(frame)
    elseif arg == "joust" then
        print("Setting to Yumi's defaults!")
        db.bindings = { "E", "4", "F", "R", "SHIFT-R", "T" }
    elseif arg == "default" then
        print("Setting to default 1-6 bindings!")
        db.bindings = { "1", "2", "3", "4", "5", "6" }
    elseif arg == "reset" then
        print("Unsetting 'ClutchDB' Bindings variable!")
        addon:ResetDB()
    elseif arg == "" then
        InterfaceOptionsFrame_OpenToCategory(ClutchOptions)
    else
        print("HELP MESSAGE HERE")
    end
end

function addon:UNIT_ENTERED_VEHICLE(event, arg1, arg2)
    if arg1 == "player" then
        print("==========UNIT_ENTERED_VEHICLE==========")
        if UnitHasVehicleUI("player") then
            print("==========UnitHasVehicleUI TRUE!==========")
            for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
                if HasAction(i) then
                    SetOverrideBinding(frame, true, db.bindings[i],
                    "ACTIONBUTTON" .. i)
                end
            end
        end 
    end
end

function addon:UNIT_EXITED_VEHICLE(event, arg1, arg2)
    if arg1 == "player" then
        print("==========UNIT_EXITED_VEHICLE==========")
        --Does not work while InCombatLockdown().
        --Must find workaround... :(
        ClearOverrideBindings(frame)
    end
end
