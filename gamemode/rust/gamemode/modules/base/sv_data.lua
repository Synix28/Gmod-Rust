--[[

    Base - SV Data

]]--

hook.Add("DatabaseInitialized", "RUST_DBInit", function()
    print("-----------------------")
    print("-- RUST DB CONNECTED --")
    print("-----------------------")
end)