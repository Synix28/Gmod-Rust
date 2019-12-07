--[[

    Weapons - SH

]]--

local weapons = {
    ["tfa_rustalpha_m4"] = "m4",
    ["tfa_rustalpha_mp5"] = "mp5a4"
}

hook.Add("TFA_PreReload", "RUST_CheckAmmo", function(wep)
    local data = weapons[wep:GetClass()]

    if( data )then
        local ply = wep.Owner
        local itemData = RUST.Items[data]
        local amount = RUST.GetItemAmountFromInv(ply:GetInv(), itemData.ammo)

        if( ply.CantSwitchSlot )then return end
        if( wep:Clip1() >= wep.Primary.DefaultClip )then return true end
        if( !amount )then return true end

        ply.CantSwitchSlot = true

        if( SERVER )then
            if( amount >= ( wep.Primary.DefaultClip - wep:Clip1() ) )then
                local amountToSet = wep.Primary.DefaultClip - wep:Clip1()

                ply:SetAmmo(amountToSet, wep:GetPrimaryAmmoType())
            else
                ply:SetAmmo(wep:Clip1() + amount, wep:GetPrimaryAmmoType())
            end
        end
    end
end)

hook.Add("TFA_CompleteReload", "RUST_HandleAmmo", function(wep)
    local data = weapons[wep:GetClass()]

    if( data )then
        local ply = wep.Owner
        local itemData = RUST.Items[data]
        local amount = RUST.GetItemAmountFromInv(ply:GetInv(), itemData.ammo)

        if( !amount )then return true end

        if( amount >= ( wep.Primary.DefaultClip - wep:Clip1() ) )then
            local amountToSet = wep.Primary.DefaultClip - wep:Clip1()

            local invData = RUST.Inventories[ply:GetHotbarInv()].slots
            invData[ply.CurrentSelectedSlot].itemData.clip = wep:Clip1() + amountToSet

            if( SERVER )then
                ply:RemoveItem(ply:GetInv(), itemData.ammo, amountToSet)
                netstream.Start(ply, "RUST_UpdateSlotItemData", ply:GetHotbarInv(), ply.CurrentSelectedSlot, invData[ply.CurrentSelectedSlot].itemData)
            end
        else
            local invData = RUST.Inventories[ply:GetHotbarInv()].slots
            invData[ply.CurrentSelectedSlot].itemData.clip = wep:Clip1() + amount

            if( SERVER )then
                ply:RemoveItem(ply:GetInv(), itemData.ammo, amount)
                netstream.Start(ply, "RUST_UpdateSlotItemData", ply:GetHotbarInv(), ply.CurrentSelectedSlot, invData[ply.CurrentSelectedSlot].itemData)
            end
        end
    end
end)

hook.Add("TFA_PostPrimaryAttack", "RUST_GiveAmmo", function(wep)
    if( !SERVER )then return end

    local data = weapons[wep:GetClass()]

    if( data )then
        local ply = wep.Owner
        local inv = ply:GetHotbarInv()
        local invData = RUST.Inventories[inv].slots

        if( invData[ply.CurrentSelectedSlot] && invData[ply.CurrentSelectedSlot].itemData && invData[ply.CurrentSelectedSlot].itemData.clip )then
            invData[ply.CurrentSelectedSlot].itemData.clip = wep:Clip1()
            netstream.Start(ply, "RUST_UpdateSlotItemData", inv, ply.CurrentSelectedSlot, invData[ply.CurrentSelectedSlot].itemData)
        end
    end
end)

hook.Add("TFA_CompleteReload", "RUST_PreventWeaponSwitching", function(wep)
    local data = weapons[wep:GetClass()]

    if( data )then
        local ply = wep.Owner
        ply.CantSwitchSlot = false
    end
end)

