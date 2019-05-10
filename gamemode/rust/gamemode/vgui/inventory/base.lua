--[[

    VGUI INVENTORY - BASE

]]--

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())

    self:Receiver("Slot", function( receiver, panels, isDropped, menuIndex, mouseX, mouseY ) 
        if (isDropped) then
            print(panels[0]) // TODO
        end
    end, {})
end

function PANEL:Paint(w, h)
end

vgui.Register("Inv_Base", PANEL, "Panel")