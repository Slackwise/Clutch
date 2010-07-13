local addon = _G.Clutch

function ClutchCheckButton_OnClick(self)
    if self:GetChecked() then
        addon:SetBindings()
    else
        addon:ClearBindings()
    end
end

function ClutchButton_OnClick()
end
