--[[

    Crafting - SV

]]-- RUST_CraftItem

netstream.Hook("RUST_CraftItem", function(ply, itemid, craftAmount) // Item craften
    local invData = RUST.Inventories[ply:GetInv()].slots

    if( !RUST.HasSpaceForAmount(ply:GetInv(), itemid, craftAmount) )then return end

    local hasEnough = true

    for item, amount in pairs(RUST.Recipes[itemid].needed) do
        local hasAmount = RUST.GetItemAmountFromInv(ply:GetInv(), item)

        if( !hasAmount || hasAmount < craftAmount )then
            hasEnough = false
        end
    end

    if( hasEnough )then
        for item, amount in pairs(RUST.Recipes[itemid].needed) do
            ply:RemoveItem(ply:GetInv(), item, craftAmount * amount)
        end

        ply:AddItem(ply:GetInv(), itemid, craftAmount)
    end

    print("-------------------------------------------------------------")
    PrintTable(RUST.Inventories[ply:GetInv()])
    print("-------------------------------------------------------------")
end)