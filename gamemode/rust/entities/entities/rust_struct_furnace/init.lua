AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/galaxy/rust/furnace.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()

    local phys = self:GetPhysicsObject()
    phys:EnableMotion(false)

    self.fireSound = 0
    self.firePath = "rust_fire_sound"
    self.fireMaxDuration = SoundDuration(self.firePath)

    local inv = self:GetInv()

    RUST.Inventories[inv] = {
        owner = self,
        slots = {}
    }

    for i = 1, 9 do
        RUST.Inventories[inv].slots[i] = false
    end

    self:SetFireOn(false)
end

function ENT:GetInv()
    return "Struct_Furnace_" .. self:EntIndex()
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
        netstream.Start(caller, "RUST_OpenFurnace", inv)
    end
end

function ENT:Think()
    if( self:GetFireOn() )then

        if( !self:CheckFireTime() )then return end
        if( !self.nextCook )then self.nextCook = CurTime() + 5 end

        if( self.nextCook < CurTime() )then
            local invData = RUST.Inventories[self:GetInv()].slots

            // TODO: NEW SMELT LOGIC
            /*
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
            */

            local maxBurnAmount = math.Round(self.MaxBurnAmount * self.BurnTimeFac)
            // TODO: IMPLEMENT maxBurnAmount

            for slot, data in ipairs(invData) do
                local oreResult = data && RUST.RawOre[data.itemid] || false

                if( oreResult )then
                    local noSpace = false
                    local amountToRemove

                    if( data.amount >= maxBurnAmount )then
                        amountToRemove = self.MaxBurnAmount
                    else
                        amountToRemove = data.amount
                    end

                    RUST.RemoveItemAmountFromSlot(self:GetInv(), slot, amountToRemove, self:GetUsedBy())
                    noSpace = !RUST.AddItem(self:GetInv(), oreResult, amountToRemove, nil, self:GetUsedBy())

                    if( noSpace )then
                        local ent = ents.Create("rust_item")
                        ent:SetPos( self:LocalToWorld(Vector(0, 0, 70)) )
                            ent:SetItemID(oreResult)
                            ent:SetAmount(amountToRemove)
                        ent:Spawn()
                    end
                end
            end

            self.nextCook = CurTime() + 5
        end

        if( self.fireSound < CurTime() )then
            self:EmitSound(self.firePath)
            self.fireSound = CurTime() + self.fireMaxDuration
        end
    end
end

function ENT:CheckFireTime()
    local invData = RUST.Inventories[self:GetInv()].slots
    local coalAmount
    local notFirstTime = self.fireTime != nil

    if( !self.fireTime || self.fireTime < CurTime() )then
        local availableAmount = RUST.GetItemAmountFromInv(self:GetInv(), "wood")

        if( availableAmount && availableAmount >= self.MaxBurnAmount && RUST.RemoveItemAmount(self:GetInv(), "wood", self.MaxBurnAmount, self:GetUsedBy()) )then
            self.fireTime = CurTime() + self.MaxBurnAmount * self.BurnTimeFac
            coalAmount = self.MaxBurnAmount
        elseif( availableAmount && availableAmount > 0 )then
            self.fireTime = CurTime() + availableAmount * self.BurnTimeFac
            coalAmount = availableAmount

            RUST.RemoveItemAmount(self:GetInv(), "wood", availableAmount, self:GetUsedBy())
        else
            self:SetFireOn(false)
            self.nextCook = false
            self.fireTime = nil
            
            if( self.fire && IsValid(self.fire) )then
                self.fire:Fire("Kill")
                self.fire = nil
            end

            self:StopSound(self.firePath)

            return false
        end
    end

    if( notFirstTime && coalAmount && coalAmount > 0 && !RUST.AddItem(self:GetInv(), "charcoal", math.ceil(coalAmount / 2), nil, self:GetUsedBy()) )then
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
    if( self.fire && IsValid(self.fire) )then self.fire:Remove() self.fire = nil self:SetFireOn(false) self.nextCook = false self:StopSound(self.firePath) return end

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