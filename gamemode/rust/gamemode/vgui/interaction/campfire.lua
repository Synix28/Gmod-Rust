--[[

    Interaction - Campfire

]]--

// TODO: CLOSE ON DEATH

local draw = draw
local math = math
local surface = surface
local vgui = vgui
local LocalPlayer = LocalPlayer

local PANEL = {}

function PANEL:Init()
    self:SetSize(100, 45)
    self:Center()

    self:ShowCloseButton(false)
    self:SetDraggable(false)
    
    self:MakePopup()
end

function PANEL:SetInv(inv)
    self.inv = inv

    self.open = vgui.Create("RUST_TabButton", self)
    self.open:SetPos(0, 0)
    self.open:SetTabText("Open")
    self.open:SetTabFunc(function(parent)
        local inv = parent.inv
        parent:Remove()

        if( !RUST.VGUI.BasePanel || !IsValid(RUST.VGUI.BasePanel) )then
            RUST.VGUI.BasePanel = vgui.Create("RUST_Base")
            RUST.VGUI.BasePanel:OpenArmor()
            RUST.VGUI.BasePanel:OpenCampfire(inv)
        else
            RUST.VGUI.BasePanel:OpenCampfire(inv)
        end
    end)

    self.fire = vgui.Create("RUST_TabButton", self)
    self.fire:SetPos(0, 25)

    local invData = RUST.Inventories[self.inv]
    
    if( invData.owner:GetFireOn() )then
        self.fire:SetTabText("Extinguish Fire")
    else
        self.fire:SetTabText("Light Fire")
    end

    self.fire:SetTabFunc(function(parent)
        local invData = RUST.Inventories[parent.inv]

        parent:Remove()
        netstream.Start("RUST_LootClosed")
        netstream.Start("RUST_LightFire", invData.owner)
    end)
end

function PANEL:Paint(w, h)
end

vgui.Register("RUST_Interaction_Campfire", PANEL, "DFrame")