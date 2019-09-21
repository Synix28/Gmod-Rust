--[[

    Crafting - SV

]]--

netstream.Hook("RUST_CraftItem", function(ply, itemid, craftAmount) // Item craften
    if( timer.Exists("Player_Crafting_" .. ply:SteamID()) )then return end
    if( !RUST.HasSpaceForAmount(ply:GetInv(), itemid, craftAmount) )then return end

    local hasEnough = true

    for item, amount in pairs(RUST.Recipes[itemid].needed) do
        local hasAmount = RUST.GetItemAmountFromInv(ply:GetInv(), item)

        if( !hasAmount || hasAmount < craftAmount )then
            hasEnough = false
        end
    end

    if( hasEnough )then
        timer.Create("Player_Crafting_" .. ply:SteamID(), RUST.Recipes[itemid].time * craftAmount, 1, function()
            if( ply && IsValid(ply) )then
                local _hasEnough = true

                for item, amount in pairs(RUST.Recipes[itemid].needed) do
                    local hasAmount = RUST.GetItemAmountFromInv(ply:GetInv(), item)

                    if( !hasAmount || hasAmount < craftAmount )then
                        _hasEnough = false
                    end
                end

                if( !_hasEnough )then return end
                if( !RUST.HasSpaceForAmount(ply:GetInv(), itemid, craftAmount) )then return end

                for item, amount in pairs(RUST.Recipes[itemid].needed) do
                    ply:RemoveItem(ply:GetInv(), item, craftAmount * amount)
                end

                ply:AddItem(ply:GetInv(), itemid, craftAmount)
            end
        end)
    end
end)

netstream.Hook("RUST_CancelCraft", function(ply)
    if( timer.Exists("Player_Crafting_" .. ply:SteamID()) )then
        timer.Remove("Player_Crafting_" .. ply:SteamID())
    end
end)