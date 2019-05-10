RUST = RUST || {}

// PRELOAD

DeriveGamemode("sandbox")

// LOAD

hook.Run("RUST_StartedLoading")

include("libraries/sh_pon.lua")
include("libraries/sh_netstream2.lua")

local root = GM.FolderName .. "/gamemode/config/"
local _, folders = file.Find(root .. "*", "LUA")

for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
        include(root .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
        include(root .. folder .. "/" .. File)
    end
end

root = GM.FolderName .. "/gamemode/modules/"
_, folders = file.Find(root .. "*", "LUA")

for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
        include(root .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
        include(root .. folder .. "/" .. File)
    end
end

root = GM.FolderName .. "/gamemode/vgui/"
_, folders = file.Find(root .. "*", "LUA")

for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(root .. folder .. "/*.lua", "LUA"), true) do
        include(root .. folder .. "/" .. File)
    end
end

hook.Run("RUST_FinishedLoading")