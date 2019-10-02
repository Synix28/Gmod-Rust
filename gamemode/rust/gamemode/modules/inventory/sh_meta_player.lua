--[[

    Inventory - SH Meta

]]--

local PLAYER = FindMetaTable("Player")

function PLAYER:GetInv()
    return "Player_Inv_" .. self:SteamID()
end

function PLAYER:GetHotbarInv()
    return "Player_Hotbar_" .. self:SteamID()
end

function PLAYER:GetArmorInv()
    return "Player_Armor_" .. self:SteamID()
end