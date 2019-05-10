--[[

    VGUI INVENTORY - INVENTORY

]]--

local PANEL = {}

function PANEL:Init()
    self:SetTitle("Inventory")

    local Scroll = vgui.Create( "DScrollPanel", self )
    Scroll:SetPos(10, 45)
    Scroll:SetSize(480, 400)

    local List = vgui.Create( "DIconLayout", Scroll )
    List:Dock( FILL )
    List:SetSpaceY( 10 )
    List:SetSpaceX( 10 )

    for i = 1, 30 do 
        local Slot = List:Add( "DPanel" ) 
        Slot:SetSize( 70, 70 )
        Slot.Paint = function(sel, w, h)
            surface.SetDrawColor(40, 40, 40, 255)
            surface.DrawRect(0, 0, w, h)
        end
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(55, 55, 55, 255)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("Inv_Inventory", PANEL, "DFrame")