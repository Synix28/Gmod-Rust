--[[

    Inventory - Base

]]--

local draw = draw
local math = math
local surface = surface
local vgui = vgui
local LocalPlayer = LocalPlayer

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self:Receiver("RUST_Slot", function( receiver, panels, isDropped, menuIndex, mouseX, mouseY )
        if( isDropped && self:IsHovered() )then
            RUST.DropItem(panels[1]:GetParent())
        end
    end, {} )

    self.inventory = vgui.Create("RUST_Inventory", self)

    if( RUST.VGUI.Hotbar && IsValid(RUST.VGUI.Hotbar) )then
        RUST.VGUI.Hotbar:SetParent(self)
    end

    local w, _ = self:GetWide(), self:GetTall()

    self.armorButton = vgui.Create("RUST_TabButton", self)
    self.armorButton:SetPos(w / 2 - 50 - 55, 5)
    self.armorButton:SetTabText("Armor")
    self.armorButton:SetTabFunc(function(parent)
        if( !parent:CheckLeftPanel() )then
            parent:OpenArmor()
        end
    end)

    self.craftingButton = vgui.Create("RUST_TabButton", self)
    self.craftingButton:SetPos(w / 2 - 50 + 55, 5)
    self.craftingButton:SetTabText("Crafting")
    self.craftingButton:SetTabFunc(function(parent)
        if( !parent:CheckRightPanel() )then
            parent:OpenCrafting()
        end
    end)
end

function PANEL:CheckRightPanel()
    if( IsValid(self.rightPanel) )then
        self.rightPanel:Remove()
        self.rightPanel = nil

        return true
    end

    return false
end

function PANEL:CheckLeftPanel()
    if( IsValid(self.leftPanel) )then
        self.leftPanel:Remove()
        self.leftPanel = nil

        return true
    end

    return false
end

function PANEL:OpenArmor()
    self:CheckRightPanel()
    self.leftPanel = vgui.Create("RUST_Armor", self)
end

// TODO: MAKE THIS MORE DYNAMIC
// self.leftPanel && self.rightPanel

function PANEL:OpenCrafting()
    self:CheckRightPanel()
    self.rightPanel = vgui.Create("RUST_Crafting", self)
end

function PANEL:OpenLoot(inv)
    self:CheckRightPanel()
    self.rightPanel = vgui.Create("RUST_Loot", self)
    self.rightPanel:SetInv(inv)
end

function PANEL:OpenCampfire(inv)
    self:CheckRightPanel()
    self.rightPanel = vgui.Create("RUST_Campfire", self)
    self.rightPanel:SetInv(inv)
end

function PANEL:Paint(w, h)
end

function PANEL:OnRemove()
    if( RUST.VGUI.Hotbar && IsValid(RUST.VGUI.Hotbar) )then
        RUST.VGUI.Hotbar:SetParent(nil)
    end

    netstream.Start("RUST_InventoryClosed")
end

function PANEL:OnKeyCodePressed(key)
    if( key == KEY_TAB )then
        RUST.VGUI.BasePanel:Remove()

        timer.Simple(0.2, function()
            if( IsValid(RUST.VGUI.BasePanel) )then return end

            RUST.VGUI.BasePanel = nil
        end)
    end
end

vgui.Register("RUST_Base", PANEL, "DPanel")

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetSize(100, 20)
    self:SetText("")
end

function PANEL:SetTabText(text)
    self.text = text
end

function PANEL:SetTabFunc(func)
    self.func = func
end

function PANEL:Paint(w, h)
    if( !self.text )then return end

    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 0, w, h)

    if( self:IsHovered() )then
        surface.SetDrawColor(100, 100, 100, 255)
        surface.DrawRect(1, 1, w - 2, h - 2)
    else
        surface.SetDrawColor(80, 80, 80, 255)
        surface.DrawRect(1, 1, w - 2, h - 2)
    end

    draw.SimpleText(self.text, "RUST_Craft_Button_Text", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:DoClick()
    self.func(self:GetParent())
end

vgui.Register("RUST_TabButton", PANEL, "DButton")