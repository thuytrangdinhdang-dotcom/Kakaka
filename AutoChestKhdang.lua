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
local chestList = {}

-- Hàm lấy tất cả rương trên toàn bản đồ (bao gồm tất cả sea)
local function getAllChests()
    local chests = {}
    -- Tìm kiếm trong workspace
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find("Chest") then
            table.insert(chests, v)
        end
        -- Tìm trong các model con
        if v:IsA("Model") then
            for _, child in pairs(v:GetDescendants()) do
                if child:IsA("Model") and child.Name:find("Chest") then
                    table.insert(chests, child)
                end
            end
        end
    end
    return chests
end

-- Hàm lấy tất cả rương với vị trí
local function getAllChestsWithPosition()
    local chests = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find("Chest") then
            local primaryPart = v:FindFirstChild("PrimaryPart") or v:FindFirstChild("Head") or v:FindFirstChild("HumanoidRootPart")
            if primaryPart then
                table.insert(chests, {
                    model = v,
                    position = primaryPart.Position,
                    part = primaryPart
                })
            end
        end
    end
    return chests
end

-- Hàm teleport đến rương
local function teleportToChest(chestData)
    if not chestData or not chestData.part then return end
    local pos = chestData.position + Vector3.new(0, 5, 0)
    Character:SetPrimaryPartCFrame(CFrame.new(pos))
    wait(0.05) -- Delay nhỏ để tránh lỗi
end

-- Hàm tìm rương gần nhất trong tất cả sea
local function findNearestChest()
    local chests = getAllChestsWithPosition()
    if #chests == 0 then return nil end
    
    local nearest = nil
    local minDist = math.huge
    local charPos = Character.PrimaryPart.Position
    
    for _, chest in pairs(chests) do
        if chest.part then
            local dist = (chest.position - charPos).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = chest
            end
        end
    end
    return nearest
end

-- Hàm teleport đến rương xa nhất (để farm toàn sea)
local function findFarthestChest()
    local chests = getAllChestsWithPosition()
    if #chests == 0 then return nil end
    
    local farthest = nil
    local maxDist = -math.huge
    local charPos = Character.PrimaryPart.Position
    
    for _, chest in pairs(chests) do
        if chest.part then
            local dist = (chest.position - charPos).Magnitude
            if dist > maxDist then
                maxDist = dist
                farthest = chest
            end
        end
    end
    return farthest
end

-- Hàm lấy rương ngẫu nhiên
local function getRandomChest()
    local chests = getAllChestsWithPosition()
    if #chests == 0 then return nil end
    return chests[math.random(1, #chests)]
end

-- Hàm reset nhân vật
local function resetCharacter()
    Character:BreakJoints()
end

-- Biến chế độ farm
local farmMode = "nearest" -- "nearest", "farthest", "random"

-- Hàm xử lý teleport với các chế độ
local function startTeleporting(mode)
    if isTeleporting then return end
    isTeleporting = true
    chestCount = 0
    farmMode = mode or "nearest"
    
    teleportTask = game:GetService("RunService").Heartbeat:Connect(function()
        if not isTeleporting then 
            teleportTask:Disconnect()
            return 
        end
        
        local targetChest = nil
        
        if farmMode == "nearest" then
            targetChest = findNearestChest()
        elseif farmMode == "farthest" then
            targetChest = findFarthestChest()
        elseif farmMode == "random" then
            targetChest = getRandomChest()
        end
        
        if targetChest then
            teleportToChest(targetChest)
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

-- === TẠO MAIN MENU ===
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 450, 0, 620)
Main.Position = UDim2.new(0.5, -225, 0.5, -310)
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
Title.Size = UDim2.new(1, -70, 0.6, 0)
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
Version.Size = UDim2.new(1, -70, 0.4, 0)
Version.Position = UDim2.new(0.12, 0, 0.6, 0)
Version.BackgroundTransparency = 1
Version.Text = "v3.0 | Auto Farm All Sea"
Version.TextColor3 = Color3.fromRGB(200, 200, 200)
Version.TextSize = 12
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Font = Enum.Font.Gotham
Version.Parent = Header

-- Panel chọn chế độ
local ModePanel = Instance.new("Frame")
ModePanel.Size = UDim2.new(0.9, 0, 0, 35)
ModePanel.Position = UDim2.new(0.05, 0, 0.15, 0)
ModePanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ModePanel.BackgroundTransparency = 0.5
ModePanel.BorderSizePixel = 1
ModePanel.BorderColor3 = Color3.fromRGB(255, 215, 0)
ModePanel.Parent = Main

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0.3, 0, 1, 0)
ModeLabel.Position = UDim2.new(0.02, 0, 0, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "🌊 Chế độ:"
ModeLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
ModeLabel.TextSize = 14
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.Parent = ModePanel

-- Dropdown chọn chế độ
local ModeDropdown = Instance.new("TextButton")
ModeDropdown.Size = UDim2.new(0.4, 0, 1, 0)
ModeDropdown.Position = UDim2.new(0.32, 0, 0, 0)
ModeDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
ModeDropdown.BackgroundTransparency = 0.5
ModeDropdown.BorderSizePixel = 1
ModeDropdown.BorderColor3 = Color3.fromRGB(255, 215, 0)
ModeDropdown.Text = "📌 Gần nhất"
ModeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeDropdown.TextSize = 13
ModeDropdown.Font = Enum.Font.Gotham
ModeDropdown.Parent = ModePanel

local isDropdownOpen = false
local DropdownList = nil

-- Tạo dropdown list
local function createDropdown()
    if DropdownList then DropdownList:Destroy() end
    DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(0.4, 0, 0, 90)
    DropdownList.Position = UDim2.new(0.32, 0, 1, 2)
    DropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    DropdownList.BackgroundTransparency = 0.2
    DropdownList.BorderSizePixel = 1
    DropdownList.BorderColor3 = Color3.fromRGB(255, 215, 0)
    DropdownList.Visible = true
    DropdownList.Parent = ModePanel
    
    local modes = {
        {"📌 Gần nhất", "nearest"},
        {"🚀 Xa nhất", "farthest"},
        {"🎲 Ngẫu nhiên", "random"}
    }
    
    for i, mode in pairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Position = UDim2.new(0, 0, (i-1)/3, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Text = mode[1]
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.Parent = DropdownList
        
        btn.MouseButton1Click:Connect(function()
            ModeDropdown.Text = mode[1]
            farmMode = mode[2]
            isDropdownOpen = false
            DropdownList.Visible = false
            if isTeleporting then
                stopTeleporting()
                startTeleporting(farmMode)
                ToggleBtn.Text = "⏹ TẮT AUTO CHEST"
            end
        end)
    end
end

ModeDropdown.MouseButton1Click:Connect(function()
    isDropdownOpen = not isDropdownOpen
    if isDropdownOpen then
        if DropdownList then DropdownList:Destroy() end
        createDropdown()
    else
        if DropdownList then
            DropdownList.Visible = false
        end
    end
end)

-- Nút Bật/Tắt
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 220, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -110, 0.28, 0)
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
StatusPanel.Position = UDim2.new(0.05, 0, 0.42, 0)
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

-- Tổng số rương trong sea
local TotalChestsLabel = Instance.new("TextLabel")
TotalChestsLabel.Size = UDim2.new(1, 0, 0, 20)
TotalChestsLabel.Position = UDim2.new(0, 0, 0.6, 0)
TotalChestsLabel.BackgroundTransparency = 1
TotalChestsLabel.Text = "🌍 Tổng rương trong sea: 0"
TotalChestsLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
TotalChestsLabel.TextSize = 12
TotalChestsLabel.Font = Enum.Font.Gotham
TotalChestsLabel.Parent = StatusPanel

-- Thanh tiến trình
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0.9, 0, 0, 8)
ProgressBar.Position = UDim2.new(0.05, 0, 0.58, 0)
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

-- Cập nhật tổng số rương
local function updateTotalChests()
    local chests = getAllChestsWithPosition()
    TotalChestsLabel.Text = "🌍 Tổng rương trong sea: " .. #chests
end

-- Cập nhật mỗi 5 giây
spawn(function()
    while true do
        wait(5)
        updateTotalChests()
    end
end)

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
        startTeleporting(farmMode)
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
print("🌊 Đã hỗ trợ farm rương toàn bộ Sea!")
print("⌨ Phím tắt: Alt + T để Bật/Tắt Auto Chest")
print("⌨ Phím tắt: Alt + M để Ẩn/Hiện Menu")