AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/galaxy/rust/itembag.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    phys:Wake()

    timer.Create("Remove_Item_" .. self:EntIndex(), 500, 1, function()
        if( IsValid(self) )then
            self:Remove()
        end
    end)
end

function ENT:OnRemove()
    timer.Remove("Remove_Item_" .. self:EntIndex())
end

function ENT:SetItemData(itemData)
    self.itemData = itemData
end

function ENT:Use(caller, activator)
    if( caller:IsPlayer() && caller:AddItem(caller:GetInv(), self:GetItemID(), self:GetAmount(), self.itemData) )then
        self:Remove()
    end
end