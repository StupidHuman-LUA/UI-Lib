local PANEL = {}

function PANEL:Init()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.2)
    self:MakePopup()
end

function PANEL:SetCloseButton(but)
    self.closeButton = but
end

do
    local isKeyDown = input.IsKeyDown

    function PANEL:Think()
        if not self.closeButton then return end
    
        if isKeyDown(self.closeButton) then
            self:Close()
        end
    end
end

function PANEL:Close()
    self:AlphaTo(0, 0.2, 0, function(_, pan)
        pan:Remove()
    end)
    gui.HideGameUI()
end

vgui.Register('eui.Frame', PANEL, 'EditablePanel')