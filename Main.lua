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
addon.frame = CreateFrame("Frame") --For override bindings.
addon.config = LibStub("AceConfig-3.0") 
addon.config.dialog = LibStub("AceConfigDialog-3.0")
_G.Clutch = addon
local db_defaults = {
    profile = {
        bindings = { 
            default = {"1", "2", "3", "4", "5", "6" },
            custom = {}
        }
    }
}

--SHORTHAND/UTILITY FUNCTIONS
local db
local function IsKeybound()
    return ClutchCheckButton:GetChecked()
end
local function InVehicle()
    return UnitHasVehicleUI("player")
end
local function ShowMessage(text)
    ClutchMessageText:SetText(text)
    ClutchMessage:Show()
end
local function HideMessage()
    ClutchMessage:Hide()
end


--ACE ADDON HANDLERS
function addon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ClutchDB", db_defaults, true)
    db = addon.db.profile
    addon.config:RegisterOptionsTable("Clutch", addon.options, "clutch")
    addon.config.dialog:AddToBlizOptions("Clutch", nil,
        nil, "general")
    
end

function addon:OnEnable()
    --self:RegisterChatCommand("clutch", "SlashCmdHandler")
    self:RegisterEvent("UNIT_ENTERED_VEHICLE")
    self:RegisterEvent("UNIT_EXITED_VEHICLE")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function addon:OnDisable()
end


--MAIN FUNCTIONS
function addon:SlashCmdHandler(input)
    local arg = self:GetArgs(input)
    if arg == "clear" then
        print("Clutch bindings cleared!")
        self:ClearBindings()
    elseif arg == "joust" then
        print("Setting to Yumi's defaults!")
        db.bindings.default = { "E", "4", "F", "R", "SHIFT-R", "T" }
    elseif arg == "default" then
        print("Setting to default 1-6 bindings!")
        db.bindings.default = { "1", "2", "3", "4", "5", "6" }
    elseif arg == "reset" then
        print("Unsetting 'ClutchDB' Bindings variable!")
        self:ResetDB()
    elseif arg == "" then
        InterfaceOptionsFrame_OpenToCategory(ClutchOptions)
    else
        print("HELP MESSAGE HERE")
    end
end

function addon:UNIT_ENTERED_VEHICLE(event, unit, arg2)
    if InVehicle() and not InCombatLockdown() and not IsKeybound() then
        self:SetBindings()
    end 
end

function addon:UNIT_EXITED_VEHICLE(event, unit, arg2)
    if InCombatLockdown() and IsKeybound() then
        ShowMessage("Waiting to leave combat to unbind keys...")
    elseif IsKeybound() then
        self:ClearBindings()
    end
end

function addon:PLAYER_REGEN_ENABLED()
    ClutchCheckButton:Enable()
    if IsKeybound() and not InVehicle() then
        self:ClearBindings()
        HideMessage()
    end
end

function addon:PLAYER_REGEN_DISABLED()
    ClutchCheckButton:Disable()
end

function addon:SetBindings()
    local vehicle = GetUnitName("vehicle")
    local bindings = db.bindings.custom[vehicle] ~= nil and
        db.bindings.custom[vehicle] or db.bindings.default
    for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
        if HasAction(i) then
            SetOverrideBinding(self.frame, true, bindings[i],
            "ACTIONBUTTON" .. i)
        end
    end
    ClutchCheckButton:SetChecked(true)
end

function addon:ClearBindings()
    ClearOverrideBindings(self.frame)
    ClutchCheckButton:SetChecked(false)
end
