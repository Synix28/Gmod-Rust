--[[

    Crafting - SH

]]--

RUST.Recipes = RUST.Recipes || {}
RUST.Categories = RUST.Categories || {}

// ------------------------------------------------------------------

RUST.Categories["survival"] = {
    sort = 1,
    name = "Survival",
    recipes = {}
}

RUST.Categories["resource"] = {
    sort = 2,
    name = "Resource",
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
    time = 10,
    needed = {
        ["cloth"] = 40,
        ["metal_fragments"] = 100
    }
}

table.insert(RUST.Categories["survival"].recipes, "bed")

RUST.Recipes["campfire"] = {
    default = true,
    workbench = false,
    time = 2,
    needed = {
        ["wood"] = 5
    }
}

table.insert(RUST.Categories["survival"].recipes, "campfire")

RUST.Recipes["furnace"] = {
    default = true,
    workbench = false,
    time = 15,
    needed = {
        ["stones"] = 15,
        ["wood"] = 20,
        ["low_grade_fuel"] = 10
    }
}

table.insert(RUST.Categories["survival"].recipes, "furnace")

RUST.Recipes["low_grade_fuel"] = { 
    default = true,
    workbench = false,
    time = 2,
    needed = {
        ["animal_fat"] = 2,
        ["cloth"] = 1
    }
}

table.insert(RUST.Categories["survival"].recipes, "low_grade_fuel")

RUST.Recipes["low_quality_metal"] = { 
    default = true,
    workbench = false,
    time = 4,
    needed = {
        ["metal_fragments"] = 15
    }
} 

table.insert(RUST.Categories["survival"].recipes, "low_quality_metal")

RUST.Recipes["metal_door"] = { 
    default = true,
    workbench = false,
    time = 15,
    needed = {
        ["metal_fragments"] = 200
    }
}

table.insert(RUST.Categories["survival"].recipes, "metal_door")

RUST.Recipes["sleeping_bag"] = { 
    default = true,
    workbench = false,
    time = 15,
    needed = {
        ["cloth"] = 15
    }
}

table.insert(RUST.Categories["survival"].recipes, "sleeping_bag")

RUST.Recipes["small_stash"] = { 
    default = true,
    workbench = false,
    time = 10,
    needed = {
        ["leather"] = 10
    }
}

table.insert(RUST.Categories["survival"].recipes, "small_stash")

RUST.Recipes["stone_hatchet"] = { 
    default = true,
    workbench = false,
    time = 20,
    needed = {
        ["wood"] = 10,
        ["stones"] = 5
    }
}

table.insert(RUST.Categories["survival"].recipes, "stone_hatchet")

RUST.Recipes["wood_storage_box"] = { 
    default = true,
    workbench = false,
    time = 10,
    needed = {
        ["wood"] = 30
    }
}

table.insert(RUST.Categories["survival"].recipes, "wood_storage_box")

RUST.Recipes["wood_storage_box_large"] = { 
    default = true,
    workbench = false,
    time = 20,
    needed = {
        ["wood"] = 60
    }
}

table.insert(RUST.Categories["survival"].recipes, "wood_storage_box_large")

RUST.Recipes["wooden_barricade"] = { 
    default = true,
    workbench = false,
    time = 15,
    needed = {
        ["wood"] = 30
    }
}

table.insert(RUST.Categories["survival"].recipes, "wooden_barricade")

RUST.Recipes["wooden_door"] = { 
    default = true,
    workbench = false,
    time = 25,
    needed = {
        ["wood"] = 30
    }
}

table.insert(RUST.Categories["survival"].recipes, "wooden_door")

RUST.Recipes["wooden_shelter"] = { 
    default = true,
    workbench = false,
    time = 40,
    needed = {
        ["wood"] = 50
    }
}

table.insert(RUST.Categories["survival"].recipes, "wooden_shelter")

RUST.Recipes["workbench"] = { 
    default = true,
    workbench = false,
    time = 40,
    needed = {
        ["stones"] = 8,
        ["wood"] = 50
    }
}

table.insert(RUST.Categories["survival"].recipes, "workbench")

// ------------------------------------------------------------------

RUST.Recipes["gunpowder"] = { 
    default = true,
    workbench = false,
    time = 40,
    needed = {
        ["charcoal"] = 2,
        ["sulfur"] = 2
    }
}

table.insert(RUST.Categories["resource"].recipes, "gunpowder")

RUST.Recipes["wood_planks"] = { 
    default = true,
    workbench = false,
    time = 40,
    needed = {
        ["wood"] = 10
    }
}

table.insert(RUST.Categories["resource"].recipes, "wood_planks")

// ------------------------------------------------------------------