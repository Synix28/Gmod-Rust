--[[

    Inventory - Item

]]--

local draw = draw
local math = math
local surface = surface
local vgui = vgui
local LocalPlayer = LocalPlayer

surface.CreateFont( "Rust_Item_Amount", {
	font = "Arial",
	extended = false,
	size = 14,
	weight = 500,
	antialias = true,
} )

surface.CreateFont( "Rust_Tooltip_Title", {
	font = "Arial",
	extended = false,
	size = 18,
	weight = 550,
	antialias = true,
} )

surface.CreateFont( "Rust_Tooltip_Desc", {
	font = "Arial",
	extended = false,
	size = 14,
	weight = 800,
	antialias = true,
} )

surface.CreateFont( "Rust_Tooltip_Desc_Text", {
	font = "Arial",
	extended = false,
	size = 12,
	weight = 500,
	antialias = true,
} )

local PANEL = {}

function PANEL:Init()
    self:SetSize(70, 70)
    self:Droppable("RUST_Slot")
end

function PANEL:Paint(w, h)
    local item = self:GetItem()

    if( !item || !item:GetItemID() || !item:GetAmount() || !self.PaintingDragging && dragndrop.IsDragging() && dragndrop.m_DraggingMain && dragndrop.m_DraggingMain == self ) then return end

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(RUST.Items[item:GetItemID()].icon)
    surface.DrawTexturedRect(3, 3, 64, 64)

    if( RUST.Items[item:GetItemID()].isResource || RUST.Items[item:GetItemID()].isAmmo || RUST.Items[item:GetItemID()].isFood )then
        draw.SimpleText("x" .. item:GetAmount(), "Rust_Item_Amount", w, h - 7, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    if( RUST.Items[item:GetItemID()].isWeapon )then
        local slot = self:GetParent()

        if( slot )then
            local slotData = item:GetSlot()

            if( slotData && slotData:GetItemData() && slotData:GetItemData().clip )then
                draw.SimpleText(slotData:GetItemData().clip, "Rust_Item_Amount", w, h - 7, Color(255, 165, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
        end
    end

    if( self:IsHovered() && ( !self.tooltip || !IsValid(self.tooltip) ) )then
        self.tooltip = vgui.Create("RUST_Tooltip")
        self.tooltip:SetPos(gui.MouseX() + 30, gui.MouseY())
        self.tooltip:SetItem(item)
        self.tooltip:MakePopup()
        self.tooltip:MoveToFront()
    elseif( self:IsHovered() && self.tooltip && IsValid(self.tooltip) )then
        self.tooltip:SetPos(gui.MouseX() + 30, gui.MouseY())
        self.tooltip:MoveToFront()
    elseif( !self:IsHovered() && self.tooltip && IsValid(self.tooltip) )then
        self.tooltip:Remove()
        self.tooltip = nil
    end

    if( self.menu && IsValid(self.menu) )then
        self.menu:MoveToFront()
    end
end

function PANEL:SetItem(item)
    self.item = item
end

function PANEL:GetItem()
    return self.item
end

function PANEL:OnRemove()
    if( self.menu && IsValid(self.menu) )then
        self.menu:Remove()
    end

    if( self.tooltip && IsValid(self.tooltip) )then
        self.tooltip:Remove()
    end
end

local oldOnMousePressed = baseclass.Get("DPanel").OnMousePressed

function PANEL:OnMousePressed(key)
    if( key == MOUSE_RIGHT )then
        self:OpenOptions()
    end

    oldOnMousePressed(self, key)
end

function PANEL:OpenOptions()
    local item = self:GetItem()
    local itemData = RUST.Items[item:GetItemID()]

    if( itemData.isResource || itemData.isAmmo )then
        self.menu = DermaMenu()
        self.menu:AddOption( "Split", function()
            RUST.Split(self:GetParent())
        end )

        self.menu:AddOption( "Drop", function()
            RUST.DropItem(self:GetParent())
        end )

        self.menu:Open()
    elseif( itemData.isFood )then
        self.menu = DermaMenu()
        self.menu:AddOption( "Eat", function()
            RUST.Eat(self:GetParent())
        end )

        self.menu:AddOption( "Split", function()
            RUST.Split(self:GetParent())
        end )

        self.menu:AddOption( "Drop", function()
            RUST.DropItem(self:GetParent())
        end )

        self.menu:Open()
    elseif( itemData.isWeapon && !itemData.isBow )then
        self.menu = DermaMenu()
        self.menu:AddOption( "Unload", function()
            RUST.Unload(self:GetParent())
        end )

        self.menu:AddOption( "Drop", function()
            RUST.DropItem(self:GetParent())
        end )

        self.menu:Open()
    else
        self.menu = DermaMenu()
        self.menu:AddOption( "Drop", function()
            RUST.DropItem(self:GetParent())
        end )

        self.menu:Open()
    end
end

vgui.Register("RUST_Item", PANEL, "DPanel")

// ------------------------------------------------------------------

hook.Add( "DrawOverlay", "DragNDropPaint", function()
	if ( dragndrop.m_Dragging == nil ) then return end
	if ( dragndrop.m_DraggingMain == nil ) then return end
	if ( IsValid( dragndrop.m_DropMenu ) ) then return end

	local hold_offset_x = 2048
	local hold_offset_y = 2048

	-- Find the top, left most panel
	for k, v in pairs( dragndrop.m_Dragging ) do

		if ( !IsValid( v ) ) then continue end

		hold_offset_x = math.min( hold_offset_x, v.x )
		hold_offset_y = math.min( hold_offset_y, v.y )

	end

	DisableClipping( true )

    local ox = gui.MouseX() - hold_offset_x + 8
    local oy = gui.MouseY() - hold_offset_y + 8

    for k, v in pairs( dragndrop.m_Dragging ) do

        if ( !IsValid( v ) ) then continue end

        local dist = 512 - v:Distance( dragndrop.m_DraggingMain )

        if ( dist < 0 ) then continue end

        v.PaintingDragging = true
        v:PaintAt( ox + v.x - v:GetWide() / 2, oy + v.y - v:GetTall() / 2 ) // fill the gap between the top left corner and the mouse position
        v.PaintingDragging = nil

    end

	DisableClipping( false )
end )

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetSize(205, 125)
end

function PANEL:SetItem(item)
    self.item = item
end

function PANEL:GetItem()
    return self.item
end

function PANEL:Paint(w, h)
    local item = self:GetItem()

    if( !item || !item:GetItemID() || !item:GetAmount() )then return end

    local itemData = RUST.Items[item:GetItemID()]

    surface.SetDrawColor(25, 25, 25, 255)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(itemData.icon)
    surface.DrawTexturedRect(5, 5, 64, 64)

    draw.SimpleText(itemData.name, "Rust_Tooltip_Title", 76.5 + ( 124 / 2 ), 5 + 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Description:", "Rust_Tooltip_Desc", 10, 84, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    draw.SimpleText("Epic Beschreibung!", "Rust_Tooltip_Desc_Text", 10, 105, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:OnKeyCodePressed(key)
    if( key == KEY_TAB )then
        self:Remove()
        RUST.VGUI.BasePanel:Remove()

        timer.Simple(0.2, function()
            RUST.VGUI.BasePanel = nil
        end)
    end
end

vgui.Register("RUST_Tooltip", PANEL, "DPanel")