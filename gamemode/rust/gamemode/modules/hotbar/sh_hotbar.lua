--[[

    Hotbar - SH

]]--

hook.Add("CanMoveItem", "RUST_HandleHotbarSlots", function(ply, fromSlotID, fromSlotInv, fromSlotInvData, toSlotID, toSlotInv, toSlotInvData)
    local hotbarInv = ply:GetHotbarInv()

    if( fromSlotInv == hotbarInv && fromSlotID == ply.CurrentSelectedSlot )then
        local fromSlotItemData = RUST.Items[fromSlotInvData[fromSlotID].itemid]

        if( toSlotInvData[toSlotID] )then
            local toSlotItemData = RUST.Items[toSlotInvData[toSlotID].itemid]

            if( fromSlotItemData.isWeapon && ply.CantSwitchSlot )then
                return false
            end

            if( toSlotItemData.isWeapon || toSlotItemData.isMelee )then
                if( SERVER )then
                    ply:StripWeapons()
                    ply:Give(toSlotItemData.ent, true)

                    if( toSlotItemData.isWeapon )then
                        ply:GetActiveWeapon():SetClip1(toSlotInvData[toSlotID].itemData.clip)
                    end
                end
            else
                if( SERVER )then
                    ply:StripWeapons()
                end

                ply.CurrentSelectedSlot = nil
            end
        else
            if( fromSlotItemData.isWeapon && ply.CantSwitchSlot )then
                return false
            end

            if( SERVER )then
                ply:StripWeapons()
            end

            ply.CurrentSelectedSlot = nil
        end

        return true
    elseif( toSlotInv == hotbarInv && toSlotID == ply.CurrentSelectedSlot )then
        local fromSlotItemData = RUST.Items[fromSlotInvData[fromSlotID].itemid]

        if( fromSlotItemData.isWeapon && ply.CantSwitchSlot || toSlotInvData[toSlotID] && RUST.Items[toSlotInvData[toSlotID].itemid].isWeapon && ply.CantSwitchSlot )then
            return false
        end

        if( fromSlotItemData.isWeapon || fromSlotItemData.isMelee )then
            if( SERVER )then
                ply:StripWeapons()
                ply:Give(fromSlotItemData.ent, true)

                if( fromSlotItemData.isWeapon )then
                    ply:GetActiveWeapon():SetClip1(fromSlotInvData[fromSlotID].itemData.clip)
                end
            end
        else
            if( SERVER )then
                ply:StripWeapons()
            end

            ply.CurrentSelectedSlot = nil
        end

        return true
    end
end)