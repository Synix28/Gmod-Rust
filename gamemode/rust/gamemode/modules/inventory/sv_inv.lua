--[[

    Inventory - SV

]]--

hook.Add("DatabaseInitialized", "RUST_Inventory_SetupDB", function() // Tables erstellen
    MySQLite.query("CREATE TABLE IF NOT EXISTS player_inventory ( steamid varchar(255) NOT NULL, slot int NOT NULL, amount int NOT NULL, itemid varchar(255) NOT NULL, itemdata longtext, CONSTRAINT iid PRIMARY KEY (slot, steamid) )")
    MySQLite.query("CREATE TABLE IF NOT EXISTS player_hotbar ( steamid varchar(255) NOT NULL, slot int NOT NULL, amount int NOT NULL, itemid varchar(255) NOT NULL, itemdata longtext, CONSTRAINT hid PRIMARY KEY (slot, steamid) )")
end)

hook.Add("PlayerButtonDown", "RUST_OpenInventory", function(ply, key) // Inventar öffnen
    if( key == KEY_TAB && ply:Alive() ) then
        netstream.Start(ply, "RUST_OpenInventory")
    end
end)

hook.Add("PlayerInitialSpawn", "RUST_SetupInventory", function(ply) // Inventare erstellen, Daten abfragen und den Player updaten
    local steamid = ply:SteamID()

    RUST.Inventories["Player_Inv_" .. steamid] = {}
    RUST.Inventories["Player_Hotbar_" .. steamid] = {}
    RUST.Inventories["Player_Armor_" .. steamid] = {}

    RUST.Inventories["Player_Inv_" .. steamid].slots = {}
    RUST.Inventories["Player_Hotbar_" .. steamid].slots = {}
    RUST.Inventories["Player_Armor_" .. steamid].slots = {}

    local inventory = RUST.Inventories["Player_Inv_" .. steamid].slots
    local hotbar = RUST.Inventories["Player_Hotbar_" .. steamid].slots

    RUST.Inventories["Player_Inv_" .. steamid].owner = ply
    RUST.Inventories["Player_Hotbar_" .. steamid].owner = ply
    RUST.Inventories["Player_Armor_" .. steamid].owner = ply

    // ------------

    MySQLite.begin()

    MySQLite.queueQuery("SELECT itemid, amount, slot FROM player_inventory WHERE steamid = '" .. ply:SteamID() .. "' ORDER BY slot ", function(data)
        data = data || {}

        for i = 1, 30 do
            inventory[i] = false
        end

        for _, item in ipairs(data) do
            inventory[item.slot] = {
                itemid = item.itemid,
                amount = item.amount
            }
        end
    end)

    MySQLite.queueQuery("SELECT itemid, amount, slot FROM player_hotbar WHERE steamid = '" .. ply:SteamID() .. "' ORDER BY slot ", function(data)
        data = data || {}

        for i = 1, 6 do
            hotbar[i] = false
        end

        for _, item in ipairs(data) do
            hotbar[item.slot] = {
                itemid = item.itemid,
                amount = item.amount
            }
        end
    end)

    MySQLite.commit(function()
        timer.Simple(2, function()
            if( !ply || !IsValid(ply) ) then return end

            local armorInv = "Player_Armor_" .. ply:SteamID()

            for i = 1, 4 do
                RUST.Inventories[armorInv].slots[i] = false
            end

            netstream.Start(ply, "RUST_SyncInventory", "Player_Inv_" .. ply:SteamID(), RUST.Inventories["Player_Inv_" .. ply:SteamID()])
            netstream.Start(ply, "RUST_SyncInventory", "Player_Hotbar_" .. ply:SteamID(), RUST.Inventories["Player_Hotbar_" .. ply:SteamID()])
            netstream.Start(ply, "RUST_SyncInventory", "Player_Armor_" .. ply:SteamID(), RUST.Inventories["Player_Armor_" .. ply:SteamID()])

            netstream.Start(ply, "RUST_CreateHotbar")
        end)
    end)
end)

// TODO: OPTIMIZE THIS!
local types = { // needed for RUST_MoveItem and PlayerDeath 
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

        // check for armor inv

        local armorInv = ply:GetArmorInv()

        if( toSlotInv == armorInv )then
            local itemData = RUST.Items[fromSlotInvData[fromSlotID].itemid]

            if( !itemData.isArmor || itemData.type != types[toSlotID] )then
                return
            end

            for k, bodygroupData in ipairs(RUST.DefaultBodyGroups[itemData.type]) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end

            for k, bodygroupData in ipairs(itemData.bodygroups) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end
        elseif( fromSlotInv == armorInv && toSlotInvData[toSlotID] )then
            local itemData = RUST.Items[toSlotInvData[toSlotID].itemid]

            if( !itemData.isArmor || itemData.type != types[fromSlotID] )then
                return
            end

            for k, bodygroupData in ipairs(RUST.DefaultBodyGroups[itemData.type]) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end

            for k, bodygroupData in ipairs(itemData.bodygroups) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end
        elseif( fromSlotInv == armorInv && !toSlotInvData[toSlotID] )then
            local itemData = RUST.Items[fromSlotInvData[fromSlotID].itemid]

            for k, bodygroupData in ipairs(RUST.DefaultBodyGroups[itemData.type]) do
                ply:SetBodygroup(bodygroupData[1], bodygroupData[2])
            end
        end

        // check hotbar

        local hotbarInv = ply:GetHotbarInv()

        if( fromSlotInv == hotbarInv && fromSlotID == ply.CurrentSelectedSlot )then
            local fromSlotItemData = RUST.Items[fromSlotInvData[fromSlotID].itemid]

            if( toSlotInvData[toSlotID] )then
                local toSlotItemData = RUST.Items[toSlotInvData[toSlotID].itemid]

                if( fromSlotItemData.isWeapon && ply.CantSwitchSlot )then
                    return
                end

                if( toSlotItemData.isWeapon || toSlotItemData.isMelee )then
                    ply:StripWeapons()
                    ply:Give(toSlotItemData.ent, true)

                    if( toSlotItemData.isWeapon )then
                        ply:GetActiveWeapon():SetClip1(toSlotInvData[toSlotID].itemData.clip)
                    end
                else
                    ply:StripWeapons()
                    ply.CurrentSelectedSlot = nil
                end
            else
                if( fromSlotItemData.isWeapon && ply.CantSwitchSlot )then
                    return
                end

                ply:StripWeapons()
                ply.CurrentSelectedSlot = nil
            end
        end

        if( toSlotInv == hotbarInv && toSlotID == ply.CurrentSelectedSlot )then
            local fromSlotItemData = RUST.Items[fromSlotInvData[fromSlotID].itemid]

            if( fromSlotItemData.isWeapon && ply.CantSwitchSlot || toSlotInvData[toSlotID] && RUST.Items[toSlotInvData[toSlotID].itemid].isWeapon && ply.CantSwitchSlot )then
                return
            end

            if( fromSlotItemData.isWeapon || fromSlotItemData.isMelee )then
                ply:StripWeapons()
                ply:Give(fromSlotItemData.ent, true)

                if( fromSlotItemData.isWeapon )then
                    ply:GetActiveWeapon():SetClip1(fromSlotInvData[fromSlotID].itemData.clip)
                end
            else
                print("ff")

                ply:StripWeapons()
                ply.CurrentSelectedSlot = nil
            end
        end

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
        local ent = ents.Create("rust_item")
        ent:SetPos( ply:EyePos() + ply:GetAimVector() * 50 )
            ent:SetItemID(invData[slot].itemid)
            ent:SetAmount(invData[slot].amount)

            if( invData[slot].itemData )then
                ent:SetItemData(invData[slot].itemData)
            end

        ent:Spawn()

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

//TODO: ADD HOOK TO CHECK IF PLY IS LOOTING AND HAS RIGHT TO MOVE STUFF IN IT!

netstream.Hook("RUST_LootClosed", function(ply)
    hook.Run("RUST_LootClosed", ply)
end)

netstream.Hook("RUST_LightFire", function(ply, ent)
    if( ent.IsCampfire && ply:GetPos():Distance(ent:GetPos()) < 300 )then
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

// ------------------------------------------------------------------
