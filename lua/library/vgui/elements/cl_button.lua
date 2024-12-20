local PANEL = {}

do
    local secondory = eui:Config('colors.secondary')
    function PANEL:Init()
        self.color = secondory
        self.alpha = 100
        self.rounded = 8
    end
end

function PANEL:OnCursorEntered()
    self:SetCursor('hand')
    chat.PlaySound()
end

function PANEL:OnCursorExited()
    self:SetCursor('arrow')
    chat.PlaySound()
end

function PANEL:OnMousePressed(key)
    if key ~= MOUSE_LEFT then return end

    if self.click then
        self.alpha = self.click
    end

    if not self.DoClick then return end
    self:DoClick()
end

function PANEL:SetColor(color)
    self.clr = color
    self.color = color
end

function PANEL:SetLerpColor(color)
    self.lerpColor = color
end

function PANEL:SetLerp(bool)
    self.lerp = bool
end

function PANEL:SetAlpha(alpha)
    self.alpha = alpha
end

function PANEL:SetHover(min, max)
    self.min = min
    self.max = max
end

function PANEL:SetRounded(rounded)
    self.rounded = rounded
end

function PANEL:SetDoClick(alpha)
    self.click = alpha
end

do
    local roundedBox = draw.RoundedBox
    
    function PANEL:Paint(w, h)
        local isHovered = self:IsHovered()
        local speed = engine.TickInterval()

        if isHovered and self.lerp and self.lerpColor then
            self.color = eui.LerpColor(self.color, self.lerpColor)
        elseif isHovered and self.lerp then
            self.alpha = Lerp(speed, self.alpha, self.max)
        elseif not isHovered and self.lerp and self.lerpColor then
            self.color = eui.LerpColor(self.color, self.clr)
        else
            self.alpha = Lerp(speed, self.alpha, self.min)
        end
        
        roundedBox(self.rounded, 0, 0, w, h, ColorAlpha(self.color, self.alpha))
    end 
end

vgui.Register('eui.Button', PANEL, 'Panel')