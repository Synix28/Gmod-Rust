--[[

    Inventory - SV

]]--

hook.Add("DatabaseInitialized", "RUST_Inventory_SetupDB", function() // Tables erstellen
    MySQLite.query("CREATE TABLE IF NOT EXISTS player_inventory ( steamid varchar(255) NOT NULL, slot int NOT NULL, amount int NOT NULL, itemid varchar(255) NOT NULL, itemdata longtext, CONSTRAINT iid PRIMARY KEY (slot, steamid) )")
    MySQLite.query("CREATE TABLE IF NOT EXISTS player_hotbar ( steamid varchar(255) NOT NULL, slot int NOT NULL, amount int NOT NULL, itemid varchar(255) NOT NULL, itemdata longtext, CONSTRAINT hid PRIMARY KEY (slot, steamid) )")
end)

hook.Add("PlayerButtonDown", "RUST_OpenInventory", function(ply, key)
    if( key == KEY_TAB && ply:Alive() ) then
        netstream.Start(ply, "RUST_OpenInventory")
    end
end)

hook.Add("PlayerInitialSpawn", "RUST_SetupInventory", function(ply)
    timer.Simple(2, function()
        local mainInv = RUST.CreateInventory(ply:GetInv(), ply, 30)
        local hotbarInv = RUST.CreateInventory(ply:GetHotbarInv(), ply, 6)
        local armorInv = RUST.CreateInventory(ply:GetArmorInv(), ply, 4)

        print(mainInv:AddItem("wood", 100))
    end)
end)

// TODO: OPTIMIZE THIS!
local types = {
    RUST_ARMOR_TYPE_HEAD,
    RUST_ARMOR_TYPE_CHEST,
    RUST_ARMOR_TYPE_LEGS,
    RUST_ARMOR_TYPE_FEET
}

hook.Add("PlayerDeath", "RUST_ResetInventory", function(victim, inflictor, attacker)
    netstream.Start(ply, "RUST_Close_VGUI_Elements")

    local backpack = ents.Create("rust_backpack")
    backpack:SetPos(victim:GetPos())
    backpack:Spawn()
    backpack:FillInventory(victim)
    backpack:CheckInv()

    local invs = {
        victim:GetInv(),
        victim:GetHotbarInv(),
        victim:GetArmorInv()
    }

    for _, inv in ipairs(invs) do
        for k, v in ipairs(RUST.Inventories[inv].slots) do
            victim:RemoveItemFromSlot(inv, k)
        end
    end

    for aKey, armorType in ipairs(types) do
        for bKey, bodygroupData in ipairs(RUST.DefaultBodyGroups[armorType]) do
            victim:SetBodygroup(bodygroupData[1], bodygroupData[2])
        end
    end
end)

// ------------------------------------------------------------------

netstream.Hook("RUST_MoveItem", function(ply, fromSlotID, fromSlotInv, toSlotID, toSlotInv) // Item bewegen SV
    if( !RUST.Inventories[fromSlotInv] || !RUST.Inventories[toSlotInv] )then return end

    if( fromSlotInv == toSlotInv && fromSlotID == toSlotID )then
        return
    end

    //local fromSlotOwner = RUST.Inventories[fromSlotInv].owner
    //local toSlotOwner = RUST.Inventories[toSlotInv].owner

    // TODO: CHECK OWNERSHIP OF INVS

    if(
       // fromSlotOwner && fromSlotOwner:IsPlayer() && fromSlotOwner == ply && toSlotOwner == ply 
       // || fromSlotOwner && toSlotOwner && !fromSlotOwner:IsPlayer() && toSlotOwner == ply
       // || toSlotOwner && fromSlotOwner && !toSlotOwner:IsPlayer() && fromSlotOwner == ply

       true
    )then
        local fromSlotInvData = RUST.Inventories[fromSlotInv].slots
        local toSlotInvData = RUST.Inventories[toSlotInv].slots

        if( !hook.Run("CanMoveItem", ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData) ) then return end

        // do move stuff

        if( toSlotInvData[toSlotID] )then
            if( fromSlotInvData[fromSlotID].itemid == toSlotInvData[toSlotID].itemid )then
                local amount = fromSlotInvData[fromSlotID].amount + toSlotInvData[toSlotID].amount
                local max = RUST.Items[toSlotInvData[toSlotID].itemid].max

                if( amount > max )then
                    local fromSlotData = fromSlotInvData[fromSlotID]
                    fromSlotData.amount = max

                    fromSlotInvData[fromSlotID].amount = amount - max
                    toSlotInvData[toSlotID].amount = max
                elseif( amount == max ) then
                    local fromSlotData = fromSlotInvData[fromSlotID]
                    fromSlotData.amount = max

                    fromSlotInvData[fromSlotID] = false
                    toSlotInvData[toSlotID] = fromSlotData
                else
                    local fromSlotData = fromSlotInvData[fromSlotID]
                    fromSlotData.amount = amount

                    fromSlotInvData[fromSlotID] = false
                    toSlotInvData[toSlotID] = fromSlotData
                end
            else
                local fromSlotData = fromSlotInvData[fromSlotID]
                local toSlotData = toSlotInvData[toSlotID]

                fromSlotInvData[fromSlotID] = toSlotData
                toSlotInvData[toSlotID] = fromSlotData
            end
        else
            local fromSlotData = fromSlotInvData[fromSlotID]

            fromSlotInvData[fromSlotID] = false
            toSlotInvData[toSlotID] = fromSlotData
        end
    end
    print("-------------------------------------------------------------")
    PrintTable(RUST.Inventories[fromSlotInv])
    print("_____________________________________________________________")
    PrintTable(RUST.Inventories[toSlotInv])
    print("-------------------------------------------------------------")
end)

netstream.Hook("RUST_Split", function(ply, inv, freeSlotID, slotID) // Item splitten SV
    local invData = RUST.Inventories[inv].slots

    if( freeSlotID && !invData[freeSlotID] && invData[slotID].amount > 1 )then
        local amount = math.Round(invData[slotID].amount / 2)

        invData[freeSlotID] = {
            itemid = invData[slotID].itemid,
            amount = amount
        }

        invData[slotID].amount = invData[slotID].amount - amount
    else
        print("NO SPACE")
    end

    print("-------------------------------------------------------------")
    PrintTable(RUST.Inventories[inv])
    print("-------------------------------------------------------------")
end)

netstream.Hook("RUST_Drop", function(ply, inv, slot) // Item droppen SV
    local invData = RUST.Inventories[inv].slots

    if( invData[slot] )then
        local armorInv = ply:GetArmorInv()

        if( inv == armorInv )then
            local itemData = RUST.Items[invData[slot].itemid]

            for k, bodygroupData in ipairs(RUST.DefaultBodyGroups[itemData.type]) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end
        end

        local hotbarInv = ply:GetHotbarInv()

        if( inv == hotbarInv && slot == ply.CurrentSelectedSlot )then
            ply:StripWeapons()
            ply.CurrentSelectedSlot = nil
        end

        if( !hook.Run("CanDrop", ply, inv, slot) ) then return end

        local ent = ents.Create("rust_item")
        ent:SetPos( ply:EyePos() + ply:GetAimVector() * 50 )
            ent:SetItemID(invData[slot].itemid)
            ent:SetAmount(invData[slot].amount)

            if( invData[slot].itemData )then
                ent:SetItemData(invData[slot].itemData)
            end

        ent:Spawn()

        invData[slot] = false
    end

    print("-------------------------------------------------------------")
    PrintTable(RUST.Inventories[inv])
    print("-------------------------------------------------------------")
end)

netstream.Hook("RUST_Eat", function(ply, inv, slot)
    if( ( ply.EatCoolDown || -1 ) > CurTime() )then netstream.Start(ply, "RUST_UpdateEatCoolDown", ply.EatCoolDown) return end

    local invData = RUST.Inventories[inv].slots

    if( invData[slot] )then
        local itemData = RUST.Items[invData[slot].itemid]

        if( itemData.isFood )then
            if( ( invData[slot].amount - 1 ) == 0 )then
                invData[slot] = false
            else
                invData[slot].amount = invData[slot].amount - 1
            end

            ply:AddFood(itemData.hunger)

            ply.EatCoolDown = CurTime() + 2

            netstream.Start(ply, "RUST_UpdateEatCoolDown", ply.EatCoolDown)
        end
    end
end)

netstream.Hook("RUST_Unload", function(ply, inv, slot)
    local invData = RUST.Inventories[inv].slots

    if( invData[slot] && !ply.CantSwitchSlot )then
        local itemData = RUST.Items[invData[slot].itemid]

        if( itemData.isWeapon && !itemData.isBow && invData[slot].itemData && invData[slot].itemData.clip && invData[slot].itemData.clip > 0 )then
            local clipAmount = invData[slot].itemData.clip
            invData[slot].itemData.clip = 0

            ply:AddItem(ply:GetInv(), itemData.ammo, clipAmount)
            netstream.Start(ply, "RUST_UpdateSlotItemData", inv, slot, invData[slot].itemData)

            if( inv == ply:GetHotbarInv() && ply.CurrentSelectedSlot == slot )then
                ply:GetActiveWeapon():SetClip1(0)
            end
        end
    end
end)

netstream.Hook("RUST_InventoryClosed", function(ply)
    hook.Run("RUST_InventoryClosed", ply)
end)

netstream.Hook("RUST_LootClosed", function(ply)
    hook.Run("RUST_LootClosed", ply)
end)

netstream.Hook("RUST_LightFire", function(ply, ent)
    if( ent.IsLightable && ply:GetPos():Distance(ent:GetPos()) < 300 )then
        ent:LightFire()
    end
end)

// ------------------------------------------------------------------

function RUST.CheckLooting(ply)
    if( ply.Looting && IsValid(ply.Looting) )then
        ply.Looting:SetUsedBy(NULL)
        ply.Looting:CheckInv()

        ply.Looting = nil
    end
end

hook.Add("RUST_InventoryClosed", "RUST_Looting", function(ply)
    RUST.CheckLooting(ply)
end)

hook.Add("RUST_LootClosed", "RUST_Looting", function(ply)
    RUST.CheckLooting(ply)
end)