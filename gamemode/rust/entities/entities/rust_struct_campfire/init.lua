AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/galaxy/rust/campfire.mdl")
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

    for i = 1, 8 do
        RUST.Inventories[inv].slots[i] = false
    end

    self:SetFireOn(false)
end

function ENT:GetInv()
    return "Struct_Campfire_" .. self:EntIndex()
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
        netstream.Start(caller, "RUST_OpenCampfire", inv)
    end
end

function ENT:Think()
    if( self:GetFireOn() )then

        if( !self:CheckFireTime() )then return end
        if( !self.nextCook )then self.nextCook = CurTime() + 5 end

        if( self.nextCook < CurTime() )then
            local invData = RUST.Inventories[self:GetInv()].slots

            for i = 1, 3 do
                if( invData[3 + i] )then
                    local result = RUST.RawFood[invData[3 + i].itemid]
                    local noSpace = false

                    RUST.RemoveItemAmountFromSlot(self:GetInv(), 3 + i, 1, self:GetUsedBy())
                    noSpace = !RUST.AddItemMinMax(self:GetInv(), result, 1, nil, 1, 3, self:GetUsedBy())

                    if( noSpace )then
                        local ent = ents.Create("rust_item")
                        ent:SetPos( self:LocalToWorld(Vector(0, 0, 25)) )
                            ent:SetItemID(result)
                            ent:SetAmount(1)
                        ent:Spawn()
                    end
                end
            end

            self.nextCook = CurTime() + 5
        end
    end
end

function ENT:CheckFireTime()
    local invData = RUST.Inventories[self:GetInv()].slots
    local coalAmount
    local notFirstTime = self.fireTime != nil

    if( !self.fireTime || self.fireTime < CurTime() )then
        if( invData[7] && RUST.RemoveItemAmountFromSlot(self:GetInv(), 7, self.MaxBurnAmount, self:GetUsedBy()) )then
            self.fireTime = CurTime() + self.MaxBurnAmount * self.BurnTimeFac
            coalAmount = self.MaxBurnAmount
        elseif( invData[7] )then
            self.fireTime = CurTime() + invData[7].amount * self.BurnTimeFac
            coalAmount = invData[7].amount

            RUST.RemoveItemFromSlot(self:GetInv(), invData[7].amount, self:GetUsedBy())
        else
            self:SetFireOn(false)
            self.nextCook = false
            self.fireTime = nil
            
            if( self.fire && IsValid(self.fire) )then
                self.fire:Fire("Kill")
                self.fire = nil
            end

            return false
        end
    end

    if( notFirstTime && coalAmount && coalAmount > 0 && !RUST.AddItemMinMax(self:GetInv(), "charcoal", math.ceil(coalAmount / 2), nil, 8, 8, self:GetUsedBy()) )then
        local ent = ents.Create("rust_item")
        ent:SetPos( self:LocalToWorld(Vector(0, 0, 25)) )
            ent:SetItemID("charcoal")
            ent:SetAmount(math.ceil(coalAmount / 2))
        ent:Spawn()
    end

    return true
end

function ENT:LightFire()
    if( !self:CheckFireTime() )then return end
    if( self.fire && IsValid(self.fire) )then self.fire:Remove() self.fire = nil self:SetFireOn(false) self.nextCook = false return end

    self.fire = ents.Create("env_fire", self)
    if !IsValid(self.fire) then return end

    self.fire:SetParent(self)
    self.fire:SetPos(self:GetPos())

    self.fire:SetKeyValue("spawnflags", "5")
    self.fire:SetKeyValue("firesize", 15)
    self.fire:SetKeyValue("fireattack", 2)

    self.fire:Spawn()
    self.fire:Activate()

    self:SetFireOn(true)
end

function ENT:CheckInv()
end