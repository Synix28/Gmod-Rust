--[[

    Inventory - SV Meta

]]--

local PLAYER = FindMetaTable("Player")

function PLAYER:AddItem(inv, itemid, amount, itemData)
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
                elseif( freeAmount > remainingAmount )then
                    invData[slot].amount = invData[slot].amount + remainingAmount
                    remainingAmount = 0
                end

                if( itemData )then
                    invData[slot].itemData = itemData
                end

                if( itemData )then
                    invData[slot].itemData = itemData

                    netstream.Start(self, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount, invData[slot].itemData)
                else
                    netstream.Start(self, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
                end
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

                if( itemData )then
                    invData[slot].itemData = itemData

                    netstream.Start(self, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount, invData[slot].itemData)
                else
                    netstream.Start(self, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
                end
            end

            if( remainingAmount <= 0 )then
                break
            end
        end

        return true
    end

    return false
end

function PLAYER:RemoveItem(inv, itemid, amount)
    local invData = RUST.Inventories[inv].slots
    local availableAmount = RUST.GetItemAmountFromInv(self:GetInv(), itemid)

    if( availableAmount && availableAmount >= amount )then
        for slot, data in ipairs(invData) do
            if( data && data.itemid == itemid )then
                if( data.amount <= amount )then
                    local amountToRemove = data.amount
                    
                    invData[slot] = false
                    amount = amount - amountToRemove
                else
                    invData[slot].amount = invData[slot].amount - amount
                    amount = 0
                end

                if( !invData[slot] )then
                    netstream.Start(self, "RUST_UpdateSlot", inv, slot, itemid, 0)
                else
                    netstream.Start(self, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
                end

                if( amount <= 0 )then
                    break
                end
            end
        end

        return true
    end

    return false
end