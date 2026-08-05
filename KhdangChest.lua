-- KhDang Auto Chest V1.8
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/kavo.lua"))()
local Window = Library.CreateLib("KhDang Auto Chest V1.8", "Ocean")

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local First_Sea = false
local Second_Sea = false
local Third_Sea = false
local placeId = game.PlaceId

if placeId == 2753915549 then
    First_Sea = true
elseif placeId == 4442272183 then
    Second_Sea = true
elseif placeId == 7449423635 then
    Third_Sea = true
end

local Speed = 300
local FarmEnabled = false
local CurrentChest = nil

-- Main Tab
local MainTab = Window:NewTab("Chính")
local MainSection = MainTab:NewSection("Điều Khiển")

-- Bắt đầu Farm Button
MainSection:NewButton("▶ BẮT ĐỀU FARM", "Bắt đầu auto farm rương", function()
    FarmEnabled = not FarmEnabled
    if FarmEnabled then
        print("Đã bắt đầu farm rương")
    else
        print("Đã dừng farm rương")
    end
end)

-- Dừng Farm Button
MainSection:NewButton("⏹ DỪNG FARM", "Dừng auto farm rương", function()
    FarmEnabled = false
    print("Đã dừng farm rương")
end)

-- Chuyển Server Button
MainSection:NewButton("🔄 CHUYỂN SERVER", "Chuyển sang server khác", function()
    TeleportService:Teleport(game.PlaceId)
end)

-- Settings Tab
local SettingsTab = Window:NewTab("Cài đặt")
local SettingsSection = SettingsTab:NewSection("Tùy Chỉnh")

-- Speed Slider
SettingsSection:NewSlider("Tốc Độ Di Chuyển", "Điều chỉnh tốc độ tween", 500, 50, function(s)
    Speed = s
    print("Tốc độ: " .. Speed)
end)

-- Sea Info
local InfoTab = Window:NewTab("Thông tin")
local InfoSection = InfoTab:NewSection("Vùng Biển")

InfoSection:NewLabel("Đang ở Sea: " .. (First_Sea and "Sea 1" or Second_Sea and "Sea 2" or Third_Sea and "Sea 3" or "Không xác định"))
InfoSection:NewLabel("Tốc độ hiện tại: " .. Speed)
InfoSection:NewLabel("Trạng thái: " .. (FarmEnabled and "ĐANG FARM" or "ĐANG DỪNG"))

-- Auto Farm Loop
spawn(function()
    while task.wait(0.5) do
        if FarmEnabled then
            pcall(function()
                local character = LocalPlayer.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local currentPos = hrp.Position
                local closestChest = nil
                local closestDist = math.huge

                -- Quét tìm rương
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:IsA("Part") and v.Name:find("Chest") then
                        local chestPos = v.Position
                        local dist = (chestPos - currentPos).Magnitude

                        if dist < closestDist then
                            closestDist = dist
                            closestChest = v
                        end
                    end
                end

                -- Di chuyển đến rương gần nhất
                if closestChest then
                    local distance = closestDist
                    local duration = distance / Speed
                    local info = TweenInfo.new(
                        duration,
                        Enum.EasingStyle.Linear
                    )

                    local tween = TweenService:Create(
                        hrp,
                        info,
                        { CFrame = closestChest.CFrame * CFrame.new(0, 2, 0) }
                    )

                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(1)
                end
            end)
        end
    end
end)

-- Keybind
Library:CreateKeybind("Toggle Farm", Enum.KeyCode.F, function()
    FarmEnabled = not FarmEnabled
    print("Farm: " .. (FarmEnabled and "ON" or "OFF"))
end)

print("Đã tải KhDang Auto Chest V1.8 thành công!")