--[[

    Weapons - SH

]]--

local weapons = {
    ["m4_legacy"] = "556_ammo",
    ["mp5_legacy"] = "556_ammo",
}

CustomizableWeaponry.callbacks:addNew("canReload", "RUST_GiveAmmo", function(wep, isEmpty)
    local data = weapons[wep:GetClass()]

    if( data )then
        local ply = wep.Owner
        local amount = RUST.GetItemAmountFromInv(ply:GetInv(), data)

        if( wep:Clip1() >= wep.Primary.DefaultClip )then return true end

        if( !amount )then
            return true
        elseif( amount >= ( wep.Primary.DefaultClip - wep:Clip1() ) )then
            local amountToSet = wep.Primary.DefaultClip - wep:Clip1()

            if( SERVER )then
                ply:RemoveItem(ply:GetInv(), data, amountToSet)
                ply:GiveAmmo(amountToSet, wep:GetPrimaryAmmoType(), true)
            end

            local invData = RUST.Inventories[ply:GetHotbarInv()].slots
            invData[ply.CurrentSelectedSlot].itemData.clip = wep:Clip1() + amountToSet

            //return nil, nil, true
        else
            if( SERVER )then
                ply:RemoveItem(ply:GetInv(), data, amount)
                ply:GiveAmmo(amount, wep:GetPrimaryAmmoType(), true)
            end

            local invData = RUST.Inventories[ply:GetHotbarInv()].slots
            invData[ply.CurrentSelectedSlot].itemData.clip = wep:Clip1() + amount

            //return nil, nil, true
        end
    end
end)

CustomizableWeaponry.callbacks:addNew("shouldSuppressAmmoUsage", "RUST_SetItemData", function(wep)
    local data = weapons[wep:GetClass()]

    if( !SERVER )then return end

    if( data )then
        local ply = wep.Owner
        local inv = ply:GetHotbarInv()
        local invData = RUST.Inventories[inv].slots

        if( invData[ply.CurrentSelectedSlot] && invData[ply.CurrentSelectedSlot].itemData && invData[ply.CurrentSelectedSlot].itemData.clip )then
            invData[ply.CurrentSelectedSlot].itemData.clip = invData[ply.CurrentSelectedSlot].itemData.clip - 1
            netstream.Start(ply, "RUST_UpdateSlotItemData", inv, ply.CurrentSelectedSlot, invData[ply.CurrentSelectedSlot].itemData)
        end
    end
end)

CustomizableWeaponry.callbacks:addNew("beginReload", "RUST_PreventWeaponSwitching", function(wep)
    local data = weapons[wep:GetClass()]

    if( data )then
        local ply = wep.Owner
        ply.CantSwitchSlot = true
    end
end)

CustomizableWeaponry.callbacks:addNew("finishReload", "RUST_PreventWeaponSwitching", function(wep)
    local data = weapons[wep:GetClass()]

    if( data )then
        local ply = wep.Owner
        ply.CantSwitchSlot = false
    end
end)