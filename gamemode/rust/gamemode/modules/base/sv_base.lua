--[[

    Base - SV

]]--

function GM:PlayerInitialSpawn(ply)
end

function GM:PlayerDeath(victim, inflictor, attacker)
end

function GM:PlayerSpawn(ply)
    ply:SetModel(RUST.PlayerConfig.Model)
    ply:SetupHands()

    ply:SetWalkSpeed(RUST.PlayerConfig.WalkSpeed)
    ply:SetRunSpeed(RUST.PlayerConfig.RunSpeed)

    ply:SetDuckSpeed(RUST.PlayerConfig.DuckSpeed)
    ply:SetUnDuckSpeed(RUST.PlayerConfig.UnDuckSpeed)
end

// fix disguisting hands

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( "models/player/eli.mdl" )
	local info = player_manager.TranslatePlayerHands( simplemodel )

	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:GetFallDamage(ply, speed)
	return speed / 16
end