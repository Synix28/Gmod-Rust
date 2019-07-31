--[[

    Inventory - SV Meta

]]--

local PLAYER = FindMetaTable("Player")

function PLAYER:AddItem(inv, itemid, amount)
    local invData = RUST.Inventories[inv].slots
    local freeSlots = RUST.HasSpaceForAmount(inv, itemid, amount)

    local max = RUST.Items[itemid].max

    if( freeSlots )then
        local remainingAmount = amount

        for _, slot in ipairs(freeSlots) do
            local data = invData[slot]

            if( data && data.amount < max )then
                local freeAmount = max - data.amount

                if( freeAmount <= remainingAmount )then
                    invData[slot].amount = max
                    remainingAmount = remainingAmount - freeAmount
                    print(slot, invData[slot].amount)
                elseif( freeAmount > remainingAmount )then
                    invData[slot].amount = invData[slot].amount + remainingAmount
                    remainingAmount = 0
                end

                netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
            end

            if( !data )then
                invData[slot] = {}
                invData[slot].itemid = itemid

                if( remainingAmount >= max )then
                    invData[slot].amount = max
                    remainingAmount = remainingAmount - max
                else
                    invData[slot].amount = remainingAmount
                    remainingAmount = 0
                end

                netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
            end

            if( remainingAmount <= 0 )then
                return true
            end
        end

        PrintTable(RUST.Inventories[inv].slots)

        return true
    end

    return false
end

function PLAYER:RemoveItem(inv, itemid, amount)

end