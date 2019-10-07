--[[

    Resources - SV

]]--

RUST.ResourceLocations = RUST.ResourceLocations || {}

hook.Add("DatabaseInitialized", "RUST_Resources_InitDB", function() // Tables erstellen
    MySQLite.query([[
        CREATE TABLE IF NOT EXISTS resources_pos
        (
            x decimal(10, 5),
            y decimal(10, 5),
            z decimal(10, 5),

            pitch decimal(10, 5),
            yaw decimal(10, 5),
            roll decimal(10, 5)
        )
    ]])

    RUST.LoadResourceLocations()
end)

/*
hook.Add("InitPostEntity", "RUST_SpawnAllResources", function()
    timer.Create("RUST_Check_Locations", 1, 0, function()
        if( RUST.LoadedLocations )then
            RUST.SpawnAllResources()

            timer.Remove("RUST_Check_Locations")
        end
    end)
end)
*/

concommand.Add("rust_savelocations", function()
    RUST.SaveResourceLocations()
end)

// ------------------------------------------------------------------

local shouldFind = {
    ["rust_rock_metal"] = true,
    ["rust_rock_stone"] = true,
    ["rust_rock_sulfur"] = true,
    ["rust_woodpile"] = true
}

local resourceEnts = {
    "rust_rock_metal",
    "rust_rock_stone",
    "rust_rock_sulfur",
    "rust_woodpile"
}

function RUST.SaveResourceLocations()
    MySQLite.query("DELETE FROM resources_pos")

    RUST.ResourceLocations = {}

    for k, ent in ipairs(ents.FindByClass("rust_*")) do
        if( shouldFind[ent:GetClass()] )then
            local pos = ent:GetPos()
            local angle = ent:GetAngles()

            ent:Remove()

            local _ent = ents.Create(resourceEnts[math.random(1, #resourceEnts)])
            _ent:SetPos(pos)
            _ent:SetAngles(angle)
            _ent:Spawn()

            RUST.ResourceLocations[#RUST.ResourceLocations + 1] = {
                pos = pos,
                angle = angle,
                ent = _ent
            }

            MySQLite.query("INSERT INTO resources_pos VALUES( " .. pos.x ..", " .. pos.y ..", " .. pos.z ..", " .. angle.x ..", " .. angle.y ..", " .. angle.z .." )")
        end
    end
end

function RUST.LoadResourceLocations()
    if( #RUST.ResourceLocations > 0 )then
        for k, posInfo in ipairs(RUST.ResourceLocations) do
            if( posInfo.ent && IsValid(posInfo.ent) )then
                posInfo.ent:Remove()
            end
        end
    end

    RUST.ResourceLocations = {}

    MySQLite.query("SELECT * FROM resources_pos", function(data)
        if( data && data[1] )then
            for k, posInfo in ipairs(data) do
                RUST.ResourceLocations[#RUST.ResourceLocations + 1] = {
                    pos = Vector(posInfo.x, posInfo.y, posInfo.z),
                    angle = Angle(posInfo.pitch, posInfo.yaw, posInfo.roll),
                    ent = false
                }
            end

            RUST.SpawnAllResources()
        end
    end)
end

function RUST.SpawnAllResources()
    for k, posInfo in ipairs(RUST.ResourceLocations) do
        if( RUST.isEmpty(posInfo.pos) )then
            local ent = ents.Create(resourceEnts[math.random(1, #resourceEnts)])
            ent:SetPos(posInfo.pos)
            ent:SetAngles(posInfo.angle)
            ent:Spawn()

            RUST.ResourceLocations[k].ent = ent
        end
    end
end

// ------------------------------------------------------------------

function RUST.isEmpty(vector, ignore)
    ignore = ignore or {}

    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not table.HasValue(ignore, v) then
            b = false
            break
        end
    end

    return a and b
end