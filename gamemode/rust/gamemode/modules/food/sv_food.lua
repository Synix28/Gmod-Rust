--[[

    Food - SV

]]--

if( !timer.Exists("RUST_Food_Decay") )then
    timer.Create("RUST_Food_Decay", 2, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            if( !ply:Alive() )then continue end

            if( ply:GetVelocity():Length() > 5 )then
                local amountToRemove = 0

                if( ply:IsSprinting() )then
                    amountToRemove = 15
                else
                    amountToRemove = 5
                end

                ply:RemoveFood(amountToRemove)
            end

            if( ply:GetFood() <= RUST_FOOD_MIN )then
                ply:TakeDamage(25, ply, ply)
            end
        end
    end)
end