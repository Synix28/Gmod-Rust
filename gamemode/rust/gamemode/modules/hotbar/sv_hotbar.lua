--[[

    Hotbar - SV

]]--

RUST.HotbarSlotKeys = {
    [KEY_1] = 1,
    [KEY_2] = 2,
    [KEY_3] = 3,
    [KEY_4] = 4,
    [KEY_5] = 5,
    [KEY_6] = 6
}

// ------------------------------------------------------------------

// TODO: REWORK WITH HOOKS
netstream.Hook("RUST_ChangeSelectedSlot", function(ply, key)
    if( ( ply.HotbarCoolDown || -1 ) < CurTime() && RUST.HotbarSlotKeys[key] && !ply.CantSwitchSlot )then
        local slot = RUST.HotbarSlotKeys[key]
        local invData = RUST.Inventories[ply:GetHotbarInv()].slots

        if( invData[slot] )then
            local itemData = RUST.Items[invData[slot].itemid]

            if( itemData.isWeapon || itemData.isMelee )then
                if( ply.CurrentSelectedSlot && ply.CurrentSelectedSlot == slot )then
                    ply:StripWeapons()

                    ply.CurrentSelectedSlot = nil
                    ply.HotbarCoolDown = CurTime() + 1

                    netstream.Start(ply, "RUST_UpdateHotbarCoolDown", ply.HotbarCoolDown)

                    return
                end

                ply:StripWeapons()
                ply:Give(itemData.ent, true)

                if( itemData.isWeapon && invData[slot].itemData )then
                    ply:GetActiveWeapon():SetClip1(invData[slot].itemData.clip)
                end

                ply.CurrentSelectedSlot = slot
                ply.HotbarCoolDown = CurTime() + 1

                netstream.Start(ply, "RUST_UpdateHotbarCoolDown", ply.HotbarCoolDown)
            elseif( itemData.isFood && ( ply.EatCoolDown || -1 ) < CurTime() )then
                if( ( invData[slot].amount - 1 ) == 0 )then
                    invData[slot] = false
                else
                    invData[slot].amount = invData[slot].amount - 1
                end

                ply:AddFood(itemData.hunger)

                ply.EatCoolDown = CurTime() + 2
                ply.HotbarCoolDown = CurTime() + 1

                netstream.Start(ply, "RUST_UpdateHotbarCoolDown", ply.HotbarCoolDown)
                netstream.Start(ply, "RUST_UpdateEatCoolDown", ply.EatCoolDown)
            end
        end
    end
end)

// ------------------------------------------------------------------

hook.Add("PlayerDeath", "RUST_ResetCantSwitchSlot", function(victim, inflictor, attacker)
    victim.CantSwitchSlot = false
    netstream.Start(victim, "RUST_ResetCantSwitchSlot")
end)