local function CreateBindMenuPanel(parent)
    local bindMenuPanel = vgui.Create("DPanel", parent)
    bindMenuPanel:SetSize(parent:GetWide(), parent:GetTall())
    bindMenuPanel.Paint = function() end

    local binds = {
        { name = "Bind 1", command = "say Ele é terrorista" },
        { name = "Bind 2", command = "" },
        { name = "Bind 3", command = "" },
    }

    local yOffset = 10
    for _, bind in ipairs(binds) do
        local bindButton = vgui.Create("DButton", bindMenuPanel)
        bindButton:SetPos(10, yOffset)
        bindButton:SetSize(bindMenuPanel:GetWide() - 20, 30)
        bindButton:SetText(bind.name)
        bindButton.DoClick = function()
            LocalPlayer():ConCommand(bind.command)
        end

        yOffset = yOffset + 40
    end

    return bindMenuPanel
end

hook.Add("TTTSettingsTabs", "AddBindMenuTab", function(dtabs)
    local bindsTab = dtabs:CreateTab("Binds")

    local bindMenuPanel = CreateBindMenuPanel(bindsTab)
    bindsTab:AddSheet("Bind Menu", bindMenuPanel, "icon16/joystick.png", false, false, "Menu de Binds")
end)