_G.Clutch.options = {
    type = "group",
    args = {
        general = {
            type = "group",
            name = "General",
            desc = "General Settings",
            args = {
                enable = {
                    name = "Enabled",
                    desc = "Enable/disable this addon",
                    type = "toggle",
                    func = function()
                        if Clutch:IsEnabled() then
                            Clutch:Disable()
                        else
                            Clutch:Enable()
                        end
                    end,
                }
            }
        }
    }
}
