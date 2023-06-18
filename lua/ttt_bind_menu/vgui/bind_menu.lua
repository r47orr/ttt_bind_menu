

local function CreateBindMenuPanel(parent)
    local bindMenuPanel = vgui.Create("DPanel", parent)
    bindMenuPanel:SetSize(parent:GetWide(), parent:GetTall())
    bindMenuPanel.Paint = function() end

    local binds = {

        { name = "Menu de mensagens rápidas", command = "+zoom", default = "b" },
        { name = "Menu de compras", command = "+menu_context", default = "c" },
        { name = "Menu do ULX", command = "ulx menu", default = "" },
        { name = "Usar chat de voz", command = "+voicerecord", default = "x" },
        { name = "Usar chat de voz de time", command = "+speed", default = "shift" },
        { name = "Usar spray", command = "impulse 201", default = "t" },
        { name = "Acionar lanterna", command = "impulse 101", default = "f" },
        { name = "Opções do TTT", command = "gm_showhelp", default = "f1" },
        { name = "Alternar mudo", command = "gm_showteam", default = "f2" },
        { name = "Menu de sugestões", command = "suggestions_menu", default = "f3" },
        { name = "Placar do SpecDM", command = "specmd_scoreboards", default = "f7" },
        { name = "RDM Manager", command = "rdmmanager", default = "f8" },
        { name = "Placar de líderes do servidor", command = "rank", default = "f9" }

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


local function createBind(bind_object)

    return

end

local function addBinds(bind_table)

    return 

    for k, v in ipairs(bind_table) do

        return
    end
end 

hook.Add("TTTSettingsTabs", "AddBindMenuTab", function(dtabs)
    local bindsTab = dtabs:CreateTab("Binds")

    local bindMenuPanel = CreateBindMenuPanel(bindsTab)
    bindsTab:AddSheet("Bind Menu", bindMenuPanel, "icon16/joystick.png", false, false, "Menu de Binds")
    
end)