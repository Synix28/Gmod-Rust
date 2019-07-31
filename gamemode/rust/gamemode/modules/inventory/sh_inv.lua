--[[

    Inventory - SH

]]--

RUST.Items = RUST.Items || {}
RUST.Recipes = RUST.Recipes || {}
RUST.Categories = RUST.Categories || {}
RUST.Inventories = RUST.Inventories || {}

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

// ------------------------------------------------------------------

RUST.Items["metal_door"] = {
    name = "Metal Door",
    icon = Material("rust/metal_door_icon.png"),
    max = 1,
    isDoor = true
}

// ------------------------------------------------------------------

RUST.Categories["survival"] = {
    sort = 1,
    name = "Survival",
    recipes = {}
}

RUST.Categories["resources"] = {
    sort = 2,
    name = "Resources",
    recipes = {}
}

RUST.Categories["medical_items"] = {
    sort = 3,
    name = "Medical",
    recipes = {}
}

RUST.Categories["weapons"] = {
    sort = 4,
    name = "Weapons",
    recipes = {}
}

RUST.Categories["weapon_mods"] = {
    sort = 5,
    name = "Weapon Mods",
    recipes = {}
}

RUST.Categories["armor"] = {
    sort = 6,
    name = "Armor",
    recipes = {}
}

RUST.Categories["tools"] = {
    sort = 7,
    name = "Tools",
    recipes = {}
}

RUST.Categories["parts"] = {
    sort = 8,
    name = "Parts",
    recipes = {}
}

// ------------------------------------------------------------------

RUST.Recipes["bed"] = {
    default = true,
    workbench = false,
    needed = {
        ["cloth"] = 40,
        ["metal_fragments"] = 100
    }
}

table.insert(RUST.Categories["survival"].recipes, "bed")

RUST.Recipes["campfire"] = {
    default = true,
    workbench = false,
    needed = {
        ["wood"] = 5
    }
}

table.insert(RUST.Categories["survival"].recipes, "campfire")

RUST.Recipes["furnace"] = {
    default = true,
    workbench = false,
    needed = {
        ["stones"] = 15,
        ["wood"] = 20,
        ["low_grade_fuel"] = 10,
        ["bed"] = 20,
        ["campfire"] = 20,
    }
}

table.insert(RUST.Categories["survival"].recipes, "furnace")

RUST.Recipes["low_grade_fuel"] = { 
    default = true,
    workbench = false,
    needed = {
        ["animal_fat"] = 2,
        ["cloth"] = 1
    }
}

table.insert(RUST.Categories["survival"].recipes, "low_grade_fuel")

RUST.Recipes["low_quality_metal"] = { 
    default = true,
    workbench = false,
    needed = {
        ["metal_fragments"] = 15
    }
} 

table.insert(RUST.Categories["survival"].recipes, "low_quality_metal")

RUST.Recipes["metal_door"] = { 
    default = true,
    workbench = false,
    needed = {
        ["metal_fragments"] = 200
    }
}

table.insert(RUST.Categories["survival"].recipes, "metal_door")

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
            table.Merge(freeSlots, invFreeSlots)
            return freeSlots
        end
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