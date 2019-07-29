--[[

    Inventory - Slot

]]--

local PANEL = {}

function PANEL:Init()
    self:SetSize(70, 70)
    self:Receiver("RUST_Slot", function( receiver, panels, isDropped, menuIndex, mouseX, mouseY ) 
        if( isDropped )then
            RUST.MoveItem(panels[1]:GetParent(), self)
        end
    end, {} )
end

function PANEL:Paint(w, h)
    if( self:IsHovered() || ( self:GetChildren()[1] && self:GetChildren()[1]:IsHovered() ) ) then
        surface.SetDrawColor(60, 60, 60, 255)
        surface.DrawRect(0, 0, w, h)
    else
        surface.SetDrawColor(30, 30, 30, 255)
        surface.DrawRect(0, 0, w, h)
    end

    if( self.ishotbar )then
        draw.SimpleText(self.id, "Rust_Item_Amount", 4, 7, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:SetID(id)
    self.id = id
end

function PANEL:SetInv(inv)
    self.inv = inv
end

function PANEL:SetHotbar(ishotbar)
    self.ishotbar = ishotbar
end

vgui.Register("RUST_Slot", PANEL, "DPanel")