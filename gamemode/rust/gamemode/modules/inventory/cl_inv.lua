--[[

    Inventory - CL

]]--

function GM:ScoreboardShow()
end

// ------------------------------------------------------------------

netstream.Hook("RUST_OpenInventory", function()
    if( !RUST.VGUI.BasePanel )then // Wenn nicht offen, dann ...
        RUST.VGUI.BasePanel = vgui.Create("RUST_Base")
    end
end)

netstream.Hook("RUST_SyncInventory", function(inv, data) // Volle Synchronisation eines Inventars.
    local ply = LocalPlayer()
    RUST.Inventories[inv] = data
end)

netstream.Hook("RUST_CreateHotbar", function() // Hotbar erstellen.
    RUST.VGUI.Hotbar = vgui.Create("RUST_Hotbar")
end)

netstream.Hook("RUST_UpdateSlot", function(inv, slot, itemid, amount) // Inventar Slot updaten + im Inventar adden, wenn offen.
    local invData = RUST.Inventories[inv].slots

    if( invData[slot] )then // Wenn Slot bereits vewendet, dann
        invData[slot].amount = invData[slot].amount + amount // amount dazu adden

        if( RUST.VGUI.BasePanel && IsValid(RUST.VGUI.BasePanel) && RUST.VGUI.BasePanel.inventory )then
            RUST.VGUI.BasePanel.inventory.list:GetChildren()[slot]:GetChildren()[1]:SetAmount(invData[slot].amount)
        end
    else
        invData[slot] = {} // ansonsten Item erstellen
        invData[slot].itemid = itemid
        invData[slot].amount = amount

        if( RUST.VGUI.BasePanel && IsValid(RUST.VGUI.BasePanel) && RUST.VGUI.BasePanel.inventory )then // Item im Inventar erstellen
            local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.inventory.list:GetChildren()[slot])
            Item:SetItemID(invData[slot].itemid)
            Item:SetAmount(invData[slot].amount)
        end
    end
end)

// ------------------------------------------------------------------

function RUST.MoveItem(fromSlot, toSlot) // Item im Inventar moven, von Inventar zu Inventar moven, Items tauschen
    local ply = LocalPlayer()

    local toSlotItem = toSlot:GetChildren()[1]
    local fromSlotItem = fromSlot:GetChildren()[1]

    if( !RUST.Inventories[fromSlot.inv] || !RUST.Inventories[toSlot.inv] )then return end

    local fromSlotInvData = RUST.Inventories[fromSlot.inv].slots
    local toSlotInvData = RUST.Inventories[toSlot.inv].slots

    if( toSlotItem )then
        if( fromSlotItem.itemid == toSlotItem.itemid )then // Wenn geleiches Item, dann ...
            local amount = fromSlotInvData[fromSlot.id].amount + toSlotInvData[toSlot.id].amount
            local max = RUST.Items[toSlotItem.itemid].max

            if( amount > max )then // Wenn amount aus von Slot + zu Slot größer als max
                local fromSlotData = fromSlotInvData[fromSlot.id]
                fromSlotData.amount = max

                fromSlotInvData[fromSlot.id].amount = amount - max
                toSlotInvData[toSlot.id].amount = max

                fromSlotItem:SetAmount(amount - max)
                toSlotItem:SetAmount(max)
            elseif( amount == max ) then // wenn amount gleich max
                local fromSlotData = fromSlotInvData[fromSlot.id]
                fromSlotData.amount = max

                fromSlotInvData[fromSlot.id] = false
                toSlotInvData[toSlot.id] = fromSlotData

                toSlotItem:SetAmount(max)
                fromSlotItem:Remove()
            else // ansonsten auf den neuen slot gehen
                local fromSlotData = fromSlotInvData[fromSlot.id]
                fromSlotData.amount = amount

                fromSlotInvData[fromSlot.id] = false
                toSlotInvData[toSlot.id] = fromSlotData

                toSlotItem:SetAmount(amount)
                fromSlotItem:Remove()
            end

            netstream.Start("RUST_MoveItem", fromSlot.id, fromSlot.inv, toSlot.id, toSlot.inv) // Server updaten
        else // ansonsten austauschen
            local fromSlotData = fromSlotInvData[fromSlot.id]
            local toSlotData = toSlotInvData[toSlot.id]

            fromSlotInvData[fromSlot.id] = toSlotData
            toSlotInvData[toSlot.id] = fromSlotData

            fromSlotItem:SetItemID(toSlotData.itemid)
            fromSlotItem:SetAmount(toSlotData.amount)

            toSlotItem:SetItemID(fromSlotData.itemid)
            toSlotItem:SetAmount(fromSlotData.amount)

            netstream.Start("RUST_MoveItem", fromSlot.id, fromSlot.inv, toSlot.id, toSlot.inv)
        end
    else // ansonsten zum leeren Slot
        local fromSlotData = fromSlotInvData[fromSlot.id]

        fromSlotInvData[fromSlot.id] = false
        toSlotInvData[toSlot.id] = fromSlotData

        fromSlotItem:SetParent(toSlot)

        netstream.Start("RUST_MoveItem", fromSlot.id, fromSlot.inv, toSlot.id, toSlot.inv)
    end
end

function RUST.Split(slot) // Item splitten
    local invData = RUST.Inventories[slot.inv].slots

    local freeSlotID = RUST.FreeSlotAvailable(slot.inv) // freien Slot abfragen
    local slotItem = slot:GetChildren()[1]

    if( freeSlotID && slotItem && invData[slot.id].amount > 1 )then // wenn amount größer als 1
        local freeSlot = slot:GetParent():GetChildren()[freeSlotID]
        local amount = math.Round(invData[slot.id].amount / 2)

        invData[freeSlot.id] = {
            itemid = invData[slot.id].itemid,
            amount = amount
        }

        invData[slot.id].amount = invData[slot.id].amount - amount
        slotItem.amount = invData[slot.id].amount

        netstream.Start("RUST_Split", slot.inv, freeSlotID, slot.id)

        local Item = vgui.Create("RUST_Item", freeSlot)
        Item:SetItemID(invData[freeSlot.id].itemid)
        Item:SetAmount(invData[freeSlot.id].amount)
    else
        print("NO SPACE")
    end
end

function RUST.DropItem(slot) // Item droppen
    local invData = RUST.Inventories[slot.inv].slots
    local slotItem = slot:GetChildren()[1]

    if( slotItem && invData[slot.id] )then
        slotItem:Remove()
        invData[slot.id] = false

        netstream.Start("RUST_Drop", slot.inv, slot.id)
    end
end