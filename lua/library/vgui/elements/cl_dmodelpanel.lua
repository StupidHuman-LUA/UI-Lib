local PANEL = {}

function PANEL:Init()

end

function PANEL:SetModel(strModelName)
    if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil
	end

	if ( !ClientsideModel ) then return end

	self.Entity = ClientsideModel( strModelName, RENDERGROUP_OTHER )
	if ( !IsValid( self.Entity ) ) then return end

	self.Entity:SetNoDraw( true )
	self.Entity:SetIK( false )

	local iSeq = self.Entity:LookupSequence( "walk_all" )
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end

    local mn, mx = self.Entity:GetRenderBounds()
    local size = 12
    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
    self:SetCamPos(Vector(size, size, size))
    self:SetLookAt((mn + mx) * 0.5)
    self:SetMouseInputEnabled(false)
end

function PANEL:LayoutEntity() 
    return 
end

local lerp1, lerp2 = 0, 0
function PANEL:Think()
    local cursorX, cursorY = self:GetParent():CursorPos()

    local headBone = self.Entity:LookupBone("ValveBiped.Bip01_Head1")
    if not headBone then return end

    local modelCenterX, modelCenterY = self:GetWide() / 4, self:GetTall() / 5

    local offsetX = cursorX - (self.x + modelCenterX)
    local offsetY = cursorY - (self.y + modelCenterY)

    local pitch = math.deg(math.atan2(offsetY, 500))
    local yaw = math.deg(math.atan2(offsetX, 500))

    pitch = math.Clamp(pitch, -45, 45)
    yaw = math.Clamp(yaw, -45, 45)

    lerp1 = Lerp(FrameTime() * 4, lerp1, pitch)
    lerp2 = Lerp(FrameTime() * 4, lerp2, yaw)
    
    self.Entity:ManipulateBoneAngles(headBone, Angle(0, -lerp1, lerp2))
end

vgui.Register('eui.ModelPanel', PANEL, 'DModelPanel')