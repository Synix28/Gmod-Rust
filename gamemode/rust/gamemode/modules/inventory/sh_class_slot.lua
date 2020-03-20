//--------------------------------------------------------------------------------------------------
// Class - Slot
//--------------------------------------------------------------------------------------------------

Slot = {}
Slot.__index = Slot

function Slot:new(inventory, id, item)
	return setmetatable({
        id = id,
        inventory = inventory,
        item = item
	}, Slot)
end

//--------------------------------------------------------------------------------------------------
// Class - Getter & Setter
//--------------------------------------------------------------------------------------------------

function Slot:GetItem()
    return self.item
end

function Slot:GetID()
    return self.id
end

function Slot:GetInventory()
    return self.inventory
end

function Slot:SetItem(item)
    self.item = item
end

function Slot:SetInventory(inventory)
    self.inventory = self.inventory
end

//--------------------------------------------------------------------------------------------------
// Class - Utility
//--------------------------------------------------------------------------------------------------

function Slot:HasItem()
    return self:GetItem() != nil
end

setmetatable(Slot, { __call = Slot.new })