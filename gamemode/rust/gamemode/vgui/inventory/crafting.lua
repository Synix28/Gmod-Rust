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

// ------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetSize(250, 435)
    self:SetPos(ScrW() / 2 + (490 / 2) + 5, ScrH() / 2 - (435 / 2))

    self.scroll = vgui.Create( "DScrollPanel", self )
    self.scroll:SetSize(230, 290)
    self.scroll:SetPos(10, 35)

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

    for category, data in SortedPairsByMemberValue( RUST.Categories, "sort", false ) do
        local categoryPanel = self.scroll:Add( "RUST_Category" )
        categoryPanel:SetCategoryText(category)
        categoryPanel:Dock( TOP )
        categoryPanel:DockMargin( 0, 0, 15, 3 )

        for _, recipe in ipairs(data.recipes) do
            if( RUST.Recipes[recipe].default )then
                local craft = self.scroll:Add( "RUST_Craft" )
                craft:SetRecipe(recipe)
                craft:Dock( TOP )
                craft:DockMargin( 10, 0, 15, 3 )
            end
        end
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(45, 45, 45, 255)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText("CRAFTING", "RUST_Title", 10, 17.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(10, 335, w - 20, 20)

    draw.SimpleText("ITEMS", "RUST_Crafting_Text", 25, 345, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("NEED", "RUST_Crafting_Text", 150, 345, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("HAVE", "RUST_Crafting_Text", 195, 345, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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