eui.nets = eui.nets or {}

local nets = eui.nets

function nets:WriteTable(tbl)
    assert(tbl, 'Долбаеб, у тебя tbl - nil, ты аргумент не ввел сука')
    assert(istable(tbl), 'Долбаеб, у тебя блять tbl - не таблица сука конченый')

    local encoded = pon.encode(tbl)
    local int = #encoded

    net.WriteUInt(int, 32)
    net.WriteData(encoded, int)
end

function nets:ReadTable()
    local int = net.ReadUInt(32)
    local data = net.ReadData(int)
    local success, decoded = pcall(pon.decode, data)

    if succes then
        return decoded
    end

    return {}
end

function nets:Send(pl)
    if pl then
        net.Send(pl)
    else
        net.Broadcast()
    end
end