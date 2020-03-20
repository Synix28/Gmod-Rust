--[[

    Armor - SH

]]--

local PLAYER = FindMetaTable("Player")

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

// ------------------------------------------------------------------

local types = {
    RUST_ARMOR_TYPE_HEAD,
    RUST_ARMOR_TYPE_CHEST,
    RUST_ARMOR_TYPE_LEGS,
    RUST_ARMOR_TYPE_FEET
}

hook.Add("CanMoveItem", "RUST_HandleArmorSlots", function(ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData)
    local armorInv = ply:GetArmorInv()

    if( toSlotInv == armorInv )then
        local itemData = RUST.Items[fromSlotInvData[fromSlotID].itemid]

        if( !itemData.isArmor || itemData.type != types[toSlotID] )then
            return false
        end

        if( SERVER )then
            for k, bodygroupData in ipairs(RUST.DefaultBodyGroups[itemData.type]) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end

            for k, bodygroupData in ipairs(itemData.bodygroups) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end
        end

        if( CLIENT )then
            ply:EmitSound("item/sfx/zipper.wav", 75)
        end

        return true
    elseif( fromSlotInv == armorInv && toSlotInvData[toSlotID] )then
        local itemData = RUST.Items[toSlotInvData[toSlotID].itemid]

        if( !itemData.isArmor || itemData.type != types[fromSlotID] )then
            return false
        end

        if( SERVER )then
            for k, bodygroupData in ipairs(RUST.DefaultBodyGroups[itemData.type]) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end

            for k, bodygroupData in ipairs(itemData.bodygroups) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end
        end

        if( CLIENT )then
            ply:EmitSound("item/sfx/zipper.wav", 75)
        end

        return true
    elseif( fromSlotInv == armorInv && !toSlotInvData[toSlotID] )then
        local itemData = RUST.Items[fromSlotInvData[fromSlotID].itemid]

        if( SERVER )then
            for k, bodygroupData in ipairs(RUST.DefaultBodyGroups[itemData.type]) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end
        end

        return true
    end
end)