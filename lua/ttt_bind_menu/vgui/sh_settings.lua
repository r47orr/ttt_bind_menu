if RayHUDTTT then return end

local allowed_ranks = TTTBindMenu.config:FetchSingle('choice_allowed_ranks')
local config_ranks = TTTBindMenu.config:FetchSingle('config_allowed_ranks')
local binds = {}

function GetAimedPlayer(ply)
    local trace = util.TraceLine({
        start = ply:GetShootPos(), -- Obtém a posição de onde o jogador está mirando
        endpos = ply:GetShootPos() + ply:GetAimVector() * 10000, -- Define a posição final da linha
        filter = ply -- Filtra o próprio jogador
    })

    if trace.Hit and trace.Entity:IsPlayer() then
        return trace.Entity -- Retorna o jogador mirado
    end

    return nil -- Retorna nil se nenhum jogador for mirado
end

hook.Add("PlayerBindPress", "CheckAimedPlayer", function(ply,bind,pressed, key)
    if key == 45 then
        local aimedPlayer = ply:GetEyeTrace().Entity 
      if IsValid(aimedPlayer) and aimedPlayer:IsPlayer() then
        local playerName = aimedPlayer:Nick()
        RunConsoleCommand("say", playerName .. " está sendo mirado!")
      else
          print("Nenhum jogador mirado.")
      end
  end

end)




hook.Add("TTTSettingsTabs", "TTTBindsMenuSettingsTabInitialize", function(dtabs)

    local function CreateRow(parent)
        local row = vgui.Create("DPanel", parent)
        row:Dock(TOP)
        row:SetTall(50) -- Defina a altura desejada da linha aqui
        row:DockMargin(5,5,5,5)
        row.Paint = function(self, w, h)
            -- Desenhe um fundo branco
            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, 0, w, h)
        end
    
        -- Função para adicionar elementos à linha
        function row:AddElement(element)
            element:SetParent(row)
            element:Dock(LEFT)
            element:DockMargin(5, 5, 5, 5) -- Margem entre os elementos
        end
    
        return row
    end

    -- Função para criar um botão para definição de tecla
local function CreateKeybindButton(parent, buttonText)
    local button = vgui.Create("DButton", parent)
    button:SetText(buttonText)
    button:SetSize(200, 40) -- Defina o tamanho desejado do botão

    -- Função para capturar a tecla pressionada
    button.DoClick = function()
        button:SetText("Pressione uma tecla...")
        button:RequestFocus()
        button.CaptureNextKey = true
    end

    function button:OnKeyCodePressed(key)
        if self.CaptureNextKey then
            self:SetText(string.upper(input.GetKeyName(key)))
            self.CaptureNextKey = false
        end
    end

    return button
end

local function SaveSettings()
    -- Lógica para salvar as configurações aqui
end

local function EditSettings()
    -- Lógica para editar as configurações aqui
end

local function deleteSettings()
    -- Lógica para editar as configurações aqui
end



    if (!allowed_ranks[LocalPlayer():GetUserGroup()] and !config_ranks[LocalPlayer():GetUserGroup()]) then return end


    local tab = vgui.Create( "DPanel", dtabs )
    tab:Dock(FILL)
    tab:SetBackgroundColor(Color(0, 0, 0, 0))

    local panel1scroll = vgui.Create("DScrollPanel", tab)
    panel1scroll:Dock(FILL)

    
    
   

    local function AddRow(panel, bind, key)

        -- if bind == nil and binds[key] == nil then return end

        local row = CreateRow(panel1scroll)
        local dropdown = vgui.Create("DComboBox", row)
        dropdown:SetSize(100, 20) -- Defina o tamanho desejado do dropdown menu
        dropdown:AddChoice("Player")
        dropdown:AddChoice("Eu")
        dropdown:AddChoice("Chat")
        dropdown:ChooseOptionID(1)
    
        dropdown.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(200, 200, 200))
        
        end
        row:AddElement(dropdown)
    
        local textField = vgui.Create("DTextEntry", row)
        textField:SetSize(200, 20) -- Defina o tamanho desejado do campo de texto
        textField:SetTextColor(Color(0, 0, 0))
    
        
        row:AddElement(textField)
    
        local spacerPanel = vgui.Create("DPanel", row)
        spacerPanel:SetBackgroundColor(Color(0, 0, 0, 0))
        spacerPanel:Dock(FILL)
        
        -- Adicionando um botão para definição de tecla à linha
        local keybindButton = nil

        if bind == nil then
            keybindButton = CreateKeybindButton(spacerPanel, "Definir Tecla");

        else
            keybindButton = CreateKeybindButton(spacerPanel, string.upper(key))
            textField:SetValue(bind)
            textField:SetEditable(false)
            keybindButton.DoCLick = function() return end 
            textField:SetTextColor(Color(150, 150, 150))
        end
        
        keybindButton:Dock(FILL)
        keybindButton:DockMargin(5, 5, 5, 5)

        -- Adicionando botões "Salvar" e "Editar" na mesma linha
        local saveButton = vgui.Create("DButton", row)
        saveButton:SetText("Excluir")
        saveButton:SetSize(50, 20)
        saveButton:Dock(RIGHT)
        saveButton:DockMargin(5, 5, 5, 5)
        saveButton.DoClick = function ()

        end
    
        -- Adicionando botões "Salvar" e "Editar" na mesma linha
        local saveButton = vgui.Create("DButton", row)
        saveButton:SetText("Salvar")
        saveButton:SetSize(50, 20)
        saveButton:Dock(RIGHT)
        saveButton:DockMargin(5, 5, 5, 5)
        saveButton.DoClick = function ()
            textField:SetTextColor(Color(150, 150, 150))
            textField:SetEditable(false)
        end
    
        local editButton = vgui.Create("DButton", row)
        editButton:SetText("Editar")
        editButton:SetSize(50, 20)
        editButton:Dock(RIGHT)
        editButton:DockMargin(5, 5, 5, 5)
        editButton.DoClick = function ()
            textField:SetEditable(true)
            textField:SetTextColor(Color(0, 0, 0))
        end
    end

    local function ListBinds(panel1scroll)
    
     
        -- Executa o comando e armazena os binds na tabela
        for i = 1, 159 do
            local key = input.GetKeyName(i)
            local bind = input.LookupKeyBinding(i)
    
            if bind and bind ~= "" then
                binds[key] = bind
                AddRow(panel1scroll,bind,key)
            end
        end
    
    end

    ListBinds(panel1scroll)

    local addButton = vgui.Create("DButton", tab)
    addButton:SetText("Adicionar Linha")
    addButton:Dock(BOTTOM)
    addButton:DockMargin(5, 5, 5, 5)
    addButton.DoClick = function()
        AddRow(panel1scroll, nil,nil)
    end

    dtabs:AddSheet("Bind", tab , "icon16/award_star_add.png")

end)

