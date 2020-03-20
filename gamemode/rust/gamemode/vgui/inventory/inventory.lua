--[[

    Inventory - Inventory

]]--

local draw = draw
local math = math
local surface = surface
local vgui = vgui
local LocalPlayer = LocalPlayer

surface.CreateFont( "RUST_Title", {
	font = "Arial",
	extended = false,
	size = 16,
	weight = 500,
	antialias = true,
} )

local PANEL = {}

function PANEL:Init()
    self:SetSize(490, 435)
    self:Center()

    self.scroll = vgui.Create( "DScrollPanel", self )
    self.scroll:SetSize(480, 400)
    self.scroll:SetPos(10, 35)

    self.list = vgui.Create( "DIconLayout", self.scroll )
    self.list:SetSize(480, 400)
    self.list:SetSpaceY( 10 )
    self.list:SetSpaceX( 10 )

    local inv = RUST.GetInventoryByID(LocalPlayer():GetInv())

    for id, slot in ipairs(inv:GetSlots()) do
        local SlotPanel = self.list:Add( "RUST_Slot" )
        SlotPanel:SetSlot(slot)

        if( slot:HasItem() ) then
            local Item = vgui.Create("RUST_Item", SlotPanel)
            Item:SetItem(slot:GetItem())
        end
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(45, 45, 45, 255)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText("INVENTORY", "RUST_Title", 10, 17.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("RUST_Inventory", PANEL, "DPanel")