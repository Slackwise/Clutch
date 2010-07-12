_G.Clutch.options = {
    type = "group",
    args = {
        general = {
            type = "group",
            name = "General Settings",
            desc = "General settings for the entire addon.",
            args = {
                enable = {
                    name = "Enabled",
                    desc = "Enable/disable this addon",
                    type = "toggle",
                    get = function() return Clutch:IsEnabled() end,
                    set = function() if Clutch:IsEnabled() then Clutch:Disable() else Clutch:Enable() end end,
                }
            }
        }
    }
}
