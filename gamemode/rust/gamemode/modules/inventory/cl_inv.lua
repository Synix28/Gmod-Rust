--[[

    Inventory - CL

]]--

function GM:ScoreboardShow()
end

// ------------------------------------------------------------------

netstream.Hook("RUST_OpenInventory", function()
    if( !RUST.VGUI.BasePanel )then // Wenn nicht offen, dann ... ( nicht ändern! )
        RUST.VGUI.BasePanel = vgui.Create("RUST_Base")
        RUST.VGUI.BasePanel:OpenArmor()
        RUST.VGUI.BasePanel:OpenCrafting()
    end
end)

netstream.Hook("RUST_CloseInventory", function()
    if( IsValid(RUST.VGUI.BasePanel) )then // Wenn nicht offen, dann ...
        RUST.VGUI.BasePanel:Remove()
        RUST.VGUI.BasePanel = nil
    end
end)

netstream.Hook("RUST_SyncInventory", function(inv, data) // Volle Synchronisation eines Inventars.
    RUST.Inventories[inv] = data
end)

netstream.Hook("RUST_CreateHotbar", function() // Hotbar erstellen.
    RUST.VGUI.Hotbar = vgui.Create("RUST_Hotbar")
end)

netstream.Hook("RUST_UpdateSlot", function(inv, slot, itemid, amount, itemData) // Inventar Slot updaten + im Inventar adden, wenn offen.
    local invData = RUST.Inventories[inv].slots
    local ply = LocalPlayer()

    if( invData[slot] )then // Wenn Slot bereits vewendet, dann
        invData[slot].amount = amount // amount setzen

        if( itemData )then
            invData[slot].itemData = itemData
        end

        if( invData[slot].amount == 0 )then
            invData[slot] = false
        end

        // TODO: OPTIMIZE AND MINIMIZE
        // TODO: FURNACE HIER ADDEN

        if( IsValid(RUST.VGUI.BasePanel) && inv != ply:GetHotbarInv() )then
            if( IsValid(RUST.VGUI.BasePanel.loot) && inv != ply:GetInv() )then
                if( !invData[slot] )then
                    RUST.VGUI.BasePanel.loot.list:GetChildren()[slot]:GetChildren()[1]:Remove()
                else
                    RUST.VGUI.BasePanel.loot.list:GetChildren()[slot]:GetChildren()[1]:SetAmount(invData[slot].amount)
                end
            elseif( IsValid(RUST.VGUI.BasePanel.campfire) && inv != ply:GetInv() )then
                if( !invData[slot] )then
                    if( slot >= 1 && slot <= 6 )then
                        RUST.VGUI.BasePanel.campfire.inventory.list:GetChildren()[slot]:GetChildren()[1]:Remove()
                    elseif( slot == 7 )then
                        RUST.VGUI.BasePanel.campfire.fireSlot:GetChildren()[1]:Remove()
                    elseif( slot == 8 )then
                        RUST.VGUI.BasePanel.campfire.coalSlot:GetChildren()[1]:Remove()
                    end
                else
                    if( slot >= 1 && slot <= 6 )then
                        RUST.VGUI.BasePanel.campfire.list:GetChildren()[slot]:GetChildren()[1]:SetAmount(invData[slot].amount)
                    elseif( slot == 7 )then
                        RUST.VGUI.BasePanel.campfire.fireSlot:GetChildren()[1]:SetAmount(invData[slot].amount)
                    elseif( slot == 8 )then
                        RUST.VGUI.BasePanel.campfire.coalSlot:GetChildren()[1]:SetAmount(invData[slot].amount)
                    end
                end
            elseif( IsValid(RUST.VGUI.BasePanel.inventory) )then
                if( !invData[slot] )then
                    RUST.VGUI.BasePanel.inventory.list:GetChildren()[slot]:GetChildren()[1]:Remove()
                else
                    RUST.VGUI.BasePanel.inventory.list:GetChildren()[slot]:GetChildren()[1]:SetAmount(invData[slot].amount)
                end
            end
        elseif( inv == ply:GetHotbarInv() )then
            if( !invData[slot] )then
                RUST.VGUI.Hotbar.list:GetChildren()[slot]:GetChildren()[1]:Remove()
            else
                RUST.VGUI.Hotbar.list:GetChildren()[slot]:GetChildren()[1]:SetAmount(invData[slot].amount)
            end
        end
    else
        invData[slot] = {}
        invData[slot].itemid = itemid
        invData[slot].amount = amount

        if( itemData )then
            invData[slot].itemData = itemData
        end

        // TODO: OPTIMIZE AND MINIMIZE
        // TODO: FURNACE AUCH HIER ADDEN

        if( IsValid(RUST.VGUI.BasePanel) && inv != ply:GetHotbarInv() )then
            if( IsValid(RUST.VGUI.BasePanel.campfire) && inv != ply:GetInv() )then
                if( slot >= 1 && slot <= 6 )then
                    local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.campfire.list:GetChildren()[slot])
                    Item:SetItemID(invData[slot].itemid)
                    Item:SetAmount(invData[slot].amount)
                elseif( slot == 7 )then
                    local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.campfire.fireSlot)
                    Item:SetItemID(invData[slot].itemid)
                    Item:SetAmount(invData[slot].amount)
                elseif( slot == 8 )then
                    local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.campfire.coalSlot)
                    Item:SetItemID(invData[slot].itemid)
                    Item:SetAmount(invData[slot].amount)
                end
            elseif( IsValid(RUST.VGUI.BasePanel.loot) && inv != ply:GetInv() )then
                local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.loot.list:GetChildren()[slot])
                Item:SetItemID(invData[slot].itemid)
                Item:SetAmount(invData[slot].amount)
            elseif( IsValid(RUST.VGUI.BasePanel.inventory) )then
                local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.inventory.list:GetChildren()[slot])
                Item:SetItemID(invData[slot].itemid)
                Item:SetAmount(invData[slot].amount)
            end
        elseif( inv == ply:GetHotbarInv() )then
            local Item = vgui.Create("RUST_Item", RUST.VGUI.Hotbar.list:GetChildren()[slot])
            Item:SetItemID(invData[slot].itemid)
            Item:SetAmount(invData[slot].amount)
        end
    end
end)

netstream.Hook("RUST_UpdateSlotItemData", function(inv, slot, itemData)
    local invData = RUST.Inventories[inv].slots

    if( invData[slot] )then
        invData[slot].itemData = itemData
    end
end)

// ------------------------------------------------------------------

netstream.Hook("RUST_OpenLoot", function(inv)
    if( !RUST.VGUI.BasePanel || !IsValid(RUST.VGUI.BasePanel) )then
        RUST.VGUI.BasePanel = vgui.Create("RUST_Base")
        RUST.VGUI.BasePanel:OpenArmor()
        RUST.VGUI.BasePanel:OpenLoot(inv)
    else
        RUST.VGUI.BasePanel:OpenLoot(inv)
    end
end)

netstream.Hook("RUST_OpenCampfire", function(inv)
    local selection = vgui.Create("RUST_Interaction_Campfire")
    selection:SetInv(inv)
end)

// ------------------------------------------------------------------

local types = {
    RUST_ARMOR_TYPE_HEAD,
    RUST_ARMOR_TYPE_CHEST,
    RUST_ARMOR_TYPE_LEGS,
    RUST_ARMOR_TYPE_FEET
}

function RUST.MoveItem(fromSlot, toSlot) // Item im Inventar moven, von Inventar zu Inventar moven, Items tauschen
    local ply = LocalPlayer()

    local toSlotItem = toSlot:GetChildren()[1]
    local fromSlotItem = fromSlot:GetChildren()[1]

    if( !RUST.Inventories[fromSlot.inv] || !RUST.Inventories[toSlot.inv] )then return end

    local fromSlotInvData = RUST.Inventories[fromSlot.inv].slots
    local toSlotInvData = RUST.Inventories[toSlot.inv].slots

    if( fromSlot.inv == toSlot.inv && fromSlot.id == toSlot.id )then
        return
    end
    
    if( !hook.Run("CanMoveItem", ply, fromSlot.id, fromSlot.inv, fromSlotInvData, toSlot.id, toSlot.inv, toSlotInvData) ) then return end

    // check for armor inv

    local armorInv = ply:GetArmorInv()

    if( toSlot.inv == armorInv )then
        local itemData = RUST.Items[fromSlotInvData[fromSlot.id].itemid]

        if( !itemData.isArmor || itemData.type != types[toSlot.id] )then
            return
        end

        ply:EmitSound("item/sfx/zipper.wav", 75)
    elseif( fromSlot.inv == armorInv && toSlotInvData[toSlot.id] )then
        local itemData = RUST.Items[toSlotInvData[toSlot.id].itemid]

        if( !itemData.isArmor || itemData.type != types[fromSlot.id] )then
            return
        end

        ply:EmitSound("item/sfx/zipper.wav", 75)
    end

    // check hotbar

    local hotbarInv = ply:GetHotbarInv()

    if( fromSlot.inv == hotbarInv && fromSlot.id == ply.CurrentSelectedSlot )then
        local fromSlotItemData = RUST.Items[fromSlotInvData[fromSlot.id].itemid]

        if( toSlotItem )then
            local toSlotItemData = RUST.Items[toSlotInvData[toSlot.id].itemid]

            if( fromSlotItemData.isWeapon && ply.CantSwitchSlot )then
                return
            end

            if( !toSlotItemData.isWeapon && !toSlotItemData.isMelee )then
                ply.CurrentSelectedSlot = nil
            end
        else
            if( fromSlotItemData.isWeapon && ply.CantSwitchSlot )then
                return
            end

            ply.CurrentSelectedSlot = nil
        end
    end

    if( toSlot.inv == hotbarInv && toSlot.id == ply.CurrentSelectedSlot )then
        local fromSlotItemData = RUST.Items[fromSlotInvData[fromSlot.id].itemid]

        if( fromSlotItemData.isWeapon && ply.CantSwitchSlot || toSlotItem && RUST.Items[toSlotInvData[toSlot.id].itemid].isWeapon && ply.CantSwitchSlot )then
            return
        end

        if( !fromSlotItemData.isWeapon && !fromSlotItemData.isMelee )then
            ply.CurrentSelectedSlot = nil
        end
    end

    // do move stuff

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

    local freeSlotID = RUST.FreeSlot(slot.inv) // freien Slot abfragen
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
    local ply = LocalPlayer()

    if( slotItem && invData[slot.id] )then
        slotItem:Remove()
        invData[slot.id] = false

        local hotbarInv = ply:GetHotbarInv()

        if( slot.inv == hotbarInv && slot.id == ply.CurrentSelectedSlot )then
            ply.CurrentSelectedSlot = nil
        end

        netstream.Start("RUST_Drop", slot.inv, slot.id)
    end
end

function RUST.Eat(slot)
    if( !RUST.EatCoolDown || RUST.EatCoolDown > CurTime() )then return end

    local invData = RUST.Inventories[slot.inv].slots
    local slotItem = slot:GetChildren()[1]
    local ply = LocalPlayer()

    if( ( invData[slot.id].amount - 1 ) == 0 )then
        slotItem:Remove()
        invData[slot] = false
    else
        invData[slot.id].amount = invData[slot.id].amount - 1
        slotItem:SetAmount(invData[slot.id].amount)
    end

    ply:EmitSound("item/sfx/eating.wav", 75)

    RUST.EatCoolDown = false

    netstream.Start("RUST_Eat", slot.inv, slot.id)
end

function RUST.Unload(slot)
    local invData = RUST.Inventories[slot.inv].slots
    local ply = LocalPlayer()

    if( !ply.CantSwitchSlot && invData[slot.id].itemData && invData[slot.id].itemData.clip && invData[slot.id].itemData.clip > 0 )then
        netstream.Start("RUST_Unload", slot.inv, slot.id)
    end
end