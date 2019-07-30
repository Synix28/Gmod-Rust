--[[

    Inventory - SH Meta

]]--

local PLAYER = FindMetaTable("Player")

if( SERVER )then
    function PLAYER:AddItem(inv, itemid, amount)
        local invData = RUST.Inventories[inv].slots
        local freeSlot = RUST.HasSpace(inv, itemid, amount)

        if( freeSlot )then
            if( invData[freeSlot] )then
                invData[freeSlot].amount = invData[freeSlot].amount + amount
            else
                invData[freeSlot] = {}
                invData[freeSlot].itemid = itemid
                invData[freeSlot].amount = amount
            end

            netstream.Start(ply, "RUST_UpdateSlot", inv, freeSlot, itemid, amount)

            PrintTable(RUST.Inventories[inv].slots)

            return true
        end

        return false
    end
end

function PLAYER:GetInv()
    return "Player_Inv_" .. self:SteamID()
end