-- khDang Auto chest - Blox Fruit Script
-- Bản quyền by KhDang Blox Fruit [Free]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "khDangAutoChest"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- Biến trạng thái
local isTeleporting = false
local chestCount = 0
local teleportTask = nil
local isMenuVisible = true

-- Hàm lấy tất cả rương trên bản đồ
local function getAllChests()
    local chests = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find("Chest") then
            table.insert(chests, v)
        end
    end
    return chests
end

-- Hàm teleport đến rương
local function teleportToChest(chest)
    if not chest or not chest.PrimaryPart then return end
    local pos = chest.PrimaryPart.Position + Vector3.new(0, 5, 0)
    Character:SetPrimaryPartCFrame(CFrame.new(pos))
end

-- Hàm tìm rương gần nhất
local function findNearestChest()
    local chests = getAllChests()
    local nearest = nil
    local minDist = math.huge
    local charPos = Character.PrimaryPart.Position
    
    for _, chest in pairs(chests) do
        if chest.PrimaryPart then
            local dist = (chest.PrimaryPart.Position - charPos).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = chest
            end
        end
    end
    return nearest
end

-- Hàm reset nhân vật
local function resetCharacter()
    Character:BreakJoints()
end

-- Hàm xử lý teleport
local function startTeleporting()
    if isTeleporting then return end
    isTeleporting = true
    chestCount = 0
    
    teleportTask = game:GetService("RunService").Heartbeat:Connect(function()
        if not isTeleporting then 
            teleportTask:Disconnect()
            return 
        end
        
        local nearest = findNearestChest()
        if nearest then
            teleportToChest(nearest)
            chestCount = chestCount + 1
            
            if chestCount >= 10 then
                resetCharacter()
                chestCount = 0
            end
        end
    end)
end

local function stopTeleporting()
    isTeleporting = false
    if teleportTask then
        teleportTask:Disconnect()
        teleportTask = nil
    end
end

-- === TẠO NÚT ẨN/HIỆN MENU ===
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0.02, 0, 0.5, -27)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.BorderSizePixel = 2
ToggleButton.BorderColor3 = Color3.fromRGB(255, 215, 0)
ToggleButton.Image = "rbxassetid://1000016099"
ToggleButton.ScaleType = Enum.ScaleType.Stretch
ToggleButton.Parent = ScreenGui

-- Hiệu ứng glow
local GlowFrame = Instance.new("Frame")
GlowFrame.Size = UDim2.new(1, 10, 1, 10)
GlowFrame.Position = UDim2.new(0, -5, 0, -5)
GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
GlowFrame.BackgroundTransparency = 0.85
GlowFrame.BorderSizePixel = 0
GlowFrame.Parent = ToggleButton

-- Tooltip
local Tooltip = Instance.new("TextLabel")
Tooltip.Size = UDim2.new(0, 140, 0, 28)
Tooltip.Position = UDim2.new(1.15, 0, 0.25, 0)
Tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Tooltip.BackgroundTransparency = 0.6
Tooltip.BorderSizePixel = 1
Tooltip.BorderColor3 = Color3.fromRGB(255, 215, 0)
Tooltip.Text = "⚡ khDang Auto Chest"
Tooltip.TextColor3 = Color3.fromRGB(255, 215, 0)
Tooltip.TextSize = 13
Tooltip.Font = Enum.Font.GothamBold
Tooltip.Visible = false
Tooltip.Parent = ToggleButton

ToggleButton.MouseEnter:Connect(function()
    Tooltip.Visible = true
end)

ToggleButton.MouseLeave:Connect(function()
    Tooltip.Visible = false
end)

-- === TẠO MAIN MENU (Phong cách mới) ===
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 580)
Main.Position = UDim2.new(0.5, -210, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 215, 0)
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.Parent = ScreenGui

-- Background gradient
local BGGradient = Instance.new("UIGradient")
BGGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
})
BGGradient.Parent = Main

-- Viền sáng bên trong
local InnerBorder = Instance.new("Frame")
InnerBorder.Size = UDim2.new(1, -4, 1, -4)
InnerBorder.Position = UDim2.new(0, 2, 0, 2)
InnerBorder.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
InnerBorder.BackgroundTransparency = 0.9
InnerBorder.BorderSizePixel = 0
InnerBorder.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderGrad = Instance.new("UIGradient")
HeaderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 0))
})
HeaderGrad.Parent = Header

-- Icon trong header
local HeaderIcon = Instance.new("ImageLabel")
HeaderIcon.Size = UDim2.new(0, 45, 0, 45)
HeaderIcon.Position = UDim2.new(0.03, 0, 0.15, 0)
HeaderIcon.BackgroundTransparency = 1
HeaderIcon.Image = "rbxassetid://1000016099"
HeaderIcon.Parent = Header

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0.12, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ khDang Auto Chest"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 28
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.TextStrokeTransparency = 0.5
Title.Parent = Header

-- Phiên bản
local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, -70, 0, 20)
Version.Position = UDim2.new(0.12, 0, 0.7, 0)
Version.BackgroundTransparency = 1
Version.Text = "v2.0 | Auto Farm Chest"
Version.TextColor3 = Color3.fromRGB(200, 200, 200)
Version.TextSize = 12
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Font = Enum.Font.Gotham
Version.Parent = Header

-- Nút Bật/Tắt (Phong cách mới)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 220, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -110, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.BorderSizePixel = 2
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
ToggleBtn.Text = "▶ BẬT AUTO CHEST"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.TextStrokeTransparency = 0.5
ToggleBtn.Parent = Main

-- Glow cho nút
local BtnGlow = Instance.new("Frame")
BtnGlow.Size = UDim2.new(1, 8, 1, 8)
BtnGlow.Position = UDim2.new(0, -4, 0, -4)
BtnGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
BtnGlow.BackgroundTransparency = 0.85
BtnGlow.BorderSizePixel = 0
BtnGlow.Parent = ToggleBtn

-- Status Panel
local StatusPanel = Instance.new("Frame")
StatusPanel.Size = UDim2.new(0.9, 0, 0, 80)
StatusPanel.Position = UDim2.new(0.05, 0, 0.55, 0)
StatusPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusPanel.BackgroundTransparency = 0.5
StatusPanel.BorderSizePixel = 1
StatusPanel.BorderColor3 = Color3.fromRGB(255, 215, 0)
StatusPanel.Parent = Main

-- Trạng thái
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0.5, 0, 1, 0)
StatusText.Position = UDim2.new(0.02, 0, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "⚪ TẮT"
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.TextSize = 18
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Font = Enum.Font.GothamBold
StatusText.Parent = StatusPanel

-- Số rương
local ChestCounter = Instance.new("TextLabel")
ChestCounter.Size = UDim2.new(0.5, 0, 1, 0)
ChestCounter.Position = UDim2.new(0.5, 0, 0, 0)
ChestCounter.BackgroundTransparency = 1
ChestCounter.Text = "📦 0/10"
ChestCounter.TextColor3 = Color3.fromRGB(255, 200, 100)
ChestCounter.TextSize = 18
ChestCounter.TextXAlignment = Enum.TextXAlignment.Right
ChestCounter.Font = Enum.Font.GothamBold
ChestCounter.Parent = StatusPanel

-- Thanh tiến trình
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0.9, 0, 0, 8)
ProgressBar.Position = UDim2.new(0.05, 0, 0.73, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
ProgressBar.BackgroundTransparency = 0.5
ProgressBar.BorderSizePixel = 1
ProgressBar.BorderColor3 = Color3.fromRGB(255, 215, 0)
ProgressBar.Parent = Main

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
ProgressFill.BackgroundTransparency = 0.3
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBar

-- Nút Info
local InfoBtn = Instance.new("TextButton")
InfoBtn.Size = UDim2.new(0, 100, 0, 30)
InfoBtn.Position = UDim2.new(0.5, -50, 0.82, 0)
InfoBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
InfoBtn.BackgroundTransparency = 0.8
InfoBtn.BorderSizePixel = 1
InfoBtn.BorderColor3 = Color3.fromRGB(255, 215, 0)
InfoBtn.Text = "ⓘ Thông tin"
InfoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
InfoBtn.TextSize = 14
InfoBtn.Font = Enum.Font.Gotham
InfoBtn.Parent = Main

-- Bản quyền
local Copyright = Instance.new("TextLabel")
Copyright.Size = UDim2.new(1, 0, 0, 25)
Copyright.Position = UDim2.new(0, 0, 1, -25)
Copyright.BackgroundTransparency = 1
Copyright.Text = "by KhDang Blox Fruit [Free]"
Copyright.TextColor3 = Color3.fromRGB(255, 0, 0)
Copyright.TextSize = 13
Copyright.TextScaled = true
Copyright.Font = Enum.Font.GothamBold
Copyright.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Copyright.TextStrokeTransparency = 0.5
Copyright.Parent = Main

-- Xử lý nút Ẩn/Hiện
ToggleButton.MouseButton1Click:Connect(function()
    isMenuVisible = not isMenuVisible
    Main.Visible = isMenuVisible
    
    if isMenuVisible then
        ToggleButton.BorderColor3 = Color3.fromRGB(255, 215, 0)
        GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        Tooltip.Text = "⚡ khDang Auto Chest"
    else
        ToggleButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
        GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        Tooltip.Text = "🔴 Menu đang ẩn"
    end
end)

-- Xử lý nút Bật/Tắt
ToggleBtn.MouseButton1Click:Connect(function()
    if not isTeleporting then
        startTeleporting()
        ToggleBtn.Text = "⏹ TẮT AUTO CHEST"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        ToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
        BtnGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        StatusText.Text = "🟢 ĐANG CHẠY..."
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        stopTeleporting()
        ToggleBtn.Text = "▶ BẬT AUTO CHEST"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        ToggleBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
        BtnGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        StatusText.Text = "⚪ TẮT"
        StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
        ChestCounter.Text = "📦 0/10"
        ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    end
end)

-- Cập nhật counter và thanh tiến trình
game:GetService("RunService").Heartbeat:Connect(function()
    if isTeleporting then
        ChestCounter.Text = "📦 " .. chestCount .. "/10"
        local progress = chestCount / 10
        ProgressFill.Size = UDim2.new(progress, 0, 1, 0)
    end
end)

-- Xử lý khi nhân vật respawn
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    if isTeleporting then
        chestCount = 0
        ChestCounter.Text = "📦 0/10"
        ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    end
end)

-- Phím tắt
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T and input:IsModifierKeyDown(Enum.ModifierKey.Alt) then
        ToggleBtn.MouseButton1Click:Fire()
    end
    if input.KeyCode == Enum.KeyCode.M and input:IsModifierKeyDown(Enum.ModifierKey.Alt) then
        ToggleButton.MouseButton1Click:Fire()
    end
end)

print("⚡ khDang Auto Chest đã tải thành công!")
print("📜 Bản quyền by KhDang Blox Fruit [Free]")
print("⌨ Phím tắt: Alt + T để Bật/Tắt Auto Chest")
print("⌨ Phím tắt: Alt + M để Ẩn/Hiện Menu")
