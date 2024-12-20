eui.cfg = eui.cfg or {}
eui.cfg.admins = eui.cfg.admins or {}

local admins = eui.cfg.admins

admins.ranks = {
    ['superadmin'] = true,
    ['root'] = true,
}

function admins:IsUserAdmin(pl)
    local rank = pl:GetUserGroup()

    if self.rank[rank] then
        return true
    end

    return false
end