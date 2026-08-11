--[[ 
    SYSTEM BY KHDANG BLOXFRUIT 
    LINK GET KEY: https://notevn.com/rd6fnhru
    KEY: FreeBananaCrack
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local UIGradient = Instance.new("UIGradient")
local Title = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")
local CopyBtn = Instance.new("TextButton")
local SubmitBtn = Instance.new("TextButton")

-- Cấu hình ScreenGui
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Khdang_Vip_System"

-- Khung Menu Chính (Giao diện Dark Mode Neon)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
MainFrame.Size = UDim2.new(0, 280, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Viền Neon chuyển màu cực đẹp
UIStroke.Parent = MainFrame
UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Transparency = 0.1

UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), -- Cyan
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)), -- Magenta
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
}
UIGradient.Parent = UIStroke

-- Tiêu đề Menu
Title.Parent = MainFrame
Title.Text = " SYSTEM VIP"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1

-- Ô nhập Key
KeyInput.Parent = MainFrame
KeyInput.PlaceholderText = "Nhập Key tại đây..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

-- Nút Sao chép Link GetKey
CopyBtn.Parent = MainFrame
CopyBtn.Text = "SAO CHÉP LINK GET KEY"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.BackgroundTransparency = 0.9
CopyBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
CopyBtn.Position = UDim2.new(0.1, 0, 0.58, 5)
CopyBtn.Size = UDim2.new(0.8, 0, 0, 25)
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 5)

-- Nút Kích hoạt (Xác nhận Key)
SubmitBtn.Parent = MainFrame
SubmitBtn.Text = "KÍCH HOẠT SCRIPT"
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
SubmitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.78, 10)
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 35)
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 10)

--- LOGIC LƯU KEY & XỬ LÝ ---

local fileName = "Khdang_SavedKey.txt"
local correctKey = "FreeBananaCrack"

-- Hàm tự động tải Script chính
local function ExecuteMainScript()
    SubmitBtn.Text = "ĐANG TẢI SCRIPT..."
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(1)
    ScreenGui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/x2RunE/Immortal/refs/heads/main/BananaCat-Loader.lua"))()
end

-- Tải Key đã lưu (nếu có)
if readfile and isfile and isfile(fileName) then
    local savedKey = readfile(fileName)
    KeyInput.Text = savedKey
    if savedKey == correctKey then
        task.spawn(function()
            ExecuteMainScript()
        end)
    end
end

-- 1. Chức năng sao chép link Link4M
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://notevn.com/rd6fnhru")
    end
    CopyBtn.Text = "ĐÃ COPY LINK!"
    task.wait(2)
    CopyBtn.Text = "SAO CHÉP LINK GET KEY"
end)

-- 2. Kiểm tra Key, Lưu Key và Chạy Script chính
SubmitBtn.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text
    
    if userKey == correctKey then
        if writefile then
            writefile(fileName, userKey)
        end
        ExecuteMainScript()
    else
        SubmitBtn.Text = "SAI KEY! HÃY GET KEY LẠI"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.wait(2)
        SubmitBtn.Text = "KÍCH HOẠT SCRIPT"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        SubmitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
end)