local PANEL = {}

function PANEL:Init()
    self:SetLerp(true)
    self:SetColor(eui:Config('colors.button'))
    self:SetLerpColor(eui:Config('colors.secondary'))
    self:SetDoClick(100)
end

function PANEL:SetFrame(frame)
    self.frame = frame
end

function PANEL:DoClick()
    self.frame:Close()
end

do
    local simpleText = draw.SimpleText

    function PANEL:PaintOver(w, h)
        simpleText('✕', eui.Font('16:Montserrat'), w / 2, h / 2, eui:Config('colors.white'), 1, 1)
    end
end


vgui.Register('eui.Close', PANEL, 'eui.Button')