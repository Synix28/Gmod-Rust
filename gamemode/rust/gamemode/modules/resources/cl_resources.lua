--[[

    Resources - CL

]]--

netstream.Hook("RUST_NewItemNotify", function(itemID, amount)
    local itemData = RUST.Items[itemID]

    notification.AddLegacy("You got " .. amount .. " " .. itemData.name .. "!", NOTIFY_GENERIC, 3)
end)