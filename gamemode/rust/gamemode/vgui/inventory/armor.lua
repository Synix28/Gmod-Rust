--[[

    Inventory - Armor

]]--

local draw = draw
local math = math
local surface = surface
local vgui = vgui
local LocalPlayer = LocalPlayer

local PANEL = {}

function PANEL:Init()
    self:SetSize(220, 355)
    self:SetPos(ScrW() / 2 - (490 / 2) - 5 - 220, ScrH() / 2 - (435 / 2))

    self.scroll = vgui.Create( "DScrollPanel", self )
    self.scroll:SetSize(70, 310)
    self.scroll:SetPos(10, 35)

    self.list = vgui.Create( "DIconLayout", self.scroll )
    self.list:SetSize(70, 310)
    self.list:SetSpaceY( 10 )
    self.list:SetSpaceX( 10 )

    local inv = "Player_Armor_" .. LocalPlayer():SteamID()
    local invData = RUST.Inventories[inv].slots

    local types = {
        "HEAD",
        "CHEST",
        "LEGS",
        "BOOTS"
    }

    for i = 1, 4 do
        local Slot = self.list:Add( "RUST_Slot" )
        Slot:SetID( i )
        Slot:SetInv(inv)
        Slot:SetMiddleText(types[i])

        if( invData[i] ) then
            local Item = vgui.Create("RUST_Item", Slot)
            Item:SetItemID(invData[i].itemid)
            Item:SetAmount(invData[i].amount)
        end
    end
end

function PANEL:Paint(w, h)
    local ply = LocalPlayer()

    surface.SetDrawColor(45, 45, 45, 255)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText("ARMOR", "RUST_Title", 10, 17.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("EFFECTS", "RUST_Title", 150, 43, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if( ply:HasArmorEquiped() )then
        local statsData = ply:GetArmorStatsSum()

        draw.SimpleText("Bullet", "RUST_Title", 100, 43 + 40, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("+" .. statsData.bullet, "RUST_Title", 200, 43 + 40, Color(0, 255, 63, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        draw.SimpleText("Melee", "RUST_Title", 100, 43 + 60, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("+" .. statsData.melee, "RUST_Title", 200, 43 + 60, Color(0, 255, 63, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        draw.SimpleText("Explosion", "RUST_Title", 100, 43 + 80, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("+" .. statsData.explosion, "RUST_Title", 200, 43 + 80, Color(0, 255, 63, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        draw.SimpleText("Cold", "RUST_Title", 100, 43 + 100, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("+" .. statsData.cold, "RUST_Title", 200, 43 + 100, Color(0, 255, 63, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        draw.SimpleText("Radiation", "RUST_Title", 100, 43 + 120, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("+" .. statsData.radiation, "RUST_Title", 200, 43 + 120, Color(0, 255, 63, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("RUST_Armor", PANEL, "DPanel")