AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/galaxy/rust/rockore1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:GetPhysicsObject():EnableMotion(false)

    self.baseResources = {
        stones = 15,
        metal_ore = 8,
        sulfur_ore = 5,
    }

    self.resources = {
        stones = 15,
        metal_ore = 8,
        sulfur_ore = 5,
    }

    self.canBreak = {
        [1] = true,
        [2] = true,
        [3] = true
    }

    self.oreSkin = 1
    self.focusOn = "stones"

    self:SetSkin(self.oreSkin)
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
        for k, v in pairs(self.resources) do
            if( v <= 0 )then continue end

            local canGet = math.Round(data * 0.33)

            if( v < canGet )then
                canGet = v
            end

            ply:AddItem(ply:GetInv(), k, canGet)
            netstream.Start(ply, "RUST_NewItemNotify", k, canGet) // TODO: Add Notify Module

            self.resources[k] = self.resources[k] - canGet
        end

        local currAmount = self.resources[self.focusOn]
        local baseAmount = self.baseResources[self.focusOn]

        if( currAmount < baseAmount * 0.8 && currAmount >= baseAmount * 0.6 && self.canBreak[1] )then
            self:SetModel("models/galaxy/rust/rockore2.mdl")
            ply:EmitSound("shared/sfx/rock_break.wav", 75)

            self.canBreak[1] = false
        elseif( currAmount < baseAmount * 0.6 && currAmount >= baseAmount * 0.2 && self.canBreak[2] )then
            self:SetModel("models/galaxy/rust/rockore3.mdl")
            ply:EmitSound("shared/sfx/rock_break.wav", 75)

            self.canBreak[2] = false
        elseif( currAmount < baseAmount * 0.2 && currAmount >= baseAmount * 0 && self.canBreak[3] )then
            self:SetModel("models/galaxy/rust/rockore4.mdl")
            ply:EmitSound("shared/sfx/rock_break.wav", 75)

            self.canBreak[3] = false
        end

        if( self.resources.stones <= 0 && self.resources.metal_ore <= 0 && self.resources.sulfur_ore <= 0 )then
            self:Remove()
        end
    end
end