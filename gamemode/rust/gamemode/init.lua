RUST = RUST || {}

// PRELOAD

DeriveGamemode("sandbox")

// LOAD

hook.Run("RUST_StartedLoading")

AddCSLuaFile("libraries/sh_pon.lua")
AddCSLuaFile("libraries/sh_netstream2.lua")

include("libraries/sh_pon.lua")
include("libraries/sh_netstream2.lua")

include("libraries/sv_mysql.lua")

local fol = GM.FolderName .. "/gamemode/config/"
local files, folders = file.Find(fol .. "*", "LUA")

for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
        AddCSLuaFile(fol .. folder .. "/" .. File)
        include(fol .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. "/sv_*.lua", "LUA"), true) do
        include(fol .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
        AddCSLuaFile(fol .. folder .. "/" .. File)
    end
end

fol = GM.FolderName .. "/gamemode/modules/"
files, folders = file.Find(fol .. "*", "LUA")

for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
        AddCSLuaFile(fol .. folder .. "/" .. File)
        include(fol .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. "/sv_*.lua", "LUA"), true) do
        include(fol .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
        AddCSLuaFile(fol .. folder .. "/" .. File)
    end
end

fol = GM.FolderName .. "/gamemode/vgui/"
files, folders = file.Find(fol .. "*", "LUA")

for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(fol .. folder .. "/*.lua", "LUA"), true) do
        AddCSLuaFile(fol .. folder .. "/" .. File)
    end
end

hook.Run("RUST_FinishedLoading")
MySQLite.initialize()