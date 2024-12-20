local PANEL = {}

function PANEL:Init()
	self.avatar = vgui.Create('AvatarImage', self)
	self.avatar:SetPaintedManually(true)
    self:SetMouseInputEnabled(false)
end

function PANEL:PerformLayout()
	self.avatar:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:SetPlayer(pl, bit)
	self.avatar:SetPlayer(pl, bit)
end

function PANEL:SetRounded(rounded)
    self.rounded = rounded
end

do
    local maskMaterial = CreateMaterial('!brsmask', 'UnlitGeneric', {
        ['$translucent'] = 1,
        ['$vertexalpha'] = 1,
        ['$alpha'] = 1,
    })

    local renderTarget, previousRenderTarget

    local getRenderTarget = render.GetRenderTarget
    local pushRenderTarget = render.PushRenderTarget
    local overrideAlphaWriteEnable = render.OverrideAlphaWriteEnable
    local clear = render.Clear
    local overrideBlendFunc = render.OverrideBlendFunc
    local roundedBox = draw.RoundedBox
    local popRenderTarget = render.PopRenderTarget
    local noTexture = draw.NoTexture
    local setDrawColor = surface.SetDrawColor
    local setMaterial = surface.SetMaterial
    local rSetMaterial = render.SetMaterial
    local drawScreenQuad = render.DrawScreenQuad

    function PANEL:Paint(w, h)
        if not renderTarget then
            renderTarget = GetRenderTargetEx( 'GRADIENT_ROUNDEDAVATAR', eui.ScrW, eui.ScrH, RT_SIZE_FULL_FRAME_BUFFER, MATERIAL_RT_DEPTH_NONE, 2, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGBA8888 )
        end

        if not previousRenderTarget then
            previousRenderTarget = getRenderTarget() 
        end

        pushRenderTarget(renderTarget)
        overrideAlphaWriteEnable(true, true)
        clear(0, 0, 0, 0) 

        self.avatar:PaintManual()

        overrideBlendFunc(true, BLEND_ZERO, BLEND_SRC_ALPHA, BLEND_DST_ALPHA, BLEND_ZERO)
        roundedBox((self.rounded or 0), 0, 0, w, h, color_white)
        overrideBlendFunc(false)
        overrideAlphaWriteEnable(false)
        popRenderTarget() 

        maskMaterial:SetTexture('$basetexture', renderTarget)

        noTexture()

        setDrawColor(255, 255, 255) 
        setMaterial(maskMaterial) 
        rSetMaterial(maskMaterial)
        drawScreenQuad() 
    end
end

vgui.Register('eui.Avatar', PANEL)