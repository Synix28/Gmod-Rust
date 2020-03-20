AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/blacksnow/crate_weapons.mdl")
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

    for i = 1, 20 do
        RUST.Inventories[inv].slots[i] = false
    end

    RUST.Inventories[inv].slots[1] = {
        itemid = "hunting_bow",
        amount = 1
    }

    RUST.Inventories[inv].slots[2] = {
        itemid = "cooked_chicken",
        amount = 100
    }

    RUST.Inventories[inv].slots[3] = {
        itemid = "kevlar_helmet",
        amount = 1
    }

    RUST.Inventories[inv].slots[4] = {
        itemid = "kevlar_vest",
        amount = 1
    }

    RUST.Inventories[inv].slots[5] = {
        itemid = "kevlar_pants",
        amount = 1
    }

    RUST.Inventories[inv].slots[6] = {
        itemid = "kevlar_boots",
        amount = 1
    }

    RUST.Inventories[inv].slots[7] = {
        itemid = "mp5a4",
        amount = 1,
        itemData = {
            clip = 20,
            attachments = {}
        }
    }

    RUST.Inventories[inv].slots[8] = {
        itemid = "m4",
        amount = 1,
        itemData = {
            clip = 20,
            attachments = {}
        }
    }

    RUST.Inventories[inv].slots[9] = {
        itemid = "556_ammo",
        amount = 200
    }

    RUST.Inventories[inv].slots[10] = {
        itemid = "arrow",
        amount = 16
    }

    RUST.Inventories[inv].slots[11] = {
        itemid = "rock",
        amount = 1
    }

    RUST.Inventories[inv].slots[12] = {
        itemid = "stone_hatchet",
        amount = 1
    }

    RUST.Inventories[inv].slots[13] = {
        itemid = "hatchet",
        amount = 1
    }

    RUST.Inventories[inv].slots[14] = {
        itemid = "pickaxe",
        amount = 1
    }

    RUST.Inventories[inv].slots[15] = {
        itemid = "raw_chicken",
        amount = 100
    }

    RUST.Inventories[inv].slots[16] = {
        itemid = "sulfur_ore",
        amount = 250
    }
end

function ENT:GetInv()
    return "Crate_Weapon_" .. self:EntIndex()
end

function ENT:OnRemove()
    RUST.Inventories[self:GetInv()] = nil
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