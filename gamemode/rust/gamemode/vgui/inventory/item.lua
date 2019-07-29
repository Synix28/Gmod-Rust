--[[

    Inventory - Item

]]--

surface.CreateFont( "Rust_Item_Amount", {
	font = "Arial",
	extended = false,
	size = 14,
	weight = 500,
	antialias = true,
} )

local PANEL = {}

function PANEL:Init()
    self:SetSize(70, 70)
    self:Droppable("RUST_Slot")
end

function PANEL:Paint(w, h)
    if( !self.itemid || !self.amount || !self.PaintingDragging && dragndrop.IsDragging() && dragndrop.m_DraggingMain && dragndrop.m_DraggingMain == self ) then return end

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(RUST.Items[self.itemid].icon)
    surface.DrawTexturedRect(3, 3, 64, 64)

    if( RUST.Items[self.itemid].isResource )then
        draw.SimpleText("x" .. self.amount, "Rust_Item_Amount", w, h - 7, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:SetItemID(itemid)
    self.itemid = itemid
end

function PANEL:SetAmount(amount)
    self.amount = amount
end

function PANEL:OnRemove()
    if( self.menu && IsValid(self.menu) )then
        self.menu:Remove()
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
    local itemData = RUST.Items[self.itemid]

    if( itemData.isResource )then
        self.menu = DermaMenu()
        self.menu:AddOption( "Split", function() 
            RUST.Split(self:GetParent())
        end )

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