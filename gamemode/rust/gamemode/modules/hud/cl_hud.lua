RUST.HUD = {}
local HUD = {}
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- TODO:
-- Max FOOD einstellen. Wo?
-- line 77 die 100 (Letzte variable)


--[[-------------------------------------------------------------------------
Fonts
---------------------------------------------------------------------------]]
surface.CreateFont("RustHUD", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 550,
})

--[[-------------------------------------------------------------------------
Disable the old HUD
---------------------------------------------------------------------------]]
HUD.Dont = {
CHudHealth = true,
CHudBattery = true,
}
hook.Add("HUDShouldDraw", "WegMitDemMüll", function(name)
	if HUD.Dont[name] then return false end
end)

--[[-------------------------------------------------------------------------
Draw Background Text + Text
---------------------------------------------------------------------------]]
function draw.BackgroundText(text, font, w, h, color, ww, hh)
	if not ww then ww = false end
	if not hh then hh = false end
	draw.SimpleText(text, font, w+1, h+1, Color(0,0,0), ww, hh)
	draw.SimpleText(text, font, w, h, color, ww, hh)
end

--[[-------------------------------------------------------------------------
Format Bar (Wie lang det Ding ist und so)
---------------------------------------------------------------------------]]
function HUD:FormatBar(bar, val, max)
	local endbar = bar/max * val
	if endbar > bar then
		return bar
	else
		return endbar 
	end
end

--[[-------------------------------------------------------------------------
Draws HP Bar
---------------------------------------------------------------------------]]
-- Lerp Var
local hp = 0
-- Bei Erststart warf LocalPlayer() einen Error also loope ich nun durch, bis der LocalPlayer() verfügbar ist.
local function LocalPlayerTimer()
	if IsValid(LocalPlayer()) then
		hp = LocalPlayer():GetMaxHealth()
	else
		timer.Simple(0.5, function()
			LocalPlayerTimer()
		end)
	end
end
LocalPlayerTimer()

function HUD:HP(icon, w, h, var, color, tw, th, typ)
	draw.BackgroundText(typ, "RustHUD", tw, th, Color(255,255,255))
	draw.RoundedBox(0,w,h, 110, 20, Color(0,0,0))

	local hhp = self:FormatBar(107, var, LocalPlayer():GetMaxHealth())
	hp = Lerp(FrameTime(), hp, hhp)--LocalPlayer():Health())

	draw.RoundedBox(0,w+2,h+2,hp,16,color)
	draw.BackgroundText(var, "RustHUD", w+55, h+10, Color(255,255,255), 1, 1)
end

--[[-------------------------------------------------------------------------
Draws Food Bar
---------------------------------------------------------------------------]]
-- Lerp Var
local lfood = 0
function HUD:FOOD(icon, w, h, var, color, tw, th, typ)
	draw.BackgroundText(typ, "RustHUD", tw, th, Color(255,255,255))
	draw.RoundedBox(0,w,h, 110, 20, Color(0,0,0))

	local ffood = self:FormatBar(107, var, 2500)
	lfood = Lerp(FrameTime(), lfood, ffood)--LocalPlayer():Health())

	draw.RoundedBox(0,w+2,h+2,lfood,16,color)
	draw.BackgroundText(var, "RustHUD", w+55, h+10, Color(255,255,255), 1, 1)
end

--[[-------------------------------------------------------------------------
Draws Universal
---------------------------------------------------------------------------]]
function HUD:UNIVERSAL(icon, w, h, var, color, tw, th, typ)
	draw.BackgroundText(typ, "RustHUD", tw, th, Color(255,255,255))

	local form = self:FormatBar(107, var, LocalPlayer():GetMaxHealth())

	draw.BackgroundText(var, "RustHUD", w+55, h+10, Color(255,255,255), 1, 1)
end

--[[-------------------------------------------------------------------------
Do The HUD
---------------------------------------------------------------------------]]
function HUD:DrawTheHUD()
	-- Colors
	local grey = Color(45,45,45)
	local grey2 = Color(30,30,30)

	-- Resolution things
	local w, h = ScrW(), ScrH()
	local bw, bh = 200,100
	local mw, mh = bw+40, bh+10

	-- Vars
	local ply = LocalPlayer()
	local food = ply:GetNWInt("rust_food", 0)
	local radiation = ply:GetNWInt("rust_radiation", 0)

	-- Basepanel
	draw.RoundedBox(0,w-mw,h-mh,bw,bh,grey)

	-- Health
	self:HP(false, w-mw+80, h-mh+10, ply:Health(), Color(50,290,50), w-mw+7, h-mh+10, "HEALTH")

	-- Food
	self:FOOD(false, w-mw+80, h-mh+10+30, food, Color(130,93,5), w-mw+7, h-mh+10+30, "FOOD", lfood, 100, "food")

	-- Radiation
	self:UNIVERSAL(false, w-mw+80, h-mh+10+60, radiation, Color(50,200,50), w-mw+7, h-mh+10+60, "RADS", lfood, 100, "food")
end
hook.Add("HUDPaint", "DoTheFuckingHUDDude", function() HUD:DrawTheHUD() end)

RUST.HUD = HUD