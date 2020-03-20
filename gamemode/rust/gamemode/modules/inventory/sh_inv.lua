--[[

    Inventory - SH

]]--

RUST.Items = RUST.Items || {}
RUST.Inventories = RUST.Inventories || {}

// ------------------------------------------------------------------

RUST_ARMOR_TYPE_HEAD = 1
RUST_ARMOR_TYPE_CHEST = 2
RUST_ARMOR_TYPE_LEGS = 3
RUST_ARMOR_TYPE_FEET = 4

RUST.DefaultBodyGroups = {
    [RUST_ARMOR_TYPE_HEAD] = {
        {8, 0}
    },
    [RUST_ARMOR_TYPE_CHEST] = {
        {2, 0},
        {6, 0}
    },
    [RUST_ARMOR_TYPE_LEGS] = {
        {3, 0},
        {7, 0}
    },
    [RUST_ARMOR_TYPE_FEET] = {
        {5, 0}
    }
}

// ------------------------------------------------------------------

RUST.Items["wood"] = {
    name = "Wood",
    icon = Material("rust/wood.png"),
    max = 250,
    isResource = true
}

RUST.Items["stones"] = {
    name = "Stones",
    icon = Material("rust/stones_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["animal_fat"] = {
    name = "Animal Fat",
    icon = Material("rust/animal_fat_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["cloth"] = {
    name = "Cloth",
    icon = Material("rust/cloth_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["explosives"] = {
    name = "Explosives",
    icon = Material("rust/explosives_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["gunpowder"] = {
    name = "Gunpowder",
    icon = Material("rust/gunpowder_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["leather"] = {
    name = "Leather",
    icon = Material("rust/leather_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["metal_fragments"] = {
    name = "Metal Fragments",
    icon = Material("rust/metal_fragments_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["metal_ore"] = {
    name = "Metal Ore",
    icon = Material("rust/ore1_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["paper"] = {
    name = "Paper",
    icon = Material("rust/graph_paper_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["sulfur"] = {
    name = "Sulfur",
    icon = Material("rust/sulfur_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["sulfur_ore"] = {
    name = "Sulfur Ore",
    icon = Material("rust/ore2_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["charcoal"] = {
    name = "Charcoal",
    icon = Material("rust/charcoal_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["low_grade_fuel"] = {
    name = "Low Grade Fuel",
    icon = Material("rust/low_grade_fuel_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["low_quality_metal"] = {
    name = "Low Quality Metal",
    icon = Material("rust/low_quality_metal_icon.png"),
    max = 250,
    isResource = true
}

RUST.Items["wood_planks"] = {
    name = "Wood Planks",
    icon = Material("rust/wood_planks_icon.png"),
    max = 250,
    isResource = true
}

------------------------------------------------------------------------------

RUST.Items["bed"] = {
    name = "Bed",
    icon = Material("rust/bed_icon.png"),
    max = 1,
    isPlaceable = true
}

RUST.Items["campfire"] = {
    name = "Campfire",
    icon = Material("rust/campfire_icon.png"),
    max = 1,
    isPlaceable = true
}

RUST.Items["furnace"] = {
    name = "Furnace",
    icon = Material("rust/furnace_icon.png"),
    max = 1,
    isPlaceable = true
}

RUST.Items["sleeping_bag"] = {
    name = "Sleeping Bag",
    icon = Material("rust/sleeping_bag_icon.png"),
    max = 1,
    isPlaceable = true
}

RUST.Items["small_stash"] = {
    name = "Small Stash",
    icon = Material("rust/unknown.png"),
    max = 8,
    isPlaceable = true
}

RUST.Items["wood_storage_box"] = {
    name = "Wood Storage Box",
    icon = Material("rust/wood_storage_box_icon.png"),
    max = 8,
    isPlaceable = true
}

RUST.Items["wood_storage_box_large"] = {
    name = "Wood Storage Box (Large)",
    icon = Material("rust/wood_storage_box_large_icon.png"),
    max = 4,
    isPlaceable = true
}

RUST.Items["wooden_barricade"] = {
    name = "Wooden Barricade",
    icon = Material("rust/wood_barricade_icon.png"),
    max = 1,
    isPlaceable = true
}

RUST.Items["wooden_shelter"] = {
    name = "Wooden Shelter",
    icon = Material("rust/wood_shelter_icon.png"),
    max = 1,
    isPlaceable = true
}

RUST.Items["workbench"] = {
    name = "Workbench",
    icon = Material("rust/workbench_icon.png"),
    max = 1,
    isPlaceable = true
}

// ------------------------------------------------------------------

RUST.Items["wooden_door"] = {
    name = "Wooden Door",
    icon = Material("rust/wooden_door_icon.png"),
    max = 1,
    isDoor = true
}

RUST.Items["metal_door"] = {
    name = "Metal Door",
    icon = Material("rust/metal_door_icon.png"),
    max = 1,
    isDoor = true
}

// ------------------------------------------------------------------

RUST.Items["cloth_helmet"] = {
    name = "Cloth Helmet",
    icon = Material("rust/helmet_1_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_HEAD,
    bodygroups = {
        {8, 1}
    },

    stats = {
        bullet = 10,
        melee = 10,
        explosion = 5,
        cold = 5,
        radiation = 0
    }
}

RUST.Items["cloth_vest"] = {
    name = "Cloth Vest",
    icon = Material("rust/vest_1_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_CHEST,
    bodygroups = {
        {2, 2},
        {6, 2}
    },

    stats = {
        bullet = 10,
        melee = 10,
        explosion = 5,
        cold = 10,
        radiation = 0
    }
}

RUST.Items["cloth_pants"] = {
    name = "Cloth Pants",
    icon = Material("rust/pants_1_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_LEGS,
    bodygroups = {
        {3, 2},
        {7, 2}
    },

    stats = {
        bullet = 5,
        melee = 5,
        explosion = 5,
        cold = 5,
        radiation = 0
    }
}

RUST.Items["cloth_boots"] = {
    name = "Cloth Boots",
    icon = Material("rust/boots_1_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_FEET,
    bodygroups = {
        {5, 2}
    },

    stats = {
        bullet = 8,
        melee = 8,
        explosion = 5,
        cold = 5,
        radiation = 0
    }
}

RUST.Items["leather_helmet"] = {
    name = "Leather Helmet",
    icon = Material("rust/helmet_2_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_HEAD,
    bodygroups = {
        {8, 5}
    },

    stats = {
        bullet = 10,
        melee = 15,
        explosion = 10,
        cold = 15,
        radiation = 10
    }
}

RUST.Items["leather_vest"] = {
    name = "Leather Vest",
    icon = Material("rust/vest_2_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_CHEST,
    bodygroups = {
        {2, 1},
        {6, 1}
    },

    stats = {
        bullet = 10,
        melee = 15,
        explosion = 10,
        cold = 15,
        radiation = 10
    }
}

RUST.Items["leather_pants"] = {
    name = "Leather Pants",
    icon = Material("rust/pants_2_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_LEGS,
    bodygroups = {
        {3, 1},
        {7, 1}
    },

    stats = {
        bullet = 10,
        melee = 10,
        explosion = 10,
        cold = 10,
        radiation = 10
    }
}

RUST.Items["leather_boots"] = {
    name = "Leather Boots",
    icon = Material("rust/boots_2_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_FEET,
    bodygroups = {
        {5, 1}
    },

    stats = {
        bullet = 10,
        melee = 10,
        explosion = 10,
        cold = 10,
        radiation = 10
    }
}

RUST.Items["kevlar_helmet"] = {
    name = "Kevlar Helmet",
    icon = Material("rust/helmet_3_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_HEAD,
    bodygroups = {
        {8, 6}
    },

    stats = {
        bullet = 25,
        melee = 25,
        explosion = 15,
        cold = 10,
        radiation = 20
    }
}

RUST.Items["kevlar_vest"] = {
    name = "Kevlar Vest",
    icon = Material("rust/vest_3_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_CHEST,
    bodygroups = {
        {2, 1},
        {6, 3}
    },

    stats = {
        bullet = 30,
        melee = 30,
        explosion = 15,
        cold = 10,
        radiation = 30
    }
}

RUST.Items["kevlar_pants"] = {
    name = "Kevlar Pants",
    icon = Material("rust/pants_3_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_LEGS,
    bodygroups = {
        {3, 1},
        {7, 1}
    },

    stats = {
        bullet = 15,
        melee = 15,
        explosion = 15,
        cold = 10,
        radiation = 15
    }
}

RUST.Items["kevlar_boots"] = {
    name = "Kevlar Boots",
    icon = Material("rust/boots_3_icon.png"),
    max = 1,

    isArmor = true,
    type = RUST_ARMOR_TYPE_FEET,
    bodygroups = {
        {5, 1}
    },

    stats = {
        bullet = 15,
        melee = 15,
        explosion = 15,
        cold = 10,
        radiation = 15
    }
}

// ------------------------------------------------------------------

RUST.Items["556_ammo"] = {
    name = "556 Ammo",
    icon = Material("rust/556_ammo.png"),
    max = 250,
    isAmmo = true
}

RUST.Items["arrow"] = {
    name = "Arrow",
    icon = Material("rust/basic_arrow_icon.png"),
    max = 16,
    isAmmo = true
}

// ------------------------------------------------------------------

RUST.Items["m4"] = {
    name = "M4",
    icon = Material("rust/m4_icon.png"),
    max = 1,
    ent = "tfa_rustalpha_m4",
    ammo = "556_ammo",
    isWeapon = true
}

RUST.Items["mp5a4"] = {
    name = "MP5A4",
    icon = Material("rust/mp5_icon.png"),
    max = 1,
    ent = "tfa_rustalpha_mp5",
    ammo = "556_ammo",
    isWeapon = true
}

RUST.Items["hunting_bow"] = {
    name = "Hunting Bow",
    icon = Material("rust/hunting_bow_icon.png"),
    max = 1,
    ent = "rust_bow",
    ammo = "arrow",
    isWeapon = true,
    isBow = true
}

// ------------------------------------------------------------------

RUST.Items["hatchet"] = {
    name = "Hatchet",
    icon = Material("rust/hatchet_icon.png"),
    max = 1,
    ent = "rust_hatchet",
    isMelee = true
}

RUST.Items["stone_hatchet"] = {
    name = "Stone Hatchet",
    icon = Material("rust/stone_hatchet_icon.png"),
    max = 1,
    ent = "rust_stone_hatchet",
    isMelee = true
}

RUST.Items["rock"] = {
    name = "Rock",
    icon = Material("rust/rocktool_icon.png"),
    max = 1,
    ent = "rust_rock",
    isMelee = true
}

RUST.Items["pickaxe"] = {
    name = "Pickaxe",
    icon = Material("rust/pickaxe_icon.png"),
    max = 1,
    ent = "rust_pickaxe",
    isMelee = true
}

// ------------------------------------------------------------------

RUST.Items["raw_chicken"] = {
    name = "Raw Chicken",
    icon = Material("rust/chicken_breast_icon.png"),
    max = 250,
    hunger = 80,
    isFood = true
}

RUST.Items["cooked_chicken"] = {
    name = "Cooked Chicken",
    icon = Material("rust/cooked_chicken_breast_icon.png"),
    max = 250,
    hunger = 500,
    isFood = true
}

// ------------------------------------------------------------------

RUST.PlaceableInCampfire = {
    ["raw_chicken"] = true,
}

RUST.PlaceableInFurnace = {
    ["metal_ore"] = true,
    ["sulfur_ore"] = true,
    ["wood"] = true
}

RUST.RawFood = {
    ["raw_chicken"] = "cooked_chicken"
}

RUST.RawOre = {
    ["metal_ore"] = "metal_fragments",
    ["sulfur_ore"] = "sulfur"
}

// ------------------------------------------------------------------

function RUST.FreeSlot(inv)
    for slot, data in ipairs(RUST.Inventories[inv].slots) do
        if( !data )then
            return slot
        end
    end

    return false
end

function RUST.FreeSlots(inv, amount)
    local freeSlots = {}

    if( amount )then
        for slot, data in ipairs(RUST.Inventories[inv].slots) do
            if( !data )then
                table.insert(freeSlots, slot)
                amount = amount - 1

                if( amount <= 0 )then
                    return freeSlots
                end
            end
        end
    else
        for slot, data in ipairs(RUST.Inventories[inv].slots) do
            if( !data )then
                table.insert(freeSlots, slot)
            end
        end
    end

    return freeSlots
end

function RUST.FreeSlotsMinMax(inv, amount, minSlot, maxSlot)
    local freeSlots = {}

    if( amount )then
        for slot, data in ipairs(RUST.Inventories[inv].slots) do
            if( !data && slot >= minSlot && slot <= maxSlot )then
                table.insert(freeSlots, slot)
                amount = amount - 1

                if( amount <= 0 )then
                    return freeSlots
                end
            end
        end
    else
        for slot, data in ipairs(RUST.Inventories[inv].slots) do
            if( !data && slot >= minSlot && slot <= maxSlot )then
                table.insert(freeSlots, slot)
            end
        end
    end

    return freeSlots
end

function RUST.HasSpaceForAmount(inv, itemid, amount)
    local invData = RUST.Inventories[inv].slots
    local max = RUST.Items[itemid].max

    local freeSlots = {}
    local remainingAmount = amount

    for slot, data in ipairs(invData) do
        if( data && data.itemid == itemid && data.amount < max )then
            remainingAmount = remainingAmount - ( max - data.amount )
            table.insert(freeSlots, slot)

            if( remainingAmount <= 0 )then
                return freeSlots
            end
        end
    end

    if( remainingAmount > 0 )then
        local neededSlots = math.ceil(remainingAmount / max)
        local invFreeSlots = RUST.FreeSlots(inv, neededSlots)

        if( #invFreeSlots >= neededSlots )then
            for _, slot in ipairs(invFreeSlots) do
                table.insert(freeSlots, slot)
            end

            return freeSlots
        end
    end

    return false
end

function RUST.HasSpaceForAmountMinMax(inv, itemid, amount, minSlot, maxSlot)
    local invData = RUST.Inventories[inv].slots
    local max = RUST.Items[itemid].max

    local freeSlots = {}
    local remainingAmount = amount

    for slot, data in ipairs(invData) do
        if( data && data.itemid == itemid && data.amount < max && slot >= minSlot && slot <= maxSlot )then
            remainingAmount = remainingAmount - ( max - data.amount )
            table.insert(freeSlots, slot)

            if( remainingAmount <= 0 )then
                return freeSlots
            end
        end
    end

    if( remainingAmount > 0 )then
        local neededSlots = math.ceil(remainingAmount / max)
        local invFreeSlots = RUST.FreeSlotsMinMax(inv, neededSlots, minSlot, maxSlot)

        if( #invFreeSlots >= neededSlots )then
            for _, slot in ipairs(invFreeSlots) do
                table.insert(freeSlots, slot)
            end

            return freeSlots
        end
    end

    return false
end

function RUST.AddItem(inv, itemid, amount, itemData, ply)
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

                    if( ply )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount, invData[slot].itemData)
                    end
                else
                    if( ply )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
                    end
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

                    if( ply )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount, invData[slot].itemData)
                    end
                else
                    if( ply )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
                    end
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

function RUST.AddItemMinMax(inv, itemid, amount, itemData, min, max, ply)
    local invData = RUST.Inventories[inv].slots
    local freeSlots = RUST.HasSpaceForAmountMinMax(inv, itemid, amount, min, max)

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

                    if( IsValid(ply) )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount, invData[slot].itemData)
                    end
                else
                    if( IsValid(ply) )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
                    end
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

                    if( IsValid(ply) )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount, invData[slot].itemData)
                    end
                else
                    if( IsValid(ply) )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
                    end
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

function RUST.RemoveItemFromSlot(inv, slot, ply)
    local invData = RUST.Inventories[inv].slots

    if( invData[slot] )then
        local itemid = invData[slot].itemid
        invData[slot] = false

        if( IsValid(ply) )then
            netstream.Start(self, "RUST_UpdateSlot", inv, slot, itemid, 0)
        end

        return true
    end

    return false
end

function RUST.RemoveItemAmountFromSlot(inv, slot, amount, ply)
    local invData = RUST.Inventories[inv].slots

    if( invData[slot] && invData[slot].amount >= amount )then
        invData[slot].amount = invData[slot].amount - amount

        if( IsValid(ply) )then
            netstream.Start(self, "RUST_UpdateSlot", inv, slot, invData[slot].itemid, invData[slot].amount)
        end

        if( invData[slot].amount <= 0 )then
            invData[slot] = false
        end

        return true
    end

    return false
end

function RUST.RemoveItemAmount(inv, itemid, amount, ply)
    local invData = RUST.Inventories[inv].slots
    local availableAmount = RUST.GetItemAmountFromInv(inv, itemid)

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

                if( ply )then
                    if( !invData[slot] )then
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, 0)
                    else
                        netstream.Start(ply, "RUST_UpdateSlot", inv, slot, itemid, invData[slot].amount)
                    end
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

function RUST.GetItemAmountFromInv(inv, itemid)
    local invData = RUST.Inventories[inv].slots
    local amount = false

    for slot, data in ipairs(invData) do
        if( data && data.itemid == itemid )then
            if( !amount )then amount = 0 end

            amount = amount + data.amount
        end
    end

    return amount
end

// ------------------------------------------------------------------

function GM:CanMoveItem(ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData)
    return true
end

// TODO: IMPLEMENT CANDROP ( Weapons on reload )

function GM:CanDrop()
    return true
end
