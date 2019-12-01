ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Campfire"
ENT.Category = "Rust"

ENT.Author = "Aden"

ENT.Spawnable = true

ENT.IsCampfire = true

ENT.BurnTimeFac = 2.5
ENT.MaxBurnAmount = 10

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "UsedBy")
    self:NetworkVar("Bool", 0, "FireOn")
end

hook.Add("CanMoveItem", "RUST_HandleRawCookSpaces", function(ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData)
    local toEnt = RUST.Inventories[toSlotInv].owner
    local fromEnt = RUST.Inventories[fromSlotInv].owner

    if( toEnt.IsCampfire && toSlotID <= 6 && toSlotID >= 4 )then
        if( !RUST.RawFood[fromSlotInvData[fromSlotID].itemid] )then
            return false
        end

        return true
    elseif( fromEnt.IsCampfire && toSlotInvData[toSlotID] && fromSlotID <= 6 && fromSlotID >= 4 )then
        local itemData = RUST.Items[toSlotInvData[toSlotID].itemid]

        if( !RUST.RawFood[toSlotInvData[toSlotID].itemid] )then
            return false
        end

        return true
    end
end)

hook.Add("CanMoveItem", "RUST_HandleCookedSpaces", function(ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData)
    local toEnt = RUST.Inventories[toSlotInv].owner
    local fromEnt = RUST.Inventories[fromSlotInv].owner

    if( toEnt.IsCampfire && toSlotID <= 3 && toSlotID >= 1 )then
        return false
    end
end)

hook.Add("CanMoveItem", "RUST_HandleBurnSpace", function(ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData)
    local toEnt = RUST.Inventories[toSlotInv].owner
    local fromEnt = RUST.Inventories[fromSlotInv].owner

    if( toEnt.IsCampfire && toSlotID == 7 )then
        if( fromSlotInvData[fromSlotID].itemid != "wood" )then
            return false
        end

        return true
    elseif( fromEnt.IsCampfire && toSlotInvData[toSlotID] && fromSlotID == 7 )then
        local itemData = RUST.Items[toSlotInvData[toSlotID].itemid]

        if( toSlotInvData[toSlotID].itemid != "wood" )then
            return false
        end

        return true
    end
end)

hook.Add("CanMoveItem", "RUST_HandleCoalSpace", function(ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData)
    local toEnt = RUST.Inventories[toSlotInv].owner
    local fromEnt = RUST.Inventories[fromSlotInv].owner

    if( toEnt.IsCampfire && toSlotID == 8 )then
        return false
    end
end)