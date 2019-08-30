--[[

    Hotbar - CL

]]--

local input = input
local CurTime = CurTime
local LocalPlayer = LocalPlayer

RUST.HotbarSlotKeys = {
    KEY_1,
    KEY_2,
    KEY_3,
    KEY_4,
    KEY_5,
    KEY_6
}

RUST.HotbarSlotKeysNum = {
    [KEY_1] = 1,
    [KEY_2] = 2,
    [KEY_3] = 3,
    [KEY_4] = 4,
    [KEY_5] = 5,
    [KEY_6] = 6
}

RUST.HotbarCoolDown = -1

// ------------------------------------------------------------------

hook.Add("Think", "RUST_SelectSlot", function()
    for _, key in ipairs(RUST.HotbarSlotKeys) do
        if( input.IsKeyDown(key) && RUST.HotbarCoolDown < CurTime() && !LocalPlayer().CantSwitchSlot )then
            local ply = LocalPlayer()
            local slot = RUST.HotbarSlotKeysNum[key]
            local invData = RUST.Inventories[ply:GetHotbarInv()].slots

            if( invData[slot] )then
                local itemData = RUST.Items[invData[slot].itemid]

                if( itemData.isWeapon || itemData.isMelee )then
                    if( ply.CurrentSelectedSlot && ply.CurrentSelectedSlot == slot )then
                        netstream.Start("RUST_ChangeSelectedSlot", key)

                        ply.CurrentSelectedSlot = nil
                        ply.HotbarCoolDown = CurTime() + 1

                        return
                    end

                    netstream.Start("RUST_ChangeSelectedSlot", key)

                    ply.CurrentSelectedSlot = slot
                    RUST.HotbarCoolDown = CurTime() + 1
                elseif( itemData.isFood )then
                    if( ( invData[slot].amount - 1 ) == 0 )then
                        RUST.VGUI.Hotbar.list:GetChildren()[slot]:GetChildren()[1]:Remove()
                        invData[slot] = false
                    else
                        invData[slot].amount = invData[slot].amount - 1
                        RUST.VGUI.Hotbar.list:GetChildren()[slot]:GetChildren()[1]:SetAmount(invData[slot].amount)
                    end

                    ply:EmitSound("item/sfx/eating.wav", 75)

                    netstream.Start("RUST_ChangeSelectedSlot", key)

                    RUST.HotbarCoolDown = CurTime() + 2
                end
            end
        end
    end
end)

// ------------------------------------------------------------------

netstream.Hook("RUST_ResetCantSwitchSlot", function(inv)
    local ply = LocalPlayer()
    ply.CantSwitchSlot = false
end)