PANEL = {}

function PANEL:Init()
    self.color = eui:Config('colors secondary')
    self.alpha = 255
    self.hover = false

    self.textEntry = vgui.Create('DTextEntry', self)
    self.textEntry:Dock(FILL)
    self.textEntry:SetDrawLanguageID()
    function self.textEntry:OnGetFocus()
        if self:GetValue() == self.startText then
            self:SetValue('') 
        end
    end
end

function PANEL:SetColor(color)
    self.color = color
end

function PANEL:SetInfo(text, font, x, y)
    self.textEntry.startText = text
    self.textEntry:SetFont(font)
    self.textEntry:SetValue(text)
    self.textEntry:DockMargin(x, y, x, y)

    local clr = ColorAlpha(color_white, 40)
    function self.textEntry.Paint(pan, w, h)
        self.hover = pan:IsHovered()

        pan:DrawTextEntryText(color_white, clr, color_white)
    end
end

do
    local roundedBox = draw.RoundedBox
    function PANEL:Paint(w, h)
        self.alpha = Lerp(engine.TickInterval(), self.alpha, (self:IsHovered() or self.hover) and 100 or 255)
        
        roundedBox(8, 0, 0, w, h, ColorAlpha(self.color, self.alpha))
    end
end

function PANEL:GetValue()
    return self.textEntry:GetValue()
end

vgui.Register('eui.TextEntry', PANEL, 'Panel')