eui.fonts = {}
eui.ScrW = ScrW()
eui.ScrH = ScrH()    

hook.Add('OnScreenSizeChanged', 'eui:SceenScaleChanged', function(x, y, x1, y1)
    eui.ScrW = x1
    eui.ScrH = y1
end)

do
    local lerp = Lerp // it needs to be cached
    local clr = Color
    local clamp = math.Clamp

    function eui.LerpColor(from, to)
        local speed = FrameTime() * 2

        local r = lerp(speed, from.r, to.r)
        local g = lerp(speed, from.g, to.g)
        local b = lerp(speed, from.b, to.b)
        local a = lerp(speed, from.a, to.a)

        return Color(r, g, b, a)
    end
end

do
    local blur = Material('pp/blurscreen')

    local updateScreenEffectTexture = render.UpdateScreenEffectTexture

    local setMaterial = surface.SetMaterial
    local setDrawColor = surface.SetDrawColor
    local drawTexturedRect = surface.DrawTexturedRect

    function eui.DrawBlur(panel, amount)
        amount = amont or 4

        local x, y = panel:LocalToScreen(0, 0)
        
        setDrawColor(255, 255, 255)
        setMaterial(mat)
        for i = 1, 3 do
            mat:SetFloat('$blur', (i / 3) * amount)
            mat:Recompute()
            updateScreenEffectTexture()
            drawTexturedRect(x * -1, y * -1, eui.ScrW, eui.ScrH)
        end
    end
end

do
    local setMaterial = surface.SetMaterial
    local setDrawColor = surface.SetDrawColor
    local drawTexturedRect = surface.DrawTexturedRect

    function eui.DrawMaterial(mat, x, y, w, h, color)
        color = color or color_white

        setMaterial(mat)
        setDrawColor(color)
        drawTexturedRect(x, y, w, h)
    end
end

do
    local setFont = surface.SetFont
    local getTextSize = surface.GetTextSize
    
    function eui.GetTextSize(text, font)
        setFont(font)
        
        return getTextSize(text)
    end
end

do
    local round = math.Round

    function eui.ScaleWide(w, max)
        max = max or 1600
        
        return round(w / max * eui.ScrW)
    end

    function eui.ScaleTall(h, max)
        max = max or 900

        return round(h / max * eui.ScrH)
    end
end

do
    local createFont = surface.CreateFont
    function eui.Font(name, blur, sizing)
        blur = blur or 0

        local tblName = name .. '.' .. blur .. '.' .. tostring(sizing)
        if eui.fonts[tblName] then
            return eui.fonts[tblName]
        end

        local size, font = string.match(name, '(.*):(.*)')

        eui.fonts[tblName] = 'eui.font.' .. size .. '.' .. font .. '.' .. blur .. '.' .. tostring(sizing)

        createFont(eui.fonts[tblName], {
            font = font,
            size = sizing and eui.ScaleWide(size + 2) or eui.ScaleTall(size + 2),
            weight = 500,
            antialias = true,
            extended = true,
            blursize = blur
        })

        return eui.fonts[tblName]
    end
end