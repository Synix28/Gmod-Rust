--[[

    Inventory - Base

]]--

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self:Receiver("RUST_Slot", function( receiver, panels, isDropped, menuIndex, mouseX, mouseY ) 
        if( isDropped )then
            RUST.DropItem(panels[1]:GetParent())
        end
    end, {} )

    self.inventory = vgui.Create("RUST_Inventory", self)
    self.armor = vgui.Create("RUST_Armor", self)
    self.crafting = vgui.Create("RUST_Crafting", self)

    if( RUST.VGUI.Hotbar && IsValid(RUST.VGUI.Hotbar) )then
        RUST.VGUI.Hotbar:SetParent(self)
    end
end

function PANEL:Paint(w, h)
end

function PANEL:OnRemove()
    if( RUST.VGUI.Hotbar && IsValid(RUST.VGUI.Hotbar) )then
        RUST.VGUI.Hotbar:SetParent(nil)
    end
end

function PANEL:OnKeyCodePressed(key)
    if( key == KEY_TAB )then
        RUST.VGUI.BasePanel:Remove()
        
        timer.Simple(0.2, function()
            RUST.VGUI.BasePanel = nil
        end)
    end
end

vgui.Register("RUST_Base", PANEL, "DPanel")