--[[

    Food - SV Meta

]]--

local PLAYER = FindMetaTable("Player")

function PLAYER:SetFood(amount)
    local worked = true

    if( amount > RUST_FOOD_MAX )then
        amount = RUST_FOOD_MAX
        worked = false
    elseif( amount < RUST_FOOD_MIN )then
        amount = RUST_FOOD_MIN
        worked = false
    end

    self:SetNWInt("RUST_Food", amount)

    return worked
end

function PLAYER:AddFood(amount)
    return self:SetFood(self:GetFood() + amount)
end

function PLAYER:RemoveFood(amount)
    return self:SetFood(self:GetFood() - amount) 
end