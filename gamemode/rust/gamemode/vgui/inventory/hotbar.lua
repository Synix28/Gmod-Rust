--[[

    Inventory - Hotbar

]]--

local draw = draw
local math = math
local surface = surface
local vgui = vgui
local LocalPlayer = LocalPlayer

local PANEL = {}

function PANEL:Init()
    self:SetSize(490, 90)
    self:SetPos(ScrW() / 2 - 245, ScrH() - 90 - 20)

    self.scroll = vgui.Create( "DScrollPanel", self )
    self.scroll:SetSize(480, 90)
    self.scroll:SetPos(10, 10)

    self.list = vgui.Create( "DIconLayout", self.scroll )
    self.list:SetSize(480, 90)
    self.list:SetSpaceY( 10 )
    self.list:SetSpaceX( 10 )

    local inv = "Player_Hotbar_" .. LocalPlayer():SteamID()
    local invData = RUST.Inventories[inv].slots

    for i = 1, 6 do
        local Slot = self.list:Add( "RUST_Slot" )
        Slot:SetID( i )
        Slot:SetInv(inv)
        Slot:SetHotbar(true)

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
end

vgui.Register("RUST_Hotbar", PANEL, "DPanel")