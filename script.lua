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

-- Pestaña de Gravedad
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
    Range = {0, 140},
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

-- Pestaña de Reach
local reachTab = Window:CreateTab("Reach", 3)

-- Configuración de Reach
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LOCAL_PLAYER = Players.LocalPlayer

-- Configuración de colores y transparencia
local PRIMARY_COLOR = Color3.fromRGB(187, 217, 134)  -- Verde claro pastel
local GOALIE_COLOR = Color3.fromRGB(244, 248, 239)   -- Blanco hueso
local HIGH_TRANSPARENCY = 1                       -- Casi invisible

-- Configuraciones de hitboxes
local HitboxConfigs = {
    Dribble = {
        Size = Vector3.new(9.9, 2.2, 9.9),
        Color = PRIMARY_COLOR,
        Transparency = HIGH_TRANSPARENCY,
        Material = Enum.Material.Neon,
        Path = function()
            local playerModel = Workspace:FindFirstChild(LOCAL_PLAYER.Name)
            if not playerModel then return nil end
            local hitboxFolder = playerModel:FindFirstChild("Hitbox")
            if not hitboxFolder then return nil end
            return hitboxFolder:FindFirstChild("Dribble")
        end
    },
    Kick = {
        Size = Vector3.new(15, 30, 15),
        Color = PRIMARY_COLOR,
        Transparency = HIGH_TRANSPARENCY,
        Material = Enum.Material.Neon,
        Path = function()
            local playerModel = Workspace:FindFirstChild(LOCAL_PLAYER.Name)
            if not playerModel then return nil end
            local hitboxFolder = playerModel:FindFirstChild("Hitbox")
            if not hitboxFolder then return nil end
            return hitboxFolder:FindFirstChild("Kick")
        end
    },
    Slide = {
        Size = Vector3.new(12, 1.5, 12),
        Color = PRIMARY_COLOR,
        Transparency = HIGH_TRANSPARENCY,
        Material = Enum.Material.Neon,
        Path = function()
            local playerModel = Workspace:FindFirstChild(LOCAL_PLAYER.Name)
            if not playerModel then return nil end
            local hitboxFolder = playerModel:FindFirstChild("Hitbox")
            if not hitboxFolder then return nil end
            return hitboxFolder:FindFirstChild("Slide")
        end
    },
    Goalie = {
        Size = Vector3.new(20, 25, 20),
        Color = GOALIE_COLOR,
        Transparency = HIGH_TRANSPARENCY,
        Material = Enum.Material.Neon,
        Path = function()
            local playerModel = Workspace:FindFirstChild(LOCAL_PLAYER.Name)
            if not playerModel then return nil end
            local hitboxFolder = playerModel:FindFirstChild("Hitbox")
            if not hitboxFolder then return nil end
            return hitboxFolder:FindFirstChild("Goalie")
        end
    }
}

local States = {
    Dribble = {original = {}, active = false},
    Kick = {original = {}, active = false},
    Slide = {original = {}, active = false},
    Goalie = {original = {}, active = false}
}

-- Ajustes de incremento
local INCREMENT_STEP = 2
local MAX_INCREMENT = 50
local currentIncrement = 0
local debounce = false

-- Eliminar la GUI de Roblox si existe
if LOCAL_PLAYER:FindFirstChild("PlayerGui") then
    local reachGui = LOCAL_PLAYER.PlayerGui:FindFirstChild("ReachGui")
    if reachGui then
        reachGui:Destroy()
    end
end

-- Funcionalidad principal
local function updateHitboxSizes()
    local successCount = 0
    
    for name, config in pairs(HitboxConfigs) do
        local hitbox = config.Path()
        if not hitbox then continue end

        local state = States[name]
        
        if not state.original.Size then
            state.original = {
                Size = hitbox.Size,
                Transparency = hitbox.Transparency,
                Color = hitbox.Color,
                Material = hitbox.Material,
                CanQuery = hitbox.CanQuery,
                CanTouch = hitbox.CanTouch,
                CanCollide = hitbox.CanCollide
            }
        end

        hitbox.Size = state.original.Size + Vector3.new(currentIncrement, currentIncrement, currentIncrement)
        hitbox.Transparency = config.Transparency
        hitbox.Color = config.Color
        hitbox.Material = config.Material
        hitbox.CanQuery = true
        hitbox.CanTouch = true
        hitbox.CanCollide = false
        
        successCount += 1
    end
    
    return successCount > 0
end

local function resetToOriginal()
    for name, state in pairs(States) do
        local hitbox = HitboxConfigs[name].Path()
        if hitbox and state.original.Size then
            for property, value in pairs(state.original) do
                pcall(function() hitbox[property] = value end)
            end
        end
    end
end

-- Crear botones en Rayfield para Reach
local reachSection = reachTab:CreateSection("Ajustes de Reach")

local increaseButton = reachTab:CreateButton({
    Name = "Aumentar Reach",
    Callback = function()
        if debounce then return end
        debounce = true
        
        if currentIncrement < MAX_INCREMENT then
            currentIncrement += INCREMENT_STEP
            if updateHitboxSizes() then
                Rayfield:Notify({
                    Title = "Reach Aumentado",
                    Content = "Nuevo reach: "..currentIncrement,
                    Duration = 3
                })
            end
        else
            Rayfield:Notify({
                Title = "Límite Alcanzado",
                Content = "Has llegado al máximo reach ("..MAX_INCREMENT..")",
                Duration = 3
            })
        end
        
        debounce = false
    end
})

local resetButton = reachTab:CreateButton({
    Name = "Resetear Reach",
    Callback = function()
        if debounce then return end
        debounce = true
        
        currentIncrement = 0
        resetToOriginal()
        Rayfield:Notify({
            Title = "Reach Reseteado",
            Content = "El reach ha vuelto a su valor original",
            Duration = 3
        })
        
        debounce = false
    end
})

-- Botones para activar/desactivar hitboxes específicas
local hitboxSection = reachTab:CreateSection("Hitboxes Específicas")

local function toggleHitbox(hitboxName)
    local state = States[hitboxName]
    state.active = not state.active
    
    local hitbox = HitboxConfigs[hitboxName].Path()
    if hitbox then
        if state.active then
            if not state.original.Size then
                state.original = {
                    Size = hitbox.Size,
                    Transparency = hitbox.Transparency,
                    Color = hitbox.Color,
                    Material = hitbox.Material,
                    CanQuery = hitbox.CanQuery,
                    CanTouch = hitbox.CanTouch,
                    CanCollide = hitbox.CanCollide
                }
            end
            
            hitbox.Size = state.original.Size + Vector3.new(currentIncrement, currentIncrement, currentIncrement)
            hitbox.Transparency = HitboxConfigs[hitboxName].Transparency
            hitbox.Color = HitboxConfigs[hitboxName].Color
            hitbox.Material = HitboxConfigs[hitboxName].Material
            hitbox.CanQuery = true
            hitbox.CanTouch = true
            hitbox.CanCollide = false
        else
            for property, value in pairs(state.original) do
                pcall(function() hitbox[property] = value end)
            end
        end
    end
    
    Rayfield:Notify({
        Title = "Hitbox "..hitboxName,
        Content = state.active and "Activada" or "Desactivada",
        Duration = 3
    })
end

local dribbleButton = reachTab:CreateButton({
    Name = "Activar/Desactivar Dribble",
    Callback = function()
        toggleHitbox("Dribble")
    end
})

local kickButton = reachTab:CreateButton({
    Name = "Activar/Desactivar Kick",
    Callback = function()
        toggleHitbox("Kick")
    end
})

local slideButton = reachTab:CreateButton({
    Name = "Activar/Desactivar Slide",
    Callback = function()
        toggleHitbox("Slide")
    end
})

local goalieButton = reachTab:CreateButton({
    Name = "Activar/Desactivar Goalie",
    Callback = function()
        toggleHitbox("Goalie")
    end
})

-- Manejo de personaje
local function onCharacterAdded(character)
    local maxTries = 15
    for i = 1, maxTries do
        if updateHitboxSizes() then break end
        task.wait(0.3)
    end
end

-- Inicialización
if LOCAL_PLAYER.Character then
    task.spawn(onCharacterAdded, LOCAL_PLAYER.Character)
end
LOCAL_PLAYER.CharacterAdded:Connect(onCharacterAdded)

print("✅ Script activado | Hitboxes: Dribble (Verde), Kick, Slide, Goalie (Blanco)")
