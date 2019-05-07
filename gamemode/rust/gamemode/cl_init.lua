RUST = RUST || {}

RUST.debug = true

// PRELOAD

DeriveGamemode("sandbox")

// LOAD

hook.Run("RUST_StartedLoading")

if ( CLIENT ) then
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
end

if ( CLIENT ) then
    local root = GM.FolderName .. "/gamemode/modules/"
    local _, folders = file.Find(root .. "*", "LUA")

    for _, folder in SortedPairs(folders, true) do
        for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
            include(root .. folder .. "/" .. File)
        end

        for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
            include(root .. folder .. "/" .. File)
        end
    end
end

hook.Run("RUST_FinishedLoading")