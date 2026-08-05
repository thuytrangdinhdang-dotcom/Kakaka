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
    wait(0.05)
end

-- Hàm tìm rương gần nhất
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

-- Hàm tìm rương xa nhất
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
local farmMode = "nearest"

-- Hàm xử lý teleport
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

-- === TẠO NÚT ẨN/HIỆN MENU (BANANA HUB STYLE) ===
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 65, 0, 65)
ToggleButton.Position = UDim2.new(0.02, 0, 0.5, -32)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.BorderSizePixel = 3
ToggleButton.BorderColor3 = Color3.fromRGB(255, 200, 0)
ToggleButton.Image = "rbxassetid://1000016099"
ToggleButton.ScaleType = Enum.ScaleType.Stretch
ToggleButton.Parent = ScreenGui

-- Glow vàng cho nút
local GlowFrame = Instance.new("Frame")
GlowFrame.Size = UDim2.new(1, 16, 1, 16)
GlowFrame.Position = UDim2.new(0, -8, 0, -8)
GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
GlowFrame.BackgroundTransparency = 0.85
GlowFrame.BorderSizePixel = 0
GlowFrame.Parent = ToggleButton

-- Tooltip
local Tooltip = Instance.new("TextLabel")
Tooltip.Size = UDim2.new(0, 160, 0, 30)
Tooltip.Position = UDim2.new(1.15, 0, 0.2, 0)
Tooltip.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Tooltip.BackgroundTransparency = 0.2
Tooltip.BorderSizePixel = 2
Tooltip.BorderColor3 = Color3.fromRGB(255, 200, 0)
Tooltip.Text = "🍌 khDang Auto Chest"
Tooltip.TextColor3 = Color3.fromRGB(255, 200, 0)
Tooltip.TextSize = 14
Tooltip.Font = Enum.Font.GothamBold
Tooltip.Visible = false
Tooltip.Parent = ToggleButton

ToggleButton.MouseEnter:Connect(function() Tooltip.Visible = true end)
ToggleButton.MouseLeave:Connect(function() Tooltip.Visible = false end)

-- === TẠO MAIN MENU (BANANA HUB PREMIUM STYLE) ===
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 620)
Main.Position = UDim2.new(0.5, -250, 0.5, -310)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.Parent = ScreenGui

-- Background với hiệu ứng
local BgFrame = Instance.new("Frame")
BgFrame.Size = UDim2.new(1, 0, 1, 0)
BgFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
BgFrame.BackgroundTransparency = 0.3
BgFrame.BorderSizePixel = 0
BgFrame.Parent = Main

-- Viền vàng đặc trưng Banana Hub
local Border = Instance.new("Frame")
Border.Size = UDim2.new(1, 0, 1, 0)
Border.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Border.BackgroundTransparency = 0.85
Border.BorderSizePixel = 3
Border.BorderColor3 = Color3.fromRGB(255, 200, 0)
Border.Parent = Main

-- Header Banana Hub Style
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 90)
Header.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Header.BackgroundTransparency = 0.15
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderGrad = Instance.new("UIGradient")
HeaderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 180, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 160, 0))
})
HeaderGrad.Parent = Header

-- Icon Banana
local HeaderIcon = Instance.new("ImageLabel")
HeaderIcon.Size = UDim2.new(0, 55, 0, 55)
HeaderIcon.Position = UDim2.new(0.04, 0, 0.2, 0)
HeaderIcon.BackgroundTransparency = 1
HeaderIcon.Image = "rbxassetid://1000016099"
HeaderIcon.Parent = Header

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0.5, 0)
Title.Position = UDim2.new(0.15, 0, 0.05, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍌 khDang Auto Chest"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 30
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.TextStrokeTransparency = 0.4
Title.Parent = Header

-- Subtitle
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -80, 0.35, 0)
SubTitle.Position = UDim2.new(0.15, 0, 0.55, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "💎 Premium Auto Farm Chest | v3.0"
SubTitle.TextColor3 = Color3.fromRGB(255, 220, 150)
SubTitle.TextSize = 14
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = Header

-- === KHU VỰC CHỌN CHẾ ĐỘ (BANANA CARD) ===
local ModeCard = Instance.new("Frame")
ModeCard.Size = UDim2.new(0.92, 0, 0, 55)
ModeCard.Position = UDim2.new(0.04, 0, 0.18, 0)
ModeCard.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
ModeCard.BackgroundTransparency = 0.3
ModeCard.BorderSizePixel = 2
ModeCard.BorderColor3 = Color3.fromRGB(255, 200, 0)
ModeCard.Parent = Main

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0.2, 0, 1, 0)
ModeLabel.Position = UDim2.new(0.03, 0, 0, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "🍌 Mode:"
ModeLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
ModeLabel.TextSize = 16
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.Parent = ModeCard

-- Nút chọn chế độ (Banana Style)
local function createModeButton(text, mode, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.23, 0, 0.8, 0)
    btn.Position = UDim2.new(pos, 0, 0.1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(255, 200, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = ModeCard
    return btn
end

local ModeBtn1 = createModeButton("📌 Gần nhất", "nearest", 0.24)
local ModeBtn2 = createModeButton("🚀 Xa nhất", "farthest", 0.49)
local ModeBtn3 = createModeButton("🎲 Ngẫu nhiên", "random", 0.74)

-- Xử lý chọn chế độ
local function updateModeButtons(selected)
    local buttons = {ModeBtn1, ModeBtn2, ModeBtn3}
    local modes = {"nearest", "farthest", "random"}
    for i, btn in pairs(buttons) do
        if modes[i] == selected then
            btn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            btn.BackgroundTransparency = 0.2
            btn.BorderColor3 = Color3.fromRGB(255, 200, 0)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            btn.BackgroundTransparency = 0.5
            btn.BorderColor3 = Color3.fromRGB(60, 60, 100)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.Font = Enum.Font.Gotham
        end
    end
end

ModeBtn1.MouseButton1Click:Connect(function()
    farmMode = "nearest"
    updateModeButtons("nearest")
    if isTeleporting then
        stopTeleporting()
        startTeleporting("nearest")
        ToggleBtn.Text = "⏹ TẮT AUTO CHEST"
    end
end)

ModeBtn2.MouseButton1Click:Connect(function()
    farmMode = "farthest"
    updateModeButtons("farthest")
    if isTeleporting then
        stopTeleporting()
        startTeleporting("farthest")
        ToggleBtn.Text = "⏹ TẮT AUTO CHEST"
    end
end)

ModeBtn3.MouseButton1Click:Connect(function()
    farmMode = "random"
    updateModeButtons("random")
    if isTeleporting then
        stopTeleporting()
        startTeleporting("random")
        ToggleBtn.Text = "⏹ TẮT AUTO CHEST"
    end
end)

-- === NÚT BẬT/TẮT CHÍNH (BANANA STYLE) ===
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.6, 0, 0, 60)
ToggleBtn.Position = UDim2.new(0.2, 0, 0.32, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.BorderSizePixel = 3
ToggleBtn.BorderColor3 = Color3.fromRGB(255, 200, 0)
ToggleBtn.Text = "▶ BẬT AUTO CHEST"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.TextStrokeTransparency = 0.3
ToggleBtn.Parent = Main

-- Glow vàng
local BtnGlow = Instance.new("Frame")
BtnGlow.Size = UDim2.new(1, 12, 1, 12)
BtnGlow.Position = UDim2.new(0, -6, 0, -6)
BtnGlow.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
BtnGlow.BackgroundTransparency = 0.85
BtnGlow.BorderSizePixel = 0
BtnGlow.Parent = ToggleBtn

-- === STATUS CARD (BANANA STYLE) ===
local StatusCard = Instance.new("Frame")
StatusCard.Size = UDim2.new(0.92, 0, 0, 110)
StatusCard.Position = UDim2.new(0.04, 0, 0.46, 0)
StatusCard.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
StatusCard.BackgroundTransparency = 0.3
StatusCard.BorderSizePixel = 2
StatusCard.BorderColor3 = Color3.fromRGB(255, 200, 0)
StatusCard.Parent = Main

-- Trạng thái
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0.45, 0, 0.4, 0)
StatusText.Position = UDim2.new(0.03, 0, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "⚪ TẮT"
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.TextSize = 22
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Font = Enum.Font.GothamBold
StatusText.Parent = StatusCard

-- Số rương
local ChestCounter = Instance.new("TextLabel")
ChestCounter.Size = UDim2.new(0.45, 0, 0.4, 0)
ChestCounter.Position = UDim2.new(0.52, 0, 0, 0)
ChestCounter.BackgroundTransparency = 1
ChestCounter.Text = "📦 0/10"
ChestCounter.TextColor3 = Color3.fromRGB(255, 215, 100)
ChestCounter.TextSize = 22
ChestCounter.TextXAlignment = Enum.TextXAlignment.Right
ChestCounter.Font = Enum.Font.GothamBold
ChestCounter.Parent = StatusCard

-- Tổng rương
local TotalChestsLabel = Instance.new("TextLabel")
TotalChestsLabel.Size = UDim2.new(1, 0, 0.35, 0)
TotalChestsLabel.Position = UDim2.new(0, 0, 0.45, 0)
TotalChestsLabel.BackgroundTransparency = 1
TotalChestsLabel.Text = "🌍 Tổng rương: 0"
TotalChestsLabel.TextColor3 = Color3.fromRGB(255, 220, 150)
TotalChestsLabel.TextSize = 15
TotalChestsLabel.Font = Enum.Font.Gotham
TotalChestsLabel.Parent = StatusCard

-- Thanh tiến trình Banana Style
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0.94, 0, 0, 12)
ProgressBar.Position = UDim2.new(0.03, 0, 0.85, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
ProgressBar.BackgroundTransparency = 0.4
ProgressBar.BorderSizePixel = 2
ProgressBar.BorderColor3 = Color3.fromRGB(255, 200, 0)
ProgressBar.Parent = StatusCard

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
ProgressFill.BackgroundTransparency = 0.2
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBar

-- Text trên thanh
local ProgressText = Instance.new("TextLabel")
ProgressText.Size = UDim2.new(1, 0, 1, 0)
ProgressText.BackgroundTransparency = 1
ProgressText.Text = "0%"
ProgressText.TextColor3 = Color3.fromRGB(255, 255, 255)
ProgressText.TextSize = 10
ProgressText.Font = Enum.Font.GothamBold
ProgressText.Parent = ProgressBar

-- === FOOTER BANANA STYLE ===
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Footer.BackgroundTransparency = 0.1
Footer.BorderSizePixel = 0
Footer.Parent = Main

-- Bản quyền
local Copyright = Instance.new("TextLabel")
Copyright.Size = UDim2.new(0.5, 0, 1, 0)
Copyright.Position = UDim2.new(0.03, 0, 0, 0)
Copyright.BackgroundTransparency = 1
Copyright.Text = "by KhDang Blox Fruit [Free]"
Copyright.TextColor3 = Color3.fromRGB(255, 200, 0)
Copyright.TextSize = 14
Copyright.TextXAlignment = Enum.TextXAlignment.Left
Copyright.Font = Enum.Font.GothamBold
Copyright.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Copyright.TextStrokeTransparency = 0.5
Copyright.Parent = Footer

-- Phím tắt
local HotkeyText = Instance.new("TextLabel")
HotkeyText.Size = UDim2.new(0.45, 0, 1, 0)
HotkeyText.Position = UDim2.new(0.52, 0, 0, 0)
HotkeyText.BackgroundTransparency = 1
HotkeyText.Text = "⌨ Alt+T | Alt+M"
HotkeyText.TextColor3 = Color3.fromRGB(255, 220, 150)
HotkeyText.TextSize = 13
HotkeyText.TextXAlignment = Enum.TextXAlignment.Right
HotkeyText.Font = Enum.Font.Gotham
HotkeyText.Parent = Footer

-- Cập nhật tổng số rương
local function updateTotalChests()
    local chests = getAllChestsWithPosition()
    TotalChestsLabel.Text = "🌍 Tổng rương: " .. #chests
end

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
        ToggleButton.BorderColor3 = Color3.fromRGB(255, 200, 0)
        GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        Tooltip.Text = "🍌 khDang Auto Chest"
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
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
        BtnGlow.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StatusText.Text = "🟢 ĐANG CHẠY..."
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        stopTeleporting()
        ToggleBtn.Text = "▶ BẬT AUTO CHEST"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        ToggleBtn.BorderColor3 = Color3.fromRGB(255, 200, 0)
        BtnGlow.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        StatusText.Text = "⚪ TẮT"
        StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
        ChestCounter.Text = "📦 0/10"
        ProgressFill.Size = UDim2.new(0, 0, 1, 0)
        ProgressText.Text = "0%"
    end
end)

-- Cập nhật counter
game:GetService("RunService").Heartbeat:Connect(function()
    if isTeleporting then
        ChestCounter.Text = "📦 " .. chestCount .. "/10"
        local progress = chestCount / 10
        ProgressFill.Size = UDim2.new(progress, 0, 1, 0)
        ProgressText.Text = math.floor(progress * 100) .. "%"
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
        ProgressText.Text = "0%"
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

print("🍌 khDang Auto Chest đã tải thành công!")
print("📜 Bản quyền by KhDang Blox Fruit [Free]")
print("🌊 Đã hỗ trợ farm rương toàn bộ Sea!")
print("⌨ Phím tắt: Alt + T để Bật/Tắt Auto Chest")
print("⌨ Phím tắt: Alt + M để Ẩn/Hiện Menu")
