ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Item"
ENT.Category = "Rust"

ENT.Author = "Aden"

ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ItemID")
    self:NetworkVar("Int", 0, "Amount")
end