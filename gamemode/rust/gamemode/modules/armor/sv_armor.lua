--[[

    Armor - SV

]]--

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
    local statsData = ply:GetArmorStatsSum()
    local dmgScale = 1
    local wep = dmginfo:GetAttacker():GetActiveWeapon()

	if ( hitgroup == HITGROUP_HEAD ) then
		dmgScale = 2
    end

    if( dmginfo:IsBulletDamage() && !wep.isMelee )then
        dmginfo:ScaleDamage(dmgScale - ( statsData.bullet * 0.00533 ) )
    elseif( wep.isMelee )then
        dmginfo:ScaleDamage(dmgScale - ( statsData.melee * 0.00533 ) )
    elseif( dmginfo:IsExplosionDamage() )then
        dmginfo:ScaleDamage(dmgScale - ( statsData.explosion * 0.00533 ) )
    end
end