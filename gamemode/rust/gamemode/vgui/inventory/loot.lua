--[[

    Inventory - Loot

]]--

local draw = draw
local math = math
local surface = surface
local vgui = vgui
local LocalPlayer = LocalPlayer

local PANEL = {}

function PANEL:Init()
    self:SetSize(270, 435)
    self:SetPos(ScrW() / 2 + (490 / 2) + 5, ScrH() / 2 - (435 / 2))
end

function PANEL:SetInv(inv)
    self.inv = inv

    self.scroll = vgui.Create( "DScrollPanel", self )
    self.scroll:SetSize(255, 390)
    self.scroll:SetPos(10, 35)

    self.list = vgui.Create( "DIconLayout", self.scroll )
    self.list:SetSize(230, 390)
    self.list:SetSpaceY( 10 )
    self.list:SetSpaceX( 10 )

    local sbar = self.scroll:GetVBar()

    function sbar:Paint( w, h )
    end
    function sbar.btnUp:Paint( w, h )
        draw.RoundedBox( 0, 3, 0, w - 6, h, Color( 120, 120, 120, 255 ) )
    end
    function sbar.btnDown:Paint( w, h )
        draw.RoundedBox( 0, 3, 0, w - 6, h, Color( 120, 120, 120, 255 ) )
    end
    function sbar.btnGrip:Paint( w, h )
        draw.RoundedBox( 0, 3, 0, w - 6, h, Color( 167, 167, 167, 255 ) )
    end

    local invData = RUST.Inventories[self.inv].slots

    for i = 1, #invData do
        local Slot = self.list:Add( "RUST_Slot" )
        Slot:SetID( i )
        Slot:SetInv(self.inv)

        if( invData[i] ) then
            local Item = vgui.Create("RUST_Item", Slot)
            Item:SetItemID(invData[i].itemid)
            Item:SetAmount(invData[i].amount)
        end
    end
end

function PANEL:Paint(w, h)
    // -- Main

    surface.SetDrawColor(45, 45, 45, 255)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText("LOOT", "RUST_Title", 10, 17.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("RUST_Loot", PANEL, "DPanel")