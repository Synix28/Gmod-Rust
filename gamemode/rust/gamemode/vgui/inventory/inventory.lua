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

    local inv = "Player_Inv_" .. LocalPlayer():SteamID()
    local invData = RUST.Inventories[inv].slots

    for i = 1, 30 do
        local Slot = self.list:Add( "RUST_Slot" )
        Slot:SetID( i )
        Slot:SetInv(inv)

        if( invData[i] ) then
            local Item = vgui.Create("RUST_Item", Slot)
            Item:SetItemID(invData[i].itemid)
            Item:SetAmount(invData[i].amount)
        end
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(45, 45, 45, 255)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText("INVENTORY", "RUST_Title", 10, 17.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("RUST_Inventory", PANEL, "DPanel")