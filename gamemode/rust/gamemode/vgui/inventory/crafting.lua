--[[

    Inventory - Crafting

]]--

surface.CreateFont( "RUST_Crafting_Text", {
	font = "Arial",
	extended = false,
	size = 14,
	weight = 2000,
	antialias = true,
} )

surface.CreateFont( "RUST_Craft_Button_Text", {
	font = "Arial",
	extended = false,
	size = 14,
	weight = 500,
	antialias = true,
} )

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self.craftAmount = 1 // wie viele gecraftet werden sollen

    self:SetSize(250, 435)
    self:SetPos(ScrW() / 2 + (490 / 2) + 5, ScrH() / 2 - (435 / 2))

    --[[

        Crafting Recipes Display

    ]]--

    self.craftScroll = vgui.Create( "DScrollPanel", self )
    self.craftScroll:SetSize(230, 270)
    self.craftScroll:SetPos(10, 35)

    local sbar = self.craftScroll:GetVBar()

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

    for category, data in SortedPairsByMemberValue( RUST.Categories, "sort", false ) do
        local categoryPanel = self.craftScroll:Add( "RUST_Category" )
        categoryPanel:SetCategoryText(category)
        categoryPanel:Dock( TOP )
        categoryPanel:DockMargin( 0, 0, 15, 3 )

        for _, recipe in ipairs(data.recipes) do
            if( RUST.Recipes[recipe].default )then
                local craft = self.craftScroll:Add( "RUST_Craft" )
                craft:SetRecipe(recipe)
                craft:Dock( TOP )
                craft:DockMargin( 10, 0, 15, 3 )
            end
        end
    end

    --[[

        Needed Amount Display

    ]]--

    self.neededScroll = vgui.Create( "DScrollPanel", self )
    self.neededScroll:SetSize(230, 70)
    self.neededScroll:SetPos(10, 340)

    local sbar = self.neededScroll:GetVBar()

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

    self.craftButton = vgui.Create("RUST_CraftButton", self)
    self.craftButton:SetPos(170, 415)

    --[[

        Crafting

    ]]--

    self.plus = vgui.Create("RUST_CraftAmountPlus", self)
    self.plus:SetPos(150, 415)

    self.minus = vgui.Create("RUST_CraftAmountMinus", self)
    self.minus:SetPos(85, 415)
end

function PANEL:Paint(w, h)
    // -- Main

    surface.SetDrawColor(45, 45, 45, 255)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText("CRAFTING", "RUST_Title", 10, 17.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    // -- Needed Display

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(10, 315, w - 20, 20)

    draw.SimpleText("ITEMS", "RUST_Crafting_Text", 25, 325, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("NEED", "RUST_Crafting_Text", 150, 325, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("HAVE", "RUST_Crafting_Text", 210, 325, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    // -- Craft

    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(105, 415, 40, 15)

    draw.SimpleText(self.craftAmount, "RUST_Craft_Button_Text", 105 + 20, 415 + 7.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    // Crafting time

    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(10, 415, 70, 15)
end

vgui.Register("RUST_Crafting", PANEL, "DPanel")

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetTall(20)
end

function PANEL:SetCategoryText(cat)
    self.cat = cat
end

function PANEL:Paint(w, h)
    if( !self.cat )then return end

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(RUST.Categories[self.cat].name, "RUST_Crafting_Text", 10, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("RUST_Category", PANEL, "DPanel")

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetTall(20)
    self:SetText("")
end

function PANEL:SetRecipe(recipe)
    self.recipe = recipe
end

function PANEL:DoClick()
    local base = self:GetParent():GetParent():GetParent()

    base.selectedCraft = self.recipe
    base.neededScroll:Clear()

    for item, amount in pairs(RUST.Recipes[base.selectedCraft].needed) do
        local neededItem = base.neededScroll:Add("RUST_ListItem")
        neededItem:SetItemID(item)
        neededItem:SetNeededAmount(amount)
        neededItem:SetTall(18)
        neededItem:Dock( TOP )
        neededItem:DockMargin( 0, 0, 0, 0 )
    end
end

function PANEL:Paint(w, h)
    if( !self.recipe )then return end

    if( self:IsHovered() )then
        surface.SetDrawColor(80, 80, 80, 255)
        surface.DrawRect(0, 0, w, h)
    else
        surface.SetDrawColor(30, 30, 30, 255)
        surface.DrawRect(0, 0, w, h)
    end

    draw.SimpleText(RUST.Items[self.recipe].name, "RUST_Crafting_Text", 10, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("RUST_Craft", PANEL, "DButton")

// ------------------------------------------------------------------

surface.CreateFont( "Rust_List_Item_Text", {
	font = "Arial",
	extended = false,
	size = 16,
	weight = 500,
	antialias = true,
} )

local PANEL = {}

function PANEL:Init()
    self:SetTall(18)
end

function PANEL:SetItemID(itemid)
    self.itemid = itemid
end

function PANEL:SetNeededAmount(neededAmount)
    self.neededAmount = neededAmount
end

function PANEL:Paint(w, h)
    if( !self.itemid || !self.neededAmount )then return end

    local inv = LocalPlayer():GetInv()
    local haveAmount = RUST.GetItemAmountFromInv(inv, self.itemid)
    local craftFactor = self:GetParent():GetParent():GetParent().craftAmount

    draw.SimpleText(RUST.Items[self.itemid].name, "Rust_List_Item_Text", 15, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if( !haveAmount || haveAmount && haveAmount < (self.neededAmount * craftFactor) )then
        haveAmount = haveAmount || 0

        draw.SimpleText(self.neededAmount * craftFactor, "Rust_List_Item_Text", 140, h / 2, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(haveAmount, "Rust_List_Item_Text", 200, h / 2, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(self.neededAmount * craftFactor, "Rust_List_Item_Text", 140, h / 2, Color(0, 255, 63, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(haveAmount, "Rust_List_Item_Text", 200, h / 2, Color(0, 255, 63, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("RUST_ListItem", PANEL, "DPanel")

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetSize(70, 15)
    self:SetText("")
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 0, w, h)

    if( self:IsHovered() )then
        surface.SetDrawColor(100, 100, 100, 255)
        surface.DrawRect(1, 1, w - 2, h - 2)
    else
        surface.SetDrawColor(80, 80, 80, 255)
        surface.DrawRect(1, 1, w - 2, h - 2)
    end

    draw.SimpleText("Craft", "RUST_Craft_Button_Text", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:DoClick()
    LocalPlayer():EmitSound("item/sfx/craft_start.wav", 75)
end

vgui.Register("RUST_CraftButton", PANEL, "DButton")

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetSize(15, 15)
    self:SetText("")
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 0, w, h)

    if( self:IsHovered() )then
        surface.SetDrawColor(100, 100, 100, 255)
        surface.DrawRect(1, 1, w - 2, h - 2)
    else
        surface.SetDrawColor(80, 80, 80, 255)
        surface.DrawRect(1, 1, w - 2, h - 2)
    end

    draw.SimpleText("+", "RUST_Craft_Button_Text", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:DoClick()
    local parent = self:GetParent()

    if( input.IsKeyDown(KEY_LSHIFT) )then
        parent.craftAmount = parent.craftAmount + 10
    else
        parent.craftAmount = parent.craftAmount + 1
    end
end

vgui.Register("RUST_CraftAmountPlus", PANEL, "DButton")

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetSize(15, 15)
    self:SetText("")
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 0, w, h)

    if( self:IsHovered() )then
        surface.SetDrawColor(100, 100, 100, 255)
        surface.DrawRect(1, 1, w - 2, h - 2)
    else
        surface.SetDrawColor(80, 80, 80, 255)
        surface.DrawRect(1, 1, w - 2, h - 2)
    end

    draw.SimpleText("-", "RUST_Craft_Button_Text", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:DoClick()
    local parent = self:GetParent()

    if( input.IsKeyDown(KEY_LSHIFT) )then
        if( (parent.craftAmount - 10) < 1 )then
            parent.craftAmount = 1
        else
            parent.craftAmount = parent.craftAmount - 10
        end
    else
        if( (parent.craftAmount - 1) >= 1 )then
            parent.craftAmount = parent.craftAmount - 1
        end
    end
end

vgui.Register("RUST_CraftAmountMinus", PANEL, "DButton")