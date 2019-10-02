AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/blacksnow/crate_weapons.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    phys:Wake()

    self.inv = "Crate_Weapon_" .. self:EntIndex()

    RUST.Inventories[self.inv] = {
        owner = self,
        slots = {}
    }

    for i = 1, 20 do
        RUST.Inventories[self.inv].slots[i] = false
    end

    RUST.Inventories[self.inv].slots[1] = {
        itemid = "hunting_bow",
        amount = 1
    }

    RUST.Inventories[self.inv].slots[2] = {
        itemid = "cooked_chicken",
        amount = 100
    }

    RUST.Inventories[self.inv].slots[3] = {
        itemid = "kevlar_helmet",
        amount = 1
    }

    RUST.Inventories[self.inv].slots[4] = {
        itemid = "kevlar_vest",
        amount = 1
    }

    RUST.Inventories[self.inv].slots[5] = {
        itemid = "kevlar_pants",
        amount = 1
    }

    RUST.Inventories[self.inv].slots[6] = {
        itemid = "kevlar_boots",
        amount = 1
    }

    RUST.Inventories[self.inv].slots[7] = {
        itemid = "mp5a4",
        amount = 1,
        itemData = {
            clip = 20,
            attachments = {}
        }
    }

    RUST.Inventories[self.inv].slots[8] = {
        itemid = "m4",
        amount = 1,
        itemData = {
            clip = 20,
            attachments = {}
        }
    }

    RUST.Inventories[self.inv].slots[9] = {
        itemid = "556_ammo",
        amount = 200
    }

    RUST.Inventories[self.inv].slots[10] = {
        itemid = "arrow",
        amount = 16
    }

    RUST.Inventories[self.inv].slots[11] = {
        itemid = "rock",
        amount = 1
    }

    RUST.Inventories[self.inv].slots[12] = {
        itemid = "stone_hatchet",
        amount = 1
    }

    RUST.Inventories[self.inv].slots[13] = {
        itemid = "hatchet",
        amount = 1
    }

    RUST.Inventories[self.inv].slots[14] = {
        itemid = "pickaxe",
        amount = 1
    }
end

function ENT:OnRemove()
    RUST.Inventories[self.inv] = nil
end

function ENT:Use(caller, activator)
    if( caller:IsPlayer() && ( !self:GetUsedBy() || !IsValid(self:GetUsedBy()) ) )then
        self:SetUsedBy(caller)
        caller.Looting = self

        netstream.Start(caller, "RUST_SyncInventory", self.inv, RUST.Inventories[self.inv])
        netstream.Start(caller, "RUST_OpenLoot", self.inv)
    end
end

function ENT:CheckInv()
    local noLoot = true

    for slot, item in ipairs(RUST.Inventories[self.inv].slots) do
        if( item )then
            noLoot = false
        end
    end

    if( noLoot )then
        self:Remove()
    end
end