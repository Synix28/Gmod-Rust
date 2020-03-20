//--------------------------------------------------------------------------------------------------
// Class - Item
//--------------------------------------------------------------------------------------------------

Item = {}
Item.__index = Item

function Item:new(slot, itemid, amount, itemData)
	return setmetatable({
        slot = slot,
		itemid = itemid,
        amount = amount,
        itemData = itemData || {},
	}, Item)
end

//--------------------------------------------------------------------------------------------------
// Class - Getter & Setter
//--------------------------------------------------------------------------------------------------

function Item:GetItemID()
    return self.itemid
end

function Item:GetAmount()
    return self.amount
end

function Item:GetItemData()
    return self.itemData
end

function Item:GetSlot()
    return self.slot
end

function Item:SetItemID(itemid)
    self.itemid = itemid
end

function Item:SetAmount(amount)
    self.amount = amount
end

function Item:SetItemData(itemData)
    self.itemData = itemData
end

function Item:SetSlot(slot)
    self.slot = slot
end

function Item:GetInventory()
    return self:GetSlot():GetInventory()
end

//--------------------------------------------------------------------------------------------------
// Class - Comparsion
//--------------------------------------------------------------------------------------------------

function Item:Equals(itemid)
    return self:GetItemID() == itemid
end

setmetatable(Item, { __call = Item.new })



