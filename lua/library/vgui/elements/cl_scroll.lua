local PANEL = {}

AccessorFunc( PANEL, 'm_HideButtons', 'HideButtons' )

function PANEL:Init()
	self.offset = 0
	self.scroll = 0
	self.canvasSize = 1
	self.barSize = 1

	self.scrollSpeed = 20
	self.scrollSoftness = 0.07

	self:SetSize(5, 15)
	self:SetHideButtons(true)
end

function PANEL:SetSpeed(num)
	self.scrollSpeed = num
end

function PANEL:GetSpeed()
	return self.scrollSpeed
end

function PANEL:SetSoftness(num)
	self.scrollSoftness = num
end

function PANEL:GetSoftness()
	return self.scrollSoftness
end


function PANEL:SetEnabled(b)
	if not b then
		self.offset = 0
		self:SetScroll(0)
		self.HasChanged = true
	end

	self:SetMouseInputEnabled(b)
	self:SetVisible(b)

	if self.Enabled ~= b then
		self:GetParent():InvalidateLayout()
		if self:GetParent().OnScrollbarAppear then
			self:GetParent():OnScrollbarAppear()
		end
	end

	self.Enabled = b
end

function PANEL:Value()
	return self.Pos
end

function PANEL:BarScale()
	if self.barSize == 0 then return 1 end
	return self.barSize / (self.canvasSize + self.barSize)
end

function PANEL:SetUp(_barsize, _canvassize)
	self.barSize = _barsize
	self.canvasSize = math.max(_canvassize - _barsize, 1)
	self:SetEnabled(_canvassize > _barsize)
	self:InvalidateLayout()
end

function PANEL:SetScroll( scrll )
	if not self.Enabled then self.scroll = 0 return end
	self.scroll = math.Clamp(scrll, -30, self.canvasSize + 100)
	self:InvalidateLayout()

	local func = self:GetParent().OnVScroll
	if func then
		func(self:GetParent(), self:GetOffset())
	else
		self:GetParent():InvalidateLayout()
	end
end

function PANEL:OnMouseWheeled( dlta )
    if not self:IsVisible() then return false end

    return self:AddScroll(dlta * -1)
end

function PANEL:AddScroll(dlta)
	local oldScroll = self:GetScroll()
	dlta = dlta * self.scrollSpeed
	self.Scroll2Add = dlta

	return oldScroll ~= self:GetScroll()
end

function PANEL:Think()
	if self.Scroll2Add then
		local oldscroll = self:GetScroll()
		local newscroll = self:GetScroll() + self.Scroll2Add

		self:SetScroll( newscroll )
		self.Scroll2Add = self.Scroll2Add - self.Scroll2Add*self.scrollSoftness

		if math.floor(self:GetScroll()) == math.floor(oldscroll) then self.Scroll2Add = nil end
	end

	if self.scroll > self.canvasSize + 10 then
		self:SetScroll(self:GetScroll() - (self.scroll - self.canvasSize) * 0.08)
	end

	if self.scroll < 0 then
		self:SetScroll(self:GetScroll() + 5)
	end
end

function PANEL:AnimateTo(scrll, length, delay, ease)
	local anim = self:NewAnimation(length, delay, ease)
	anim.StartPos = self.scroll
	anim.TargetPos = scrll
	anim.Think = function(anim, pnl, fraction)
		pnl:SetScroll(Lerp(fraction, anim.StartPos, anim.TargetPos))
	end
end

function PANEL:GetScroll()
	if not self.Enabled then self.scroll = 0 end

	return self.scroll
end

function PANEL:GetOffset()
	if not self.Enabled then return 0 end

	return self.scroll * -1
end

function PANEL:Paint( w, h )
end

function PANEL:OnMouseReleased()
	self.Dragging = false
	self.DraggingCanvas = nil
	self:MouseCapture(false)
end

function PANEL:OnCursorMoved(x, y)
	if not self.Enabled then return end
	if not self.Dragging then return end

	local x, y = self:ScreenToLocal(0, gui.MouseY())

	y = y - self.btnUp:GetTall()
	y = y - self.HoldPos

	local btnHeight = self:GetWide()
	if self:GetHideButtons() then btnHeight = 0 end

	local TrackSize = self:GetTall() - btnHeight * 2

	y = y / TrackSize

	self:SetScroll(y * self.canvasSize)
end

function PANEL:Grip()
	if not self.Enabled then return end
	if self.barSize == 0 then return end

	self:MouseCapture(true)
	self.Dragging = true
end

function PANEL:PerformLayout()
	local wide = self:GetWide()
	local btnHeight = wide

	if self:GetHideButtons() then btnHeight = 0 end

	local scroll = self:GetScroll() / self.canvasSize
	local barSize = math.max(self:BarScale() * (self:GetTall() - (btnHeight * 2)), 10)
	local track = self:GetTall() - (btnHeight * 2) - barSize
	track = track + 1

	scroll = scroll * track
end

vgui.Register('eui.scrollbar', PANEL, 'Panel')