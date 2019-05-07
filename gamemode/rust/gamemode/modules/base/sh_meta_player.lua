--[[

    SH META PLAYER

]]--

local PLAYER = FindMetaTable("Player")

if ( SERVER ) then
    function PLAYER:ApplyVars()
        self:SetWalkSpeed(RUST.PlayerConfig.WalkSpeed)
        self:SetRunSpeed(RUST.PlayerConfig.RunSpeed)

        self:SetDuckSpeed(RUST.PlayerConfig.DuckSpeed)
        self:SetUnDuckSpeed(RUST.PlayerConfig.UnDuckSpeed)

        self:SetModel(RUST.PlayerConfig.Model)
        self:SetupHands()
    end
end

if ( CLIENT ) then

end