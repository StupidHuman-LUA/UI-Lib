eui.colors = eui.colors or {}

function eui.Color(color, alpha)
    if not alpha then
        alpha = 255
    else
        alpha = alpha * (1 / 100) * 255
    end

    color = color:gsub('#', '')

    local name = color .. '.' .. alpha

    if eui.colors[name] then
        return eui.colors[name]
    end

    local r = tonumber('0x' .. color:sub(1, 2))
    local g = tonumber('0x' .. color:sub(3, 4))
    local b = tonumber('0x' .. color:sub(5, 6))

    eui.colors[name] = Color(r, g, b, alpha)

    return eui.colors[name]
end

function eui:Config(key)
    local sequence1 = string.Explode('.', key)
    local sequence2 = #sequence1
    local tbl = self.cfg

    for i = 1, sequence2 do
        local part = sequence1[i]

        if tbl[part] then
            if i == sequence2 then
                return tbl[part]
            else
                tbl = tbl[part]
            end
        end
    end

    return fallback
end

if SERVER then
    util.AddNetworkString('eui:Notify')

    function eui.Notify(pl, text, args, type, len)
        assert(isentity(pl), ('Долбаеб бля, у тебя pl - не игрок нахуй, а долбаеб какой то - %s'):format(pl))
        assert(isstring(text), ('Долбаеб бля, у тебя text - не текст нахуй, а хуйня какая то - %s'):format(text))
        assert(isstring(args), ('Долбаеб бля, у тебя args - не таблица нахуй, а хуйня какая то - %s'):format(args))

        net.Start('eui:Notify')
        net.WriteString(text)
        net.WriteUInt(type or 0, 3)
        net.WriteUInt(len or 3, 4)
        eui.nets.WriteTable(args)
        net.Send(pl)
    end
else
    net.Receive('eui:Notify', function()
        local text = net.ReadString
        local type = net.ReadUInt(3)
        local len = net.ReadUInt(4)
        local args = eui.nets.ReadTable()

        local text = eui.lang:Get(text, args)

        notification.AddLegacy(text, type, len)
    end)
end

eui.cfg.colors = {}
eui.cfg.colors.primary = eui.Color('13161A')
eui.cfg.colors.secondary = eui.Color('FF9C41')
eui.cfg.colors.button = eui.Color('1D1E22', 43)
eui.cfg.colors.white = eui.Color('FFFFFF')
eui.cfg.colors.scroll = eui.Color('1D1E22', 43)