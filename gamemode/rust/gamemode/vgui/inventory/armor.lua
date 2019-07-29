--[[

    Inventory - Armor

]]--

local PANEL = {}

function PANEL:Init()
    self:SetSize(200, 355)
    self:SetPos(ScrW() / 2 - (490 / 2) - 5 - 200, ScrH() / 2 - (435 / 2))

    self.scroll = vgui.Create( "DScrollPanel", self )
    self.scroll:SetSize(70, 310)
    self.scroll:SetPos(10, 35)

    self.list = vgui.Create( "DIconLayout", self.scroll )
    self.list:SetSize(70, 310)
    self.list:SetSpaceY( 10 )
    self.list:SetSpaceX( 10 )

    local inv = "Player_Armor_" .. LocalPlayer():SteamID()
    local invData = RUST.Inventories[inv].slots

    for i = 1, 4 do
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

    draw.SimpleText("ARMOR", "RUST_Title", 10, 17.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("RUST_Armor", PANEL, "DPanel")