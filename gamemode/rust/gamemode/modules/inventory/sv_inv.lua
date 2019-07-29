--[[

    Inventory - SV

]]--

hook.Add("PlayerButtonDown", "RUST_OpenInventory", function(ply, key) // Inventar öffnen
    if( key == KEY_TAB ) then
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

    inventory.owner = ply // Owner setzen
    hotbar.owner = ply
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

// ------------------------------------------------------------------

hook.Add("DatabaseInitialized", "RUST_Inventory_SetupDB", function() // Tables erstellen
    MySQLite.query("CREATE TABLE IF NOT EXISTS player_inventory ( steamid varchar(255) NOT NULL, slot int NOT NULL, amount int, itemid varchar(255), CONSTRAINT iid PRIMARY KEY (slot, steamid) )")
    MySQLite.query("CREATE TABLE IF NOT EXISTS player_hotbar ( steamid varchar(255) NOT NULL, slot int NOT NULL, amount int, itemid varchar(255), CONSTRAINT hid PRIMARY KEY (slot, steamid) )")
end)

// ------------------------------------------------------------------

netstream.Hook("RUST_MoveItem", function(ply, fromSlotID, fromSlotInv, toSlotID, toSlotInv) // Item bewegen SV
    if( !RUST.Inventories[fromSlotInv] || !RUST.Inventories[toSlotInv] )then return end
    
    local fromSlotOwner = RUST.Inventories[fromSlotInv].owner
    local toSlotOwner = RUST.Inventories[toSlotInv].owner

    if( // CHECK OWNERSHIP OF THE INVS
       // fromSlotOwner && fromSlotOwner:IsPlayer() && fromSlotOwner == ply && toSlotOwner == ply 
       // || fromSlotOwner && toSlotOwner && !fromSlotOwner:IsPlayer() && toSlotOwner == ply
       // || toSlotOwner && fromSlotOwner && !toSlotOwner:IsPlayer() && fromSlotOwner == ply

       true
    )then
        local fromSlotInvData = RUST.Inventories[fromSlotInv].slots
        local toSlotInvData = RUST.Inventories[toSlotInv].slots

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
        local ent = ents.Create("item")
        ent:SetPos( ply:EyePos() + ply:GetAimVector() * 50 )
            ent:SetItemID(invData[slot].itemid)
            ent:SetAmount(invData[slot].amount)
        ent:Spawn()

        invData[slot] = false
    end

    print("-------------------------------------------------------------")
    PrintTable(RUST.Inventories[inv])
    print("-------------------------------------------------------------")
end)

// ------------------------------------------------------------------
