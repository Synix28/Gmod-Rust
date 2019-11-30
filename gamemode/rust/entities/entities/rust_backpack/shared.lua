ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Backpack"
ENT.Category = "Rust"

ENT.Author = "Aden"

ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "UsedBy")
end