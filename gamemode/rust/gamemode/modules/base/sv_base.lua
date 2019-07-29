--[[

    Base - SV

]]--

function GM:PlayerInitialSpawn(ply)
end

function GM:PlayerSpawn(ply)
    ply:SetModel(RUST.PlayerConfig.Model)
    ply:SetupHands()

    ply:SetWalkSpeed(RUST.PlayerConfig.WalkSpeed)
    ply:SetRunSpeed(RUST.PlayerConfig.RunSpeed)

    ply:SetDuckSpeed(RUST.PlayerConfig.DuckSpeed)
    ply:SetUnDuckSpeed(RUST.PlayerConfig.UnDuckSpeed)
end