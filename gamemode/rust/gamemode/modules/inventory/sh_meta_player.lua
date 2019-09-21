--[[

    Inventory - SH Meta

]]--

local PLAYER = FindMetaTable("Player")

function PLAYER:GetInv()
    return "Player_Inv_" .. self:SteamID()
end

function PLAYER:GetHotbarInv()
    return "Player_Hotbar_" .. self:SteamID()
end

function PLAYER:GetArmorInv()
    return "Player_Armor_" .. self:SteamID()
end

function PLAYER:HasArmorEquiped()
    local hasArmor = false
    local invData = RUST.Inventories[self:GetArmorInv()].slots

    for slot, data in ipairs(invData) do
        if( data )then
            hasArmor = true
            break
        end
    end

    return hasArmor
end

function PLAYER:GetArmorStatsSum()
    local invData = RUST.Inventories[self:GetArmorInv()].slots
    local stats = {
        bullet = 0,
        melee = 0,
        explosion = 0,
        cold = 0,
        radiation = 0
    }

    for slot, data in ipairs(invData) do
        if( data )then
            local itemData = RUST.Items[data.itemid]

            for k, v in pairs(itemData.stats) do
                stats[k] = stats[k] + v
            end
        end
    end

    return stats
end