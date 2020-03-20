ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Furnace"
ENT.Category = "Rust"

ENT.Author = "Aden"

ENT.Spawnable = true

ENT.IsFurnace = true
ENT.IsLightable = true

ENT.BurnTimeFac = 3
ENT.MaxBurnAmount = 10

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "UsedBy")
    self:NetworkVar("Bool", 0, "FireOn")
end

hook.Add("CanMoveItem", "RUST_HandleFurnaceSlots", function(ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData)
    local toEnt = RUST.Inventories[toSlotInv].owner
    local fromEnt = RUST.Inventories[fromSlotInv].owner

    local toEnt = RUST.Inventories[toSlotInv].owner
    local fromEnt = RUST.Inventories[fromSlotInv].owner

    if( toEnt.IsFurnace )then
        if( !RUST.PlaceableInFurnace[fromSlotInvData[fromSlotID].itemid] )then
            return false
        end

        return true
    elseif( fromEnt.IsFurnace && toSlotInvData[toSlotID] )then
        local itemData = RUST.Items[toSlotInvData[toSlotID].itemid]

        if( !RUST.PlaceableInFurnace[toSlotInvData[toSlotID].itemid] )then
            return false
        end

        return true
    end
end)