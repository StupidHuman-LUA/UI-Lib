local PANEL = {}

local function resizeElements(pnl)
	local x, y = pnl:GetSize()
	
	pnl.circle:SetSize(y * 0.9, y * 0.9)
	pnl.circle:CenterVertical(0.5)

	pnl.circle:SetX(pnl:GetCirclePos(pnl:GetChecked()))
end

PANEL.PerformLayout = resizeElements

function PANEL:GetCirclePos(state)
	local x, circleWidth = self:GetWide(), self.circle:GetWide()
	if state then
		return x - circleWidth - x * 0.02
	else
		return x * 0.02
	end
end

do
	local colorOff = eui:Config('colors.primary')
	local colorOn = eui:Config('colors.secondary')

	local setDrawColor = surface.SetDrawColor
	local setMaterial = surface.SetMaterial
	local drawTexturedRect = surface.DrawTexturedRect

	local circleMat = Material('lib/circle.png')

	function PANEL:Init()
        self.color = eui:Config('colors.scroll')
        self.alpha = 255

		self.circle = self:Add('Panel')
		self.circle:SetMouseInputEnabled(false)
        function self.circle:Paint(w, h)
            setMaterial(circleMat)
            setDrawColor(255, 255, 255)
            drawTexturedRect(0, 0, w, h)
        end
	end
end

function PANEL:OnChange(val)
	local newX = self:GetCirclePos(val)
	self.circle:MoveTo(newX, self.circle:GetY(), 0.1)

	self:OnChangeCustom(val)
end

function PANEL:OnChangeCustom(val) end

do
	local roundedBox = draw.RoundedBox

	function PANEL:Paint(x, y)
        local checked = self:GetChecked()
        local isHovered = self:IsHovered()
        
        self.alpha = Lerp(engine.TickInterval(), self.alpha, isHovered and 50 or 255)

        self.color = eui.LerpColor(self.color, checked and eui:Config('colors.secondary') or eui:Config('colors.scroll'))
		roundedBox(16, 0, 0, x, y, ColorAlpha(self.color, self.alpha))
	end
end

vgui.Register('eui.CheckBox', PANEL, 'DCheckBox')