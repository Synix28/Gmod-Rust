//--------------------------------------------------------------------------------------------------
// Class - Inventory
//--------------------------------------------------------------------------------------------------

Inventory = {}
Inventory.__index = Inventory

function Inventory:new(invid, owner)
    local inventory = {
        invid = invid,
        owner = owner,
        slots = {}
    }

	return setmetatable(inventory, Inventory)
end

//--------------------------------------------------------------------------------------------------
// Class - Getter & Setter
//--------------------------------------------------------------------------------------------------

function Inventory:GetSlots()
    return self.slots
end

function Inventory:GetSlot(id)
    return self.slots[id]
end

function Inventory:GetOwner()
    return self.owner
end

function Inventory:GetInvID()
    return self.invid
end

function Inventory:SetOwner(owner)
    self.owner = owner
end

function Inventory:AddSlot(id, item)
    table.insert(self.slots, Slot(self, id, item))
end

//--------------------------------------------------------------------------------------------------
// Class - Item Amount
//--------------------------------------------------------------------------------------------------

function Inventory:GetItemAmount(itemid)
    local amount = false

    for _, slot in ipairs(self:GetSlots()) do
        if( slot:HasItem() && slot:GetItem():Equals(itemid) )then
            if( !amount )then amount = 0 end

            amount = amount + slot:GetItem():GetAmount()
        end
    end

    return amount
end

function Inventory:HasSpaceForAmount(itemid, amount)
    // TODO: REWORK RUST.Items with functions
    local max = RUST.Items[itemid].max

    local freeSlots = {}
    local remainingAmount = amount

    for _, slot in ipairs(self:GetSlots()) do
        if( slot:HasItem() && slot:GetItem():Equals(itemid) && slot:GetAmount() < max )then
            remainingAmount = remainingAmount - ( max - slot:GetAmount() )
            table.insert(freeSlots, slot)

            if( remainingAmount <= 0 )then
                return freeSlots
            end
        end
    end

    if( remainingAmount > 0 )then
        local neededSlots = math.ceil(remainingAmount / max)
        local invFreeSlots = self:GetFreeSlots(neededSlots)

        if( #invFreeSlots >= neededSlots )then
            for _, slot in ipairs(invFreeSlots) do
                table.insert(freeSlots, slot)
            end

            return freeSlots
        end
    end

    return false
end

function Inventory:HasSpaceForAmountMinMax(itemid, amount, minSlot, maxSlot)
    local max = RUST.Items[itemid].max

    local freeSlots = {}
    local remainingAmount = amount

    for _, slot in ipairs(self:GetSlots()) do
        if( slot:HasItem() && slot:GetItem():Equals(itemid) && slot:GetAmount() < max && slot:GetID() >= minSlot && slot <= slot:GetID() )then
            remainingAmount = remainingAmount - ( max - slot:GetAmount() )
            table.insert(freeSlots, slot)

            if( remainingAmount <= 0 )then
                return freeSlots
            end
        end
    end

    if( remainingAmount > 0 )then
        local neededSlots = math.ceil(remainingAmount / max)
        local invFreeSlots = self:GetFreeSlotsMinMax(neededSlots, minSlot, maxSlot)

        if( #invFreeSlots >= neededSlots )then
            for _, slot in ipairs(invFreeSlots) do
                table.insert(freeSlots, slot)
            end

            return freeSlots
        end
    end

    return false
end

//--------------------------------------------------------------------------------------------------
// Class - Free Slot/s
//--------------------------------------------------------------------------------------------------

function Inventory:GetFreeSlot()
    for _, slot in ipairs(self:GetSlots()) do
        if( !slot:HasItem() )then
            return slot
        end
    end

    return false
end

function Inventory:GetFreeSlots(amount)
    local freeSlots = {}

    if( amount )then
        for _, slot in ipairs(self:GetSlots()) do
            if( !slot:HasItem() )then
                table.insert(freeSlots, slot)
                amount = amount - 1

                if( amount <= 0 )then
                    return freeSlots
                end
            end
        end
    else
        for _, slot in ipairs(self:GetSlots()) do
            if( !slot:HasItem() )then
                table.insert(freeSlots, slot)
            end
        end
    end

    return freeSlots
end

function Inventory:GetFreeSlotsMinMax(amount, minSlot, maxSlot)
    local freeSlots = {}

    if( amount )then
        for _, slot in ipairs(self:GetSlots()) do
            if( !slot:HasItem() && slot:GetID() >= minSlot && slot:GetID() <= maxSlot )then
                table.insert(freeSlots, slot)
                amount = amount - 1

                if( amount <= 0 )then
                    return freeSlots
                end
            end
        end
    else
        for _, slot in ipairs(self:GetSlots()) do
            if( !slot:HasItem() && slot:GetID() >= minSlot && slot:GetID() <= maxSlot )then
                table.insert(freeSlots, slot)
            end
        end
    end

    return freeSlots
end

//--------------------------------------------------------------------------------------------------
// Class - Remove Amount
//--------------------------------------------------------------------------------------------------

if( SERVER )then
    function Inventory:RemoveItemAmount(itemid, amount, ply)
        local availableAmount = self:GetItemAmount(itemid)

        if( availableAmount && availableAmount >= amount )then
            for _, slot in ipairs(self:GetSlots()) do
                if( slot:HasItem() && slot:GetItem():Equals(itemid) )then
                    local item = slot:GetItem()

                    if( item:GetAmount() <= amount )then
                        local amountToRemove = item:GetAmount()

                        slot:SetItem(nil)
                        amount = amount - amountToRemove
                    else
                        item:SetAmount(item:GetAmount() - amount)
                        amount = 0
                    end

                    if( self:GetOwner():IsPlayer() )then
                        self:SyncSlot(self:GetOwner(), slot)
                    end

                    if( ply && ply:IsPlayer() )then
                        self:SyncSlot(ply, slot)
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

    function Inventory:RemoveItemAmountFromSlot(slot, amount, ply)
        local slot = self:GetSlots()[slot]

        if( slot:HasItem() && slot:GetItem():GetAmount() >= amount )then
            local item = slot:GetItem()

            item:SetAmount(item:GetAmount() - amount)

            if( item:GetAmount() <= 0 )then
                slot:SetItem(nil)
            end

            if( self:GetOwner():IsPlayer() )then
                self:SyncSlot(self:GetOwner(), slot)
            end

            if( ply && ply:IsPlayer() )then
                self:SyncSlot(ply, slot)
            end

            return true
        end

        return false
    end
end

//--------------------------------------------------------------------------------------------------
// Class - Add Amount
//--------------------------------------------------------------------------------------------------

if( SERVER )then
    function Inventory:AddItem(itemid, amount, itemData, ply)
        local freeSlots = self:HasSpaceForAmount(itemid, amount)

        local max = RUST.Items[itemid].max

        if( freeSlots )then
            local remainingAmount = amount

            for _, slot in ipairs(freeSlots) do
                if( slot:HasItem() && slot:GetItem():GetAmount() < max )then
                    local item = slot:GetItem()
                    local freeAmount = max - item:GetAmount()

                    if( freeAmount <= remainingAmount )then
                        item:SetAmount(max)
                        remainingAmount = remainingAmount - freeAmount
                    elseif( freeAmount > remainingAmount )then
                        item:SetAmount(item:GetAmount() + remainingAmount)
                        remainingAmount = 0
                    end

                    if( itemData )then
                        item:SetItemData(itemData)
                    end

                    if( self:GetOwner():IsPlayer() )then
                        self:SyncSlot(self:GetOwner(), slot)
                    end

                    if( ply && ply:IsPlayer() )then
                        self:SyncSlot(ply, slot)
                    end
                elseif( !slot:HasItem() )then
                    local item = Item(slot, itemid, 0)
                    slot:SetItem(item)

                    if( remainingAmount >= max )then
                        item:SetAmount(max)
                        remainingAmount = remainingAmount - max
                    else
                        item:SetAmount(remainingAmount)
                        remainingAmount = 0
                    end

                    if( itemData )then
                        item:SetItemData(itemData)
                    end

                    if( self:GetOwner():IsPlayer() )then
                        self:SyncSlot(self:GetOwner(), slot)
                    end

                    if( ply && ply:IsPlayer() )then
                        self:SyncSlot(ply, slot)
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

    function Inventory:AddItemMinMax(itemid, amount, itemData, min, max, ply)
        local freeSlots = self:HasSpaceForAmountMinMax(itemid, amount, min, max)

        local max = RUST.Items[itemid].max

        if( freeSlots )then
            local remainingAmount = amount

            for _, slot in ipairs(freeSlots) do
                if( slot:HasItem() && slot:GetItem():GetAmount() < max )then
                    local item = slot:GetItem()
                    local freeAmount = max - item:GetAmount()

                    if( freeAmount <= remainingAmount )then
                        item:SetAmount(max)
                        remainingAmount = remainingAmount - freeAmount
                    elseif( freeAmount > remainingAmount )then
                        item:SetAmount(item:GetAmount() + remainingAmount)
                        remainingAmount = 0
                    end

                    if( itemData )then
                        item:SetItemData(itemData)
                    end

                    if( self:GetOwner():IsPlayer() )then
                        self:SyncSlot(self:GetOwner(), slot)
                    end

                    if( ply && ply:IsPlayer() )then
                        self:SyncSlot(ply, slot)
                    end
                elseif( !slot:HasItem() )then
                    local item = Item(slot, itemid, 0)
                    slot:SetItem(item)

                    if( remainingAmount >= max )then
                        item:SetAmount(max)
                        remainingAmount = remainingAmount - max
                    else
                        item:SetAmount(remainingAmount)
                        remainingAmount = 0
                    end

                    if( itemData )then
                        item:SetItemData(itemData)
                    end

                    if( self:GetOwner():IsPlayer() )then
                        self:SyncSlot(self:GetOwner(), slot)
                    end

                    if( ply && ply:IsPlayer() )then
                        self:SyncSlot(ply, slot)
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
end

//--------------------------------------------------------------------------------------------------
// Class - Sync Data
//--------------------------------------------------------------------------------------------------

if( SERVER )then
    function Inventory:Sync(ply)
        local slots = {}

        for id, slot in ipairs(self:GetSlots()) do
            if( !slot:HasItem() )then slots[id] = false continue end

            slots[id] = {
                itemid = slot:GetItemID(),
                amount = slot:GetAmount(),
                itemData = slot:GetItemData()
            }
        end

        netstream.Start(ply, "RUST_Sync_Inventory", self:GetInvID(), self:GetOwner(), slots)
    end

    function Inventory:SyncSlot(ply, slot)

        if( !slot:HasItem() )then
            netstream.Start(ply, "RUST_Update_Slot_Remove", self:GetInvID(), slot:GetID())
        else
            local item = slot:GetItem()

            netstream.Start(ply, "RUST_Update_Slot", self:GetInvID(), slot:GetID(), item:GetItemID(), item:GetAmount(), item:GetItemData())
        end
    end
end

setmetatable(Inventory, { __call = Inventory.new })

//--------------------------------------------------------------------------------------------------
// Class - Base Functions
//--------------------------------------------------------------------------------------------------

function RUST.CreateInventory(invid, owner, slots)
    local inventory = Inventory(invid, owner)

    for i = 1, slots do
        inventory:AddSlot(i)
    end

    RUST.Inventories[invid] = inventory

    if( SERVER && owner:IsPlayer() )then
        inventory:Sync(owner)
    end

    return inventory
end

function RUST.RemoveInventoryByID(invid, ply)
    RUST.Inventories[invid] = nil

    if( SERVER && ply )then

    end
end

function RUST.GetInventoryByID(invid)
    return RUST.Inventories[invid]
end

//--------------------------------------------------------------------------------------------------
// Class - Hooks
//--------------------------------------------------------------------------------------------------

if( CLIENT )then
    netstream.Hook("RUST_Sync_Inventory", function(invid, owner, slots)
        local inv = RUST.CreateInventory(invid, owner, #slots)

        if( !inv )then return end

        for id, slot in ipairs(inv:GetSlots()) do
            if( !slots[id] )then continue end

            slot:SetItem(Item(slot, slots[id].itemid, slots[id].amount, slots[id].itemData))
        end
    end)

    netstream.Hook("RUST_Update_Slot_Remove", function(invid, slotid)
        local inv = RUST.GetInventoryByID(invid)

        if( !inv )then return end

        inv:GetSlot(slotid):SetItem(nil)
    end)

    netstream.Hook("RUST_Update_Slot", function(invid, slotid, itemid, amount, itemData)
        local inv = RUST.GetInventoryByID(invid)

        if( !inv )then return end

        local item = inv:GetSlot(slotid):GetItem()

        if( item )then
            item:SetItemID(itemid)
            item:SetAmount(amount)
            item:SetItemData(itemData)
        else
            item = Item(inv:GetSlot(slotid), itemid, amount, itemData)
            inv:GetSlot(slotid):SetItem(item)
        end
    end)

    netstream.Hook("RUST_Remove_Inventory", function(invid)
        RUST.RemoveInventoryByID(invid)
    end)
end

//--------------------------------------------------------------------------------------------------
// Class - Unit Test
//--------------------------------------------------------------------------------------------------

if( SERVER )then
    concommand.Add("doInventoryTests", function()
        print("Starting Tests...\n")

        local creatsInvsTest, msg = testCreateInventories()

        if(creatsInvsTest)then
            print("Create Inventories: Worked")    
        else
            print("Create Inventories: Failed\nError: \n\n" .. msg)
        end
    end)

    function testCreateInventories()
        local inv1 = RUST.CreateInventory("test1", player.GetByID(1), 20)
        local inv2 = RUST.CreateInventory("test2", player.GetByID(1), 20)

        local worked = true
        local msg = ""

        local value = #inv1:GetSlots()
        local shouldEqual = 20

        if( value != shouldEqual )then
            worked = false
            msg = msg .. "Nicht alle Slots wurden erstellt: " .. value .. " sind es, aber " .. shouldEqual .. " sollten es aber sein \n"
        end

        value = #inv2:GetSlots()
        shouldEqual = 20

        if( value != shouldEqual )then
            worked = false
            msg = msg .. "Nicht alle Slots wurden erstellt: " .. value .. " sind es, aber " .. shouldEqual .. " sollten es aber sein \n"
        end

        value = inv1:GetOwner()
        shouldEqual = player.GetByID(1)

        if( value != shouldEqual )then
            worked = false
            msg = msg .. "Owner nicht gleich" .. value .. " sind es, aber " .. shouldEqual .. " sollten es aber sein \n"
        end

        value = inv2:GetOwner()
        shouldEqual = player.GetByID(1)

        if( value != shouldEqual )then
            worked = false
            msg = msg .. "Owner nicht gleich" .. value .. " sind es, aber " .. shouldEqual .. " sollten es aber sein \n"
        end

        return worked, msg
    end
end

if( CLIENT )then
    concommand.Add("checkInv", function()
        local inv = RUST.GetInventoryByID(LocalPlayer():GetInv())

        for id, slot in ipairs(inv:GetSlots()) do
            if( slot:HasItem() )then
                PrintTable(slot:GetItem())
            end
        end
    end)
end