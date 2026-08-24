-- Maru Hub [Premium]
-- Owner: ĐăngZues
-- Fluent UI + Main position save + Fly + Auto Fly + Rotation + Fix Lag

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Maru Hub [Premium]",
    SubTitle = "Owner: ĐăngZues",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Amber",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "rbxassetid://9681970193"
})

local FixTab = Window:AddTab({
    Title = "Fix Lag",
    Icon = "rbxassetid://9681970193"
})

local function getCharacter()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    return char, humanoid, root
end

-- Position system
local savedPosition = nil

MainTab:AddButton({
    Title = "Set vị trí hiện tại",
    Description = "Lưu vị trí nhân vật đang đứng",
    Icon = "rbxassetid://9681970193",
    Callback = function()
        local _, _, root = getCharacter()
        if root then
            savedPosition = root.CFrame
            Fluent:Notify({
                Title = "Maru Hub",
                Content = "Đã lưu vị trí hiện tại.",
                Duration = 2
            })
        end
    end
})

MainTab:AddButton({
    Title = "Đặt lại vị trí đã lưu",
    Description = "Đưa nhân vật về vị trí đã lưu",
    Icon = "rbxassetid://9681970193",
    Callback = function()
        local _, _, root = getCharacter()
        if root and savedPosition then
            root.CFrame = savedPosition + Vector3.new(0, 3, 0)
        end
    end
})

-- Fly
local FlyEnabled = false
local FlySpeed = 50
local FlyConnection = nil
local FlyVelocity = nil
local FlyGyro = nil

local function stopFly()
    FlyEnabled = false
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if FlyVelocity then
        FlyVelocity:Destroy()
        FlyVelocity = nil
    end
    if FlyGyro then
        FlyGyro:Destroy()
        FlyGyro = nil
    end
end

local function startFly()
    stopFly()
    local char, humanoid, root = getCharacter()
    if not humanoid or not root then return end

    FlyEnabled = true

    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    FlyVelocity.Velocity = Vector3.zero
    FlyVelocity.Parent = root

    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    FlyGyro.P = 100000
    FlyGyro.D = 1000
    FlyGyro.CFrame = root.CFrame
    FlyGyro.Parent = root

    humanoid.PlatformStand = false

    FlyConnection = RunService.RenderStepped:Connect(function()
        if not FlyEnabled or not root.Parent then
            stopFly()
            return
        end

        local camera = Workspace.CurrentCamera
        local move = humanoid.MoveDirection
        local vertical = 0

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertical += 1
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            vertical -= 1
        end

        local direction = move
        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        -- Mobile/iPad uses Humanoid.MoveDirection; PC additionally supports Space/Ctrl.
        FlyVelocity.Velocity = (direction * FlySpeed) + Vector3.new(0, vertical * FlySpeed, 0)
        FlyGyro.CFrame = CFrame.new(root.Position, root.Position + camera.CFrame.LookVector)
    end)
end

MainTab:AddToggle("Fly", {
    Title = "Fly",
    Default = false,
    Icon = "rbxassetid://9681970193",
    Callback = function(value)
        if value then
            startFly()
        else
            stopFly()
        end
    end
})

MainTab:AddInput("FlySpeed", {
    Title = "Fly Speed (1-1000)",
    Default = "50",
    Placeholder = "1 - 1000",
    Numeric = true,
    Finished = true,
    Callback = function(value)
        local n = tonumber(value)
        if n then
            FlySpeed = math.clamp(math.floor(n), 1, 1000)
        end
    end
})

-- Auto fly: keeps the character suspended and avoids normal falling while enabled.
local AutoFly = false
local AutoFlyConnection = nil
local AutoVelocity = nil

local function stopAutoFly()
    AutoFly = false
    if AutoFlyConnection then
        AutoFlyConnection:Disconnect()
        AutoFlyConnection = nil
    end
    if AutoVelocity then
        AutoVelocity:Destroy()
        AutoVelocity = nil
    end
end

local function startAutoFly()
    stopAutoFly()
    local _, humanoid, root = getCharacter()
    if not humanoid or not root then return end

    AutoFly = true
    AutoVelocity = Instance.new("BodyVelocity")
    AutoVelocity.MaxForce = Vector3.new(0, 1e9, 0)
    AutoVelocity.Velocity = Vector3.zero
    AutoVelocity.Parent = root

    AutoFlyConnection = RunService.Heartbeat:Connect(function()
        if not AutoFly or not root.Parent then
            stopAutoFly()
            return
        end
        AutoVelocity.Velocity = Vector3.new(0, 0, 0)
        humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    end)
end

MainTab:AddToggle("AutoFly", {
    Title = "Auto Fly",
    Default = false,
    Icon = "rbxassetid://9681970193",
    Callback = function(value)
        if value then
            startAutoFly()
        else
            stopAutoFly()
        end
    end
})

-- Rotation without changing camera orientation.
local RotationEnabled = false
local RotationSpeed = 10
local RotationConnection = nil

local function stopRotation()
    RotationEnabled = false
    if RotationConnection then
        RotationConnection:Disconnect()
        RotationConnection = nil
    end
end

local function startRotation()
    stopRotation()
    RotationEnabled = true
    RotationConnection = RunService.RenderStepped:Connect(function(dt)
        local _, _, root = getCharacter()
        if not root then return end
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(RotationSpeed) * dt * 60, 0)
    end)
end

MainTab:AddToggle("Rotation", {
    Title = "Xoay người",
    Default = false,
    Icon = "rbxassetid://9681970193",
    Callback = function(value)
        if value then
            startRotation()
        else
            stopRotation()
        end
    end
})

MainTab:AddInput("RotationSpeed", {
    Title = "Rotation Speed (1-1000)",
    Default = "10",
    Placeholder = "1 - 1000",
    Numeric = true,
    Finished = true,
    Callback = function(value)
        local n = tonumber(value)
        if n then
            RotationSpeed = math.clamp(math.floor(n), 1, 1000)
        end
    end
})

-- Fix Lag / optimization
local FixLagEnabled = false
local oldSettings = {}

local function applyFixLag()
    if FixLagEnabled then return end
    FixLagEnabled = true

    pcall(function()
        oldSettings.GlobalShadows = Lighting.GlobalShadows
        oldSettings.FogEnd = Lighting.FogEnd
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
    end)

    for _, obj in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            elseif obj:IsA("Smoke") or obj:IsA("Fire") then
                obj.Enabled = false
            elseif obj:IsA("PostEffect") then
                obj.Enabled = false
            end
        end)
    end
end

local function stopFixLag()
    FixLagEnabled = false
    pcall(function()
        if oldSettings.GlobalShadows ~= nil then
            Lighting.GlobalShadows = oldSettings.GlobalShadows
        end
        if oldSettings.FogEnd ~= nil then
            Lighting.FogEnd = oldSettings.FogEnd
        end
    end)
end

FixTab:AddToggle("FixLag", {
    Title = "Fix Lag",
    Default = false,
    Icon = "rbxassetid://9681970193",
    Callback = function(value)
        if value then
            applyFixLag()
        else
            stopFixLag()
        end
    end
})

FixTab:AddButton({
    Title = "Tối ưu ngay",
    Description = "Tắt hiệu ứng nặng trong Workspace",
    Icon = "rbxassetid://9681970193",
    Callback = function()
        applyFixLag()
        Fluent:Notify({
            Title = "Fix Lag",
            Content = "Đã tối ưu hiệu ứng và ánh sáng.",
            Duration = 2
        })
    end
})

-- Optional low-detail mode for supported Roblox clients.
FixTab:AddToggle("LowDetail", {
    Title = "Low Detail",
    Default = false,
    Icon = "rbxassetid://9681970193",
    Callback = function(value)
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(Workspace, "StreamingTargetRadius", value and 64 or 1024)
                sethiddenproperty(Workspace, "StreamingMinRadius", value and 32 or 64)
            end
        end)
    end
})

-- Re-apply movement helpers after respawn.
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if FlyEnabled then startFly() end
    if AutoFly then startAutoFly() end
    if RotationEnabled then startRotation() end
end)

-- Floating button using the requested image.
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "MaruHubToggle"
ToggleGui.ResetOnSpawn = false
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "MaruHubButton"
ToggleButton.Size = UDim2.fromOffset(52, 52)
ToggleButton.Position = UDim2.new(0, 18, 0.5, -26)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "rbxassetid://9681970193"
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.ZIndex = 9999
ToggleButton.Parent = ToggleGui

ToggleButton.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Maru Hub [Premium]",
    Content = "Loaded | Owner: ĐăngZues",
    Duration = 3
})
