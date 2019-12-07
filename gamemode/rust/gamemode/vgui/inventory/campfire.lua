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
    self:SetSize(250, 360)
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

    for i = 1, 3 do
        local Slot = self.list:Add( "RUST_Slot" )
        Slot:SetID( i )
        Slot:SetInv(self.inv)

        if( invData[i] ) then
            local Item = vgui.Create("RUST_Item", Slot)
            Item:SetItemID(invData[i].itemid)
            Item:SetAmount(invData[i].amount)
        end
    end

    for i = 1, 3 do
        local Slot = self.list:Add( "RUST_Slot" )
        Slot:SetID( 3 + i )
        Slot:SetInv(self.inv)
        Slot:SetMiddleText("COOK")

        if( invData[3 + i] ) then
            local Item = vgui.Create("RUST_Item", Slot)
            Item:SetItemID(invData[3 + i].itemid)
            Item:SetAmount(invData[3 + i].amount)
        end
    end

    self.fireSlot = vgui.Create( "RUST_Slot", self )
    self.fireSlot:SetPos(250 / 2 - 70 - 10, 260)
    self.fireSlot:SetID( 7 )
    self.fireSlot:SetInv(self.inv)
    self.fireSlot:SetMiddleText("BURN")

    if( invData[7] ) then
        local Item = vgui.Create("RUST_Item", self.fireSlot)
        Item:SetItemID(invData[7].itemid)
        Item:SetAmount(invData[7].amount)
    end

    self.coalSlot = vgui.Create( "RUST_Slot", self )
    self.coalSlot:SetPos(250 / 2 + 10, 260)
    self.coalSlot:SetID( 8 )
    self.coalSlot:SetInv(self.inv)
    self.coalSlot:SetMiddleText("COAL")

    if( invData[8] ) then
        local Item = vgui.Create("RUST_Item", self.coalSlot)
        Item:SetItemID(invData[8].itemid)
        Item:SetAmount(invData[8].amount)
    end
end

function PANEL:OnRemove()
    netstream.Start("RUST_LootClosed")
end

PANEL.campfireIcon = Material("rust/hudicons/campfire.png")
PANEL.bloodIcon = Material("rust/hudicons/blooddrop.png")

function PANEL:Paint(w, h)
    // -- Main

    surface.SetDrawColor(45, 45, 45, 255)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText("CAMPFIRE", "RUST_Title", 10, 17.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    // -- Icons
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(self.campfireIcon)
    surface.DrawTexturedRect(w / 2 - 24, 200, 48, 48)

    surface.SetDrawColor(0, 0, 0, 255)
    surface.SetMaterial(self.bloodIcon)
    surface.DrawTexturedRect(w / 2 - 12, 260 + 35 - 12, 24, 24)
end

vgui.Register("RUST_Campfire", PANEL, "DPanel")

// ------------------------------------------------------------------

hook.Add("RUST_Update_Side_Panel_Slot", "RUST_Handle_Campfire_Update", function(create, invData, inv, slot, itemid, amount, itemData)
    if( IsValid(RUST.VGUI.BasePanel.rightPanel) && RUST.VGUI.BasePanel.rightPanel:GetName() == "RUST_Campfire" )then
        if( create )then
            if( slot >= 1 && slot <= 6 )then
                local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.rightPanel.list:GetChildren()[slot])
                Item:SetItemID(invData[slot].itemid)
                Item:SetAmount(invData[slot].amount)
            elseif( slot == 7 )then
                local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.rightPanel.fireSlot)
                Item:SetItemID(invData[slot].itemid)
                Item:SetAmount(invData[slot].amount)
            elseif( slot == 8 )then
                local Item = vgui.Create("RUST_Item", RUST.VGUI.BasePanel.rightPanel.coalSlot)
                Item:SetItemID(invData[slot].itemid)
                Item:SetAmount(invData[slot].amount)
            end
        else
            if( !invData[slot] )then
                if( slot >= 1 && slot <= 6 )then
                    RUST.VGUI.BasePanel.rightPanel.inventory.list:GetChildren()[slot]:GetChildren()[1]:Remove()
                elseif( slot == 7 )then
                    RUST.VGUI.BasePanel.rightPanel.fireSlot:GetChildren()[1]:Remove()
                elseif( slot == 8 )then
                    RUST.VGUI.BasePanel.rightPanel.coalSlot:GetChildren()[1]:Remove()
                end
            else
                if( slot >= 1 && slot <= 6 )then
                    RUST.VGUI.BasePanel.rightPanel.list:GetChildren()[slot]:GetChildren()[1]:SetAmount(invData[slot].amount)
                elseif( slot == 7 )then
                    RUST.VGUI.BasePanel.rightPanel.fireSlot:GetChildren()[1]:SetAmount(invData[slot].amount)
                elseif( slot == 8 )then
                    RUST.VGUI.BasePanel.rightPanel.coalSlot:GetChildren()[1]:SetAmount(invData[slot].amount)
                end
            end
        end
    end
end)