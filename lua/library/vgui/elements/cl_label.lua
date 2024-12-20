local PANEL = {}

function PANEL:Init()
    self:SetTextColor(eui:Config('colors white'))
end

function PANEL:SetColor(clr)
    self:SetTextColor(clr)
end

function PANEL:SetInfo(text, font)
    self:SetText(text)
    self:SetFont(font)
    self:SizeToContents()
end

vgui.Register('eui.Label', PANEL, 'DLabel')