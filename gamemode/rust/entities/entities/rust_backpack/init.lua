AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/galaxy/rust/backpack.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()

    local phys = self:GetPhysicsObject()
    phys:EnableMotion(false)

    local inv = self:GetInv()

    RUST.Inventories[inv] = {
        owner = self,
        slots = {}
    }

    for i = 1, 40 do
        RUST.Inventories[inv].slots[i] = false
    end

    timer.Create("Remove_Item_" .. self:EntIndex(), 500, 1, function()
        if( IsValid(self) )then
            self:Remove()
        end
    end)
end

function ENT:FillInventory(ply)
    local invs = {
        ply:GetInv(),
        ply:GetHotbarInv(),
        ply:GetArmorInv()
    }

    local entInv = self:GetInv()

    for _, inv in ipairs(invs) do
        for k, v in ipairs(RUST.Inventories[inv].slots) do
            if( !v )then continue end

            local slot = RUST.FreeSlot(entInv)
            
            RUST.Inventories[entInv].slots[slot] = {
                itemid = v.itemid,
                amount = v.amount,
                itemData = v.itemData || nil
            }
        end
    end
end

function ENT:GetInv()
    return "Backpack_" .. self:EntIndex()
end

function ENT:OnRemove()
    RUST.Inventories[self:GetInv()] = nil
    timer.Remove("Remove_Item_" .. self:EntIndex())
end

function ENT:Use(caller, activator)
    if( caller:IsPlayer() && ( !self:GetUsedBy() || !IsValid(self:GetUsedBy()) ) )then
        self:SetUsedBy(caller)
        caller.Looting = self

        local inv = self:GetInv()

        netstream.Start(caller, "RUST_SyncInventory", inv, RUST.Inventories[inv])
        netstream.Start(caller, "RUST_OpenLoot", inv)
    end
end

function ENT:CheckInv()
    local noLoot = true

    for slot, item in ipairs(RUST.Inventories[self:GetInv()].slots) do
        if( item )then
            noLoot = false
        end
    end

    if( noLoot )then
        self:Remove()
    end
end