AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/galaxy/rust/woodpile1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:GetPhysicsObject():EnableMotion(false)

    self.baseResources = {
        wood = 80
    }

    self.resources = {
        wood = 80
    }

    self.canBreak = {
        [1] = true,
        [2] = true,
        [3] = true
    }

    self.focusOn = "wood"
end

function ENT:OnRemove()
    if( !self.id )then return end

    RUST.ResourceLocations[self.id].ent = false
    RUST.ResourceLocations[self.id].nextSpawn = CurTime() + RUST.ResourcesRespawnTime
end

function ENT:OnTakeDamage(dmginfo)
    local ply = dmginfo:GetAttacker()
    local wep = ply:GetActiveWeapon()
    local data = RUST.FarmFactor[wep:GetClass()]

    if( data )then
        local canGet = data

        if( self.resources.wood < canGet )then
            canGet = self.resources.wood
        end

        ply:AddItem(ply:GetInv(), "wood", canGet)
        netstream.Start(ply, "RUST_NewItemNotify", "wood", canGet) // TODO: Add Notify Module

        self.resources.wood = self.resources.wood - canGet

        local currAmount = self.resources[self.focusOn]
        local baseAmount = self.baseResources[self.focusOn]

        if( currAmount < baseAmount * 0.8 && currAmount >= baseAmount * 0.6 && self.canBreak[1] )then
            self:SetModel("models/galaxy/rust/woodpile2.mdl")
            ply:EmitSound("effect/sfx/wood_death.wav", 75)

            self.canBreak[1] = false
        elseif( currAmount < baseAmount * 0.6 && currAmount >= baseAmount * 0.2 && self.canBreak[2] )then
            self:SetModel("models/galaxy/rust/woodpile3.mdl")
            ply:EmitSound("effect/sfx/wood_death.wav", 75)

            self.canBreak[2] = false
        elseif( currAmount < baseAmount * 0.2 && currAmount >= baseAmount * 0 && self.canBreak[3] )then
            self:SetModel("models/galaxy/rust/woodpile4.mdl")
            ply:EmitSound("effect/sfx/wood_death.wav", 75)

            self.canBreak[3] = false
        end

        if( self.resources.wood <= 0 )then
            self:Remove()
        end
    end
end