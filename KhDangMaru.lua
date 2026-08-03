--//MARU HUB V3 - BY KHDANG
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({Title="Maru Hub Premium v3",SubTitle="Blox Fruits | By KhDang",TabWidth=160,Size=UDim2.fromOffset(580,420),Acrylic=true,Theme="Darker",MinimizeKey=Enum.KeyCode.RightControl})

local Tabs = {
    Main = Window:AddTab({Title="Main",Icon="home"}),
    Farm = Window:AddTab({Title="Farm",Icon="sword"}),
    Raid = Window:AddTab({Title="Raid",Icon="shield"}),
    Sea = Window:AddTab({Title="Sea Events",Icon="anchor"}),
    Race = Window:AddTab({Title="Race",Icon="star"}),
    Misc = Window:AddTab({Title="Misc",Icon="cog"}),
    Settings = Window:AddTab({Title="Settings",Icon="sliders"}),
    ESP = Window:AddTab({Title="ESP",Icon="eye"}),
    PVP = Window:AddTab({Title="PVP",Icon="crosshair"}),
    Hop = Window:AddTab({Title="Hop Server",Icon="globe"}),
    Island = Window:AddTab({Title="Hop Island",Icon="map-pin"})
}

-- MAIN TAB
local M = Tabs.Main
M:AddSection("Status")
M:AddParagraph({Title="Player Info",Content="Loading..."})
M:AddSection("Teleport")
M:AddButton({Title="Old World",Callback=function()game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")end})
M:AddButton({Title="New World",Callback=function()game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")end})
M:AddButton({Title="Third Sea",Callback=function()game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")end})

-- FARM TAB
local F = Tabs.Farm
F:AddSection("Farm")
F:AddToggle({Title="Auto Farm",Default=false,Callback=function(v)getgenv().AutoFarm=v end})
F:AddDropdown({Title="Farm Mode",Values={"Level","Bone","Katakuri"},Default=1,Callback=function(v)getgenv().FarmMode=v end})
F:AddSection("Weapon")
F:AddDropdown({Title="Weapon",Values={"Melee","Sword","Blox Fruit"},Default=1,Callback=function(v)getgenv().SelectWeapon=v end})
F:AddSection("Material")
F:AddDropdown({Title="Material",Values={"Leather","Angel Wings","Magma Ore","Fish Tail"},Callback=function(v)getgenv().SelectMaterial=v end})
F:AddToggle({Title="Farm Material",Default=false,Callback=function(v)getgenv().AutoMaterial=v end})
F:AddSection("Mastery")
F:AddToggle({Title="Farm Mastery",Default=false,Callback=function(v)getgenv().MasteryFarm=v end})
F:AddToggle({Title="Skill Z",Default=true,Callback=function(v)getgenv().SkillZ=v end})
F:AddToggle({Title="Skill X",Default=false,Callback=function(v)getgenv().SkillX=v end})
F:AddToggle({Title="Skill C",Default=false,Callback=function(v)getgenv().SkillC=v end})
F:AddSection("Boss")
F:AddDropdown({Title="Select Boss",Values={"rip_indra","Dough King","Soul Reaper","Darkbeard","Cake Prince"},Callback=function(v)getgenv().SelectBoss=v end})
F:AddToggle({Title="Auto Kill Boss",Default=false,Callback=function(v)getgenv().AutoFarmBoss=v end})

-- RAID TAB
local R = Tabs.Raid
R:AddSection("Raid")
R:AddDropdown({Title="Select Raid",Values={"Dark","Sand","Magma","Rumble","Flame","Ice","Light","Quake","Buddha","Spider","Phoenix","Dough"},Default=1,Callback=function(v)getgenv().SelectChip=v end})
R:AddToggle({Title="Auto Raid",Default=false,Callback=function(v)getgenv().Auto_Dungeon=v end})
R:AddToggle({Title="Auto Awaken",Default=false,Callback=function(v)getgenv().AutoAwaken=v end})

-- SEA TAB
local S = Tabs.Sea
S:AddSection("Boat")
S:AddDropdown({Title="Select Boat",Values={"Guardian","PirateGrandBrigade","MarineGrandBrigade"},Default=1,Callback=function(v)getgenv().SelectedBoat=v end})
S:AddToggle({Title="Auto Sea Event",Default=false,Callback=function(v)getgenv().SailBoat=v end})
S:AddSection("Creatures")
S:AddToggle({Title="Auto Shark",Default=false,Callback=function(v)getgenv().AutoKillShark=v end})
S:AddToggle({Title="Auto Sea Beast",Default=false,Callback=function(v)getgenv().AutoSeaBest=v end})

-- RACE TAB
local RA = Tabs.Race
RA:AddSection("Race")
RA:AddToggle({Title="Auto Upgrade Race V2",Default=false,Callback=function(v)getgenv().UpgradeRaceV2=v end})
RA:AddToggle({Title="Auto Get Cyborg",Default=false,Callback=function(v)getgenv().AutoCyborg=v end})
RA:AddToggle({Title="Auto Get Ghoul",Default=false,Callback=function(v)getgenv().AutoGhoul=v end})
RA:AddToggle({Title="Auto Trial Race V4",Default=false,Callback=function(v)getgenv().AutoTrialRace=v end})

-- MISC TAB
local MI = Tabs.Misc
MI:AddSection("Fruit")
MI:AddToggle({Title="Random Fruit",Default=false,Callback=function(v)getgenv().RandomFruit=v end})
MI:AddToggle({Title="Auto Store Fruit",Default=false,Callback=function(v)getgenv().AutoStoreFruit=v end})
MI:AddSection("Weapons")
MI:AddToggle({Title="Auto Get CDK",Default=false,Callback=function(v)getgenv().AutoGetCDK=v end})
MI:AddToggle({Title="Auto Yama",Default=false,Callback=function(v)getgenv().AutoYama=v end})
MI:AddToggle({Title="Auto Tushita",Default=false,Callback=function(v)getgenv().AutoTushita=v end})
MI:AddToggle({Title="Auto Saber",Default=false,Callback=function(v)getgenv().AutoSaber=v end})

-- SETTINGS TAB
local ST = Tabs.Settings
ST:AddSection("UI")
ST:AddToggle({Title="Toggle UI",Default=true,Callback=function(v)Window:SetVisible(v)end})
ST:AddButton({Title="Hide UI",Callback=function()Window:SetVisible(false)end})
ST:AddButton({Title="Show UI",Callback=function()Window:SetVisible(true)end})
ST:AddSection("Game")
ST:AddToggle({Title="Anti AFK",Default=true,Callback=function(v)getgenv().AntiAFK=v end})
ST:AddToggle({Title="Black Screen",Default=false,Callback=function(v)getgenv().StartBlackScreen=v end})
ST:AddToggle({Title="Hide Mobs",Default=false,Callback=function(v)getgenv().HideMob=v end})

-- ESP TAB
local E = Tabs.ESP
E:AddSection("ESP")
E:AddToggle({Title="ESP Islands",Default=false,Callback=function(v)getgenv().IslandESP=v end})
E:AddToggle({Title="ESP Fruits",Default=false,Callback=function(v)getgenv().FruitESP=v end})
E:AddToggle({Title="ESP Players",Default=false,Callback=function(v)getgenv().PlayerESP=v end})

-- PVP TAB
local P = Tabs.PVP
P:AddSection("Player")
P:AddDropdown({Title="Select Player",Values={},Callback=function(v)getgenv().SelectPlayer=v end})
P:AddSection("PVP")
P:AddToggle({Title="Teleport to Player",Default=false,Callback=function(v)getgenv().TeleportPlayer=v end})
P:AddToggle({Title="Auto Aimbot",Default=false,Callback=function(v)getgenv().Aimbot=v end})
P:AddToggle({Title="No Clip",Default=false,Callback=function(v)getgenv().NoClip=v end})

-- HOP SERVER TAB
local H = Tabs.Hop
H:AddSection("Hop")
H:AddButton({Title="Hop Random",Callback=function()game:GetService("TeleportService"):Teleport(game.PlaceId)end})
H:AddButton({Title="Find Rip Indra",Callback=function()game:GetService("TeleportService"):Teleport(game.PlaceId)end})
H:AddButton({Title="Find Dough King",Callback=function()game:GetService("TeleportService"):Teleport(game.PlaceId)end})
H:AddSection("Job ID")
H:AddButton({Title="Copy Job ID",Callback=function()if setclipboard then setclipboard(game.JobId)end end})
H:AddInput({Title="Join by Job ID",Placeholder="Paste Job ID",Finished=true,Callback=function(v)getgenv().HopJobId=v end})
H:AddButton({Title="Join Server",Callback=function()if getgenv().HopJobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,getgenv().HopJobId,game.Players.LocalPlayer)end end})

-- HOP ISLAND TAB
local I = Tabs.Island
I:AddSection("Islands")
local islands = {"Mirage Island","Prehistoric Island","Kitsune Island","Frozen Dimension","Cake Island","Haunted Castle","Hydra Island","Floating Turtle"}
for _,name in pairs(islands) do
    I:AddButton({Title="Hop to "..name,Callback=function()game:GetService("TeleportService"):Teleport(game.PlaceId)end})
end

-- UTILITIES
function StopTween()pcall(function()if tween then tween:Cancel()tween=nil end end)end
function topos(c)pcall(function()local r=game.Players.LocalPlayer.Character.HumanoidRootPart r.CFrame=c end)end
function AutoHaki()pcall(function()game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")end)end
function EquipWeapon(n)pcall(function()local t=game.Players.LocalPlayer.Backpack:FindFirstChild(n)if t then game.Players.LocalPlayer.Character.Humanoid:EquipTool(t)end end)end

-- HOTKEY
game:GetService("UserInputService").InputBegan:Connect(function(i,g)if g then return end if i.KeyCode==Enum.KeyCode.H and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl)then local v=Window.Visible Window:SetVisible(not v)end end)

print("Maru Hub Premium v3 Loaded!")
print("Script by KhDang")
print("Press Ctrl+H to toggle UI")
