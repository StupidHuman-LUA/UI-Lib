local panel = FindMetaTable('Panel')

function panel:GetX()
    local x = self:GetPos()
    
    return x
end

function panel:GetY()
    local _, y = self:GetPos()

    return y
end

function panel:SetX(x)
    self:SetPos(x, self:GetY())
end

function panel:SetY(y)
    self:SetPos(self:GetX(), y)
end

function panel:Margin(x, y, x1, y1)
    x = x or 0
    y = y or 0
    x1 = x1 or 0
    y1 = y1 or 0

    self:DockMargin(x, y, x1, y1)
end

function panel:Combine(pnl2, fnName)
    self[fnName] = function(_, ...)
        return pnl2[fnName](pnl2, ...)
    end
end

function panel:CombineMutator(pnl2, mutatorName)
    self:Combine(pnl2, 'Set' .. mutatorName)
    self:Combine(pnl2, 'Get' .. mutatorName)
end