--[[-------------------------------------------------------------------------
Init Language
---------------------------------------------------------------------------]]
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- TODO:
-- Selected Lang in Config packen
-- var selected_Lang in line 31 zu config var changen line 29 entfernen
RUST.Lang = {}
Lang = RUST.Lang
Lang.Lang = {}
function Lang:AddLang(data)
	if !data || !data.Name || !data.Short || !data.Lang then 
		if data.Short != nil then
			print("RUST ERROR | Config mistake! Language '"..data.Short.."' is invalid!")
		elseif data.Name != nil then 
			print("RUST ERROR | Config mistake! Language '"..data.Name.."' is invalid!")
		else
			print("RUST ERROR | Unknown language mistake!")
		end
	return end
	Lang.Lang[data.Short] = {data.Name, data.Lang}
end

--[[-------------------------------------------------------------------------
Load Language
---------------------------------------------------------------------------]]
local fol = GM.FolderName .. "/gamemode/config/language/"
local files, folders = file.Find(fol .. "*", "LUA")
for _, File in SortedPairs(file.Find(fol .."*.lua", "LUA"), true) do
    AddCSLuaFile(fol..File)
    include(fol..File)
end

--[[-------------------------------------------------------------------------
Get a single Phrase
---------------------------------------------------------------------------]]
local sel = "DE"
function _Lang(typ)
	local selected_Lang = sel
	local lang = RUST.Lang.Lang[selected_Lang][2][typ]
	if lang != nil then
		return lang 
	else
		return "Language Error!"
	end
end

RUST.Lang = Lang