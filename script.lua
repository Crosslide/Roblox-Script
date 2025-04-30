local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚽Soccer League Script⚽",
   Icon = 0,
   LoadingTitle = "Soccer League",
   LoadingSubtitle = "by Crosslide",
   Theme = "Amethyst",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- Pestaña de Velocidad
local speedTab = Window:CreateTab("Velocidad", 0)

-- Configuración inicial
local speedMultiplier = 2
local isSpeedActive = false
local defaultWalkSpeed = 16

-- Variables de referencia del jugador
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Función para actualizar las referencias cuando el personaje respawnea
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end

-- Conectar el evento CharacterAdded
player.CharacterAdded:Connect(onCharacterAdded)

-- Función para mover al personaje sin interferir con las físicas
local function moveSmoothly()
    local runService = game:GetService("RunService")
    runService.RenderStepped:Connect(function()
        if isSpeedActive and humanoid.MoveDirection.Magnitude > 0 then
            local moveDirection = humanoid.MoveDirection.Unit
            -- Cambiar la velocidad sin interferir con la física
            humanoid.WalkSpeed = defaultWalkSpeed * speedMultiplier
        end
    end)
end

-- Función para alternar la velocidad
local function toggleSpeed()
    isSpeedActive = not isSpeedActive
    if isSpeedActive then
        humanoid.WalkSpeed = defaultWalkSpeed * speedMultiplier
        Rayfield:Notify({
            Title = "Velocidad Activada",
            Content = "La velocidad personalizada está activa.",
            Duration = 5
        })
    else
        humanoid.WalkSpeed = defaultWalkSpeed
        Rayfield:Notify({
            Title = "Velocidad Desactivada",
            Content = "La velocidad personalizada está desactivada.",
            Duration = 5
        })
    end
end

-- Crear un botón para activar/desactivar velocidad
local speedButton = speedTab:CreateButton({
   Name = "Activar/Desactivar Velocidad",
   Callback = function()
      toggleSpeed()
   end
})

-- Crear un slider para ajustar la velocidad
local speedSlider = speedTab:CreateSlider({
   Name = "Ajustar Velocidad",
   Range = {1, 10}, -- Rango de velocidad
   Increment = 1, -- Incremento en pasos de 0.5
   Suffix = "x", -- Sufijo para mostrar junto al valor
   CurrentValue = 1, -- Valor inicial del slider
   Flag = "SpeedSlider",
   Callback = function(Value)
      speedMultiplier = Value
      if isSpeedActive then
         humanoid.WalkSpeed = defaultWalkSpeed * speedMultiplier
      end
   end
})

-- Activar el movimiento fluido
moveSmoothly()

-- Forzar la velocidad continuamente
local function forceSpeed()
    local runService = game:GetService("RunService")
    runService.RenderStepped:Connect(function()
        if isSpeedActive and humanoid.MoveDirection.Magnitude > 0 then
            -- Asegurarse de que la velocidad personalizada se mantenga
            humanoid.WalkSpeed = defaultWalkSpeed * speedMultiplier
        end
    end)
end

-- Llamar a la función para mantener la velocidad personalizada
forceSpeed()


-- Pestaña de Stamina
local staminaTab = Window:CreateTab("Stamina", 1)

-- Crear un botón para activar la stamina infinita
local staminaButton = staminaTab:CreateButton({
    Name = "Activar Stamina Infinita",
    Callback = function()
        local replicated_storage = game:GetService("ReplicatedStorage");

        local packages = replicated_storage:FindFirstChild("Packages");
        local knit_module = packages:FindFirstChild("Knit");
        local services = knit_module:FindFirstChild("Services");

        local local_player = game:GetService("Players").LocalPlayer;
        local player_stats = local_player.PlayerStats;

        local inf_stamina_method = "remote"; -- remote or playerstats

        while task.wait() do
            local decrease_stamina = services:FindFirstChild("StaminaService").RE.DecreaseStamina;
            local stamina_instance = player_stats.Stamina;

            if inf_stamina_method == "remote" then
                decrease_stamina:FireServer(math.sqrt(-1)) -- nan, dont set this to zero you will get kicked
            elseif inf_stamina_method == "playerstats" then
                stamina_instance.Value = 99
            end;
        end;
    end
})

-- Pestaña de Gravedad
-- Crear la pestaña de Gravedad
local gravityTab = Window:CreateTab("Gravedad", 2)

-- Función para ajustar la gravedad
local function setGravity(value)
    workspace.Gravity = value
    Rayfield:Notify({
        Title = "Gravedad Ajustada",
        Content = "La gravedad se ha establecido en " .. value,
        Duration = 5
    })
end

-- Crear un slider para ajustar la gravedad
local gravitySlider = gravityTab:CreateSlider({
    Name = "Ajustar Gravedad",
    Range = {0, 500},
    Increment = 1,
    Suffix = " u/s²",
    CurrentValue = workspace.Gravity,
    Flag = "GravitySlider",
    Callback = function(value)
        setGravity(value)
    end
})

-- Crear un botón para restaurar la gravedad predeterminada
local resetButton = gravityTab:CreateButton({
    Name = "Restaurar Gravedad Predeterminada",
    Callback = function()
        setGravity(196.2) -- Valor predeterminado de gravedad en Roblox
        gravitySlider:SetValue(196.2) -- Actualizar el slider
    end
})
