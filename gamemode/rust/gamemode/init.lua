RUST = RUST || {}

RUST.debug = true

// PRELOAD

DeriveGamemode("sandbox")

// LOAD

hook.Run("RUST_StartedLoading")

if( SERVER ) then
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
end

if( SERVER ) then
    local fol = GM.FolderName .. "/gamemode/modules/"
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
end

hook.Run("RUST_FinishedLoading")