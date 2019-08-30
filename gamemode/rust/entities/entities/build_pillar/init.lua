AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/vasey/wood_house/wood_pillar.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    //self:SetCollisionGroup(COLLISION_GROUP_NONE)

    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    phys:Wake()

    constraint.NoCollide(self, game.GetWorld(), 0, 0)
end

function ENT:Use(caller, activator)
end