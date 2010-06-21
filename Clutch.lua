--[[
DOCUMENTATION USED:
http://wowprogramming.com/docs/events/UNIT_ENTERED_VEHICLE
http://wowprogramming.com/docs/events/UNIT_EXITED_VEHICLE
http://wowprogramming.com/docs/api/SetOverrideBinding
http://wowprogramming.com/docs/api/ClearOverrideBindings
FrameXML/Bindings.xml
]]

function Clutch_OnLoad(self)
    -- TODO: Replace with AceDB functions!
    ClutchDB = {}

    local ClutchDB_Defaults = {
        Bindings = { }
    }
    setmetatable(ClutchDB_Defaults.Bindings,
        {__index = function(table, key) return tostring(key) end })

    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("UNIT_ENTERED_VEHICLE")
    self:RegisterEvent("UNIT_EXITED_VEHICLE")

    SlashCmdList["CLUTCH"] =
        function(msg)
            msg = string.trim(msg)
            if msg == "clear" then
                print("Clutch bindings cleared!")
                ClearOverrideBindings(self)
            elseif msg == "joust" then
                print("Setting to Yumi's defaults!")
                ClutchDB.Bindings = { "E", "4", "F", "R", "SHIFT-R", "T" }
            elseif msg == "default" then
                print("Setting to default 1-6 bindings!")
                ClutchDB.Bindings = { "1", "2", "3", "4", "5", "6" }
            elseif msg == "reset" then
                print("Unsetting 'ClutchDB' Bindings variable!")
                ClutchDB.Bindings = {}
            elseif msg == "" then
                InterfaceOptionsFrame_OpenToCategory(ClutchOptions)
            else
                print("HELP MESSAGE HERE")
            end
        end
    SLASH_CLUTCH1 = "/clutch"
end

function Clutch_OnEvent(self, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == "Clutch" then 
        print("==========ADDON_LOADED==========")
        setmetatable(ClutchDB, {__index = ClutchDB_Defaults})
    elseif event == "UNIT_ENTERED_VEHICLE" and arg1 == "player" then
        print("==========UNIT_ENTERED_VEHICLE==========")
        if UnitHasVehicleUI("player") then
            print("==========UnitHasVehicleUI TRUE!==========")
            for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
                if HasAction(i) then
                    SetOverrideBinding(self, true, ClutchDB.Bindings[i],
                    "ACTIONBUTTON" .. i)
                end
            end
        end 
    elseif event == "UNIT_EXITED_VEHICLE" and arg1 == "player" then
        print("==========UNIT_EXITED_VEHICLE==========")
        --Does not work while InCombatLockdown().
        --Must find workaround... :(
        ClearOverrideBindings(self)
    end
end
