--[[

    Food - SH Meta

]]--

local PLAYER = FindMetaTable("Player")

function PLAYER:GetFood()
    return self:GetNWInt("RUST_Food", 0)
end