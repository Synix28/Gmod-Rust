include("shared.lua")

local surface = surface
local draw = draw
local cam = cam
local Angle = Angle
local Vector = Vector
local Color = Color

surface.CreateFont( "RUST_Item_Title", {
	font = "Arial",
	extended = false,
	size = 36,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )

surface.CreateFont( "RUST_Item_Amount", {
	font = "Arial",
	extended = false,
	size = 24,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )

function ENT:Draw()
    self:DrawModel()

    local pos = self:LocalToWorld(Vector(0, 0, 30))
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    if( self:GetPos():Distance(LocalPlayer():GetPos()) > 800 )then return end

	cam.Start3D2D(pos, ang, 0.14)
		draw.SimpleTextOutlined(RUST.Items[self:GetItemID()].name, "RUST_Item_Title", 0, 0, Color(255, 165, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
        draw.SimpleTextOutlined("x" .. self:GetAmount(), "RUST_Item_Amount", 0, 48, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
	cam.End3D2D()
end
