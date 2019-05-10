--[[

    CL INVENTORY

]]--

RUST.Inventory.Panel = RUST.Inventory.Gui || {}

function GM:ScoreboardShow()
    RUST.Inventory.OpenMenu()
end

function RUST.Inventory.OpenMenu()
    RUST.Inventory.Panel.Inv = vgui.Create("Inv_Base")

    local invPanel = vgui.Create("Inv_Inventory", RUST.Inventory.Panel.Inv)
    invPanel:SetSize(490, 445)
    invPanel:Center()
    invPanel:MakePopup()
end