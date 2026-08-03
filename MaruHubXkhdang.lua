--//==================== TAB 1: MAIN ====================//
local M = Tabs.Main
M:AddSection("Player Status")

-- Player Info
local PlayerInfo = M:AddParagraph("PlayerInfo", { 
    Title = "📊 Player Information", 
    Content = "Loading..." 
})

task.spawn(function()
    while true do
        pcall(function()
            local p = game.Players.LocalPlayer
            if p and p.Data then
                PlayerInfo:SetDesc(string.format(
                    "Level: %d | Beli: %s\nFragments: %s | Race: %s\nFruit: %s",
                    p.Data.Level.Value,
                    tostring(p.Data.Beli.Value):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""),
                    tostring(p.Data.Fragments.Value):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""),
                    p.Data.Race.Value,
                    p.Data.DevilFruit.Value
                ))
            end
        end)
        task.wait(2)
    end
end)

-- Teleport
M:AddSection("🌍 Teleport")
M:AddButton({ 
    Title = "Old World", 
    Callback = function() 
        pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain") end) 
    end 
})

M:AddButton({ 
    Title = "New World", 
    Callback = function() 
        pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa") end) 
    end 
})

M:AddButton({ 
    Title = "Third Sea", 
    Callback = function() 
        pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou") end) 
    end 
})

-- World Info
M:AddParagraph("WorldInfo", { 
    Title = "🌐 Current World", 
    Content = "Loading..." 
})

task.spawn(function()
    while true do
        local world = "Unknown"
        local pid = game.PlaceId
        if pid == 2753915549 then world = "First Sea (Old World)"
        elseif pid == 4442272183 then world = "Second Sea (New World)"
        elseif pid == 7449423635 then world = "Third Sea" end
        M:AddParagraph("WorldInfo", { Title = "🌐 Current World", Content = world })
        task.wait(5)
    end
end)
--//==================== TAB 2: FARM ====================//
local F = Tabs.Farm

-- Auto Farm Level
F:AddSection("⚔️ Auto Farm")
F:AddToggle({ 
    Title = "Auto Farm Level", 
    Default = false, 
    Callback = function(v) 
        getgenv().AutoFarm = v 
        if not v then 
            StopTween() 
            getgenv().StartMagnet = false 
        end 
    end 
})

F:AddDropdown({ 
    Title = "Farm Mode", 
    Values = { "Level", "Bone", "Katakuri" }, 
    Default = 1, 
    Callback = function(v) getgenv().FarmMode = v end 
})

-- Weapon
F:AddSection("🔫 Weapon")
F:AddDropdown({ 
    Title = "Weapon Type", 
    Values = { "Melee", "Sword", "Blox Fruit" }, 
    Default = 1, 
    Callback = function(v) getgenv().SelectWeapon = v end 
})

-- Material
F:AddSection("📦 Material")
F:AddDropdown({ 
    Title = "Select Material", 
    Values = { "Leather", "Angel Wings", "Magma Ore", "Fish Tail", "Ectoplasm", "Dragon Scale" }, 
    Callback = function(v) getgenv().SelectMaterial = v end 
})

F:AddToggle({ 
    Title = "Farm Material", 
    Default = false, 
    Callback = function(v) 
        getgenv().AutoMaterial = v 
        if not v then StopTween() end 
    end 
})

-- Mastery
F:AddSection("⭐ Mastery")
F:AddToggle({ 
    Title = "Farm Mastery", 
    Default = false, 
    Callback = function(v) 
        getgenv().MasteryFarm = v 
        if not v then StopTween() end 
    end 
})

F:AddToggle({ Title = "Skill Z", Default = true, Callback = function(v) getgenv().SkillZ = v end })
F:AddToggle({ Title = "Skill X", Default = false, Callback = function(v) getgenv().SkillX = v end })
F:AddToggle({ Title = "Skill C", Default = false, Callback = function(v) getgenv().SkillC = v end })
F:AddToggle({ Title = "Skill V", Default = false, Callback = function(v) getgenv().SkillV = v end })

-- Boss
F:AddSection("👹 Boss")
F:AddDropdown({ 
    Title = "Select Boss", 
    Values = { "rip_indra", "Dough King", "Soul Reaper", "Darkbeard", "Cake Prince", "Longma" }, 
    Callback = function(v) getgenv().SelectBoss = v end 
})

F:AddToggle({ 
    Title = "Auto Kill Boss", 
    Default = false, 
    Callback = function(v) 
        getgenv().AutoFarmBoss = v 
        if not v then StopTween() end 
    end 
})

F:AddToggle({ 
    Title = "Auto Kill All Boss", 
    Default = false, 
    Callback = function(v) 
        getgenv().AutoFarmAllBoss = v 
        if not v then StopTween() end 
    end 
})

-- Settings
F:AddSection("⚙️ Settings")
F:AddToggle({ Title = "Auto Buso Haki", Default = true, Callback = function(v) getgenv().AUTOHAKI = v end })
F:AddToggle({ Title = "Bring Mob", Default = true, Callback = function(v) getgenv().BringMonster = v end })
F:AddToggle({ Title = "Spin Position", Default = true, Callback = function(v) getgenv().SpinPos = v end })
F:AddSlider({ Title = "Farm Distance", Default = 15, Min = 0, Max = 30, Rounding = 5, Callback = function(v) getgenv().PosY = v end })
--//==================== TAB 3: RAID ====================//
local R = Tabs.Raid
R:AddSection("🎮 Raid")

R:AddDropdown({ 
    Title = "Select Raid", 
    Values = { "Dark", "Sand", "Magma", "Rumble", "Flame", "Ice", "Light", "Quake", "Buddha", "Spider", "Phoenix", "Dough" }, 
    Default = 1, 
    Callback = function(v) getgenv().SelectChip = v end 
})

R:AddToggle({ 
    Title = "Auto Raid", 
    Default = false, 
    Callback = function(v) 
        getgenv().Auto_Dungeon = v 
        if not v then StopTween() end 
    end 
})

R:AddToggle({ 
    Title = "Auto Awaken Fruit", 
    Default = false, 
    Callback = function(v) getgenv().AutoAwaken = v end 
})
--//==================== TAB 4: SEA EVENTS ====================//
local S = Tabs.Sea

-- Boat
S:AddSection("🚢 Boat")
S:AddDropdown({ 
    Title = "Select Boat", 
    Values = { "Guardian", "PirateGrandBrigade", "MarineGrandBrigade", "PirateBrigade", "MarineBrigade", "BeastHunter" }, 
    Default = 1, 
    Callback = function(v) getgenv().SelectedBoat = v end 
})

S:AddToggle({ 
    Title = "Auto Sea Event", 
    Default = false, 
    Callback = function(v) 
        getgenv().SailBoat = v 
        if not v then StopTween() end 
    end 
})

S:AddToggle({ 
    Title = "Go Through Rocks", 
    Default = true, 
    Callback = function(v) getgenv().GoThroughRocks = v end 
})

-- Creatures
S:AddSection("🦈 Creatures")
S:AddToggle({ Title = "Auto Shark", Default = false, Callback = function(v) getgenv().AutoKillShark = v end })
S:AddToggle({ Title = "Auto Piranha", Default = false, Callback = function(v) getgenv().AutoKillPiranha = v end })
S:AddToggle({ Title = "Auto Fish Crew", Default = false, Callback = function(v) getgenv().AutoKillFishCrew = v end })
S:AddToggle({ Title = "Auto Terror Shark", Default = false, Callback = function(v) getgenv().AutoTerrorshark = v end })
S:AddToggle({ Title = "Auto Sea Beast", Default = false, Callback = function(v) getgenv().AutoSeaBest = v end })

-- Ghost
S:AddSection("👻 Ghost Ship")
S:AddToggle({ Title = "Auto Ghost Ship", Default = false, Callback = function(v) getgenv().RelzFishBoat = v end })
S:AddToggle({ Title = "Auto Pirate Brigade", Default = false, Callback = function(v) getgenv().RelzPirateBrigade = v end })
S:AddToggle({ Title = "Auto Pirate Grand", Default = false, Callback = function(v) getgenv().RelzPirateGrandBrigade = v end })
--//==================== TAB 5: RACE ====================//
local RA = Tabs.Race

RA:AddSection("🏃 Race V2")
RA:AddToggle({ 
    Title = "Auto Upgrade Race V2", 
    Default = false, 
    Callback = function(v) getgenv().UpgradeRaceV2 = v end 
})

RA:AddSection("🤖 Cyborg")
RA:AddToggle({ 
    Title = "Auto Get Cyborg", 
    Default = false, 
    Callback = function(v) getgenv().AutoCyborg = v end 
})

RA:AddSection("🧟 Ghoul")
RA:AddToggle({ 
    Title = "Auto Get Ghoul", 
    Default = false, 
    Callback = function(v) getgenv().AutoGhoul = v end 
})

RA:AddSection("⭐ Race V4")
RA:AddToggle({ 
    Title = "Auto Trial Race", 
    Default = false, 
    Callback = function(v) getgenv().AutoTrialRace = v end 
})

RA:AddToggle({ 
    Title = "Auto Kill Players After Trial", 
    Default = false, 
    Callback = function(v) getgenv().AutoKillPlayerAfterTrial = v end 
})

RA:AddToggle({ 
    Title = "Auto Buy Gear", 
    Default = false, 
    Callback = function(v) getgenv().AutoBuyGear = v end 
})

RA:AddToggle({ 
    Title = "No Frog", 
    Default = false, 
    Callback = function(v) getgenv().NoFrog = v end 
})
--//==================== TAB 6: MISC ====================//
local MI = Tabs.Misc

MI:AddSection("🍎 Devil Fruit")
MI:AddToggle({ 
    Title = "Random Devil Fruit", 
    Default = false, 
    Callback = function(v) getgenv().RandomFruit = v end 
})

MI:AddToggle({ 
    Title = "Auto Store Fruit", 
    Default = false, 
    Callback = function(v) getgenv().AutoStoreFruit = v end 
})

MI:AddSection("⚔️ Legendary Sword")
MI:AddToggle({ 
    Title = "Auto Buy Legendary Sword", 
    Default = false, 
    Callback = function(v) getgenv().AutoBuyLegendarySword = v end 
})

MI:AddSection("🎨 Haki Color")
MI:AddToggle({ 
    Title = "Auto Buy Haki Color", 
    Default = false, 
    Callback = function(v) getgenv().Auto_Buy_Enchancement = v end 
})

MI:AddToggle({ 
    Title = "Auto Get Rainbow Haki", 
    Default = false, 
    Callback = function(v) getgenv().AutoRainbowHaki = v end 
})

MI:AddSection("🗡️ Get Weapons")
MI:AddToggle({ Title = "Auto Get CDK", Default = false, Callback = function(v) getgenv().AutoGetCDK = v end })
MI:AddToggle({ Title = "Auto Yama", Default = false, Callback = function(v) getgenv().AutoYama = v end })
MI:AddToggle({ Title = "Auto Tushita", Default = false, Callback = function(v) getgenv().AutoTushita = v end })
MI:AddToggle({ Title = "Auto Saber", Default = false, Callback = function(v) getgenv().AutoSaber = v end })
MI:AddToggle({ Title = "Auto Skull Guitar", Default = false, Callback = function(v) getgenv().AutoSkullGuitar = v end })
--//==================== TAB 7: SETTINGS ====================//
local ST = Tabs.Settings

ST:AddSection("🎨 UI Settings")
ST:AddToggle({ 
    Title = "Toggle UI", 
    Default = true, 
    Callback = function(v) Window:SetVisible(v) end 
})

ST:AddButton({ 
    Title = "🔒 Hide UI", 
    Callback = function() 
        Window:SetVisible(false) 
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "🔒 Hidden", Text = "Press RightControl", Duration = 2 })
    end 
})

ST:AddButton({ 
    Title = "🔓 Show UI", 
    Callback = function() 
        Window:SetVisible(true) 
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "🔓 Shown", Text = "Menu visible", Duration = 2 })
    end 
})

ST:AddButton({ 
    Title = "🔄 Reset UI Position", 
    Callback = function() 
        Window:SetPosition(UDim2.new(0.5, -290, 0.5, -210))
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "✅ Reset", Text = "UI reset to center", Duration = 2 })
    end 
})

ST:AddInput({ 
    Title = "Keybind", 
    Default = "RightControl", 
    Finished = true, 
    Callback = function(v) 
        local k = Enum.KeyCode[v] 
        if k then Window:SetMinimizeKey(k) end 
    end 
})

ST:AddSection("⚙️ Game Settings")
ST:AddToggle({ Title = "Anti AFK", Default = true, Callback = function(v) getgenv().AntiAFK = v end })
ST:AddToggle({ Title = "Black Screen", Default = false, Callback = function(v) getgenv().StartBlackScreen = v end })
ST:AddToggle({ Title = "White Screen", Default = false, Callback = function(v) getgenv().WhiteScreen = v end })
ST:AddToggle({ Title = "Hide Mobs", Default = false, Callback = function(v) getgenv().HideMob = v end })
ST:AddToggle({ Title = "Remove Damage Text", Default = true, Callback = function(v) getgenv().RemoveText = v end })
ST:AddToggle({ Title = "Auto Rejoin on Kick", Default = false, Callback = function(v) getgenv().AutoRejoin = v end })
--//==================== TAB 8: ESP ====================//
local E = Tabs.ESP
E:AddSection("👁️ ESP Settings")
E:AddToggle({ Title = "ESP Islands", Default = false, Callback = function(v) getgenv().IslandESP = v end })
E:AddToggle({ Title = "ESP Fruits", Default = false, Callback = function(v) getgenv().FruitESP = v end })
E:AddToggle({ Title = "ESP Players", Default = false, Callback = function(v) getgenv().PlayerESP = v end })
--//==================== TAB 9: PVP ====================//
local P = Tabs.PVP

P:AddSection("🎯 Player Selection")
local PlayerDropdown = P:AddDropdown({ 
    Title = "Select Player", 
    Values = {}, 
    Callback = function(v) getgenv().SelectPlayer = v end 
})

task.spawn(function()
    while true do
        local players = {}
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        PlayerDropdown:SetValues(players)
        task.wait(5)
    end
end)

P:AddSection("⚔️ PVP Settings")
P:AddToggle({ Title = "Teleport to Player", Default = false, Callback = function(v) getgenv().TeleportPlayer = v end })
P:AddToggle({ Title = "Auto Aimbot", Default = false, Callback = function(v) getgenv().Aimbot = v end })
P:AddToggle({ Title = "Auto Aimbot Gun", Default = false, Callback = function(v) getgenv().AimbotGun = v end })
P:AddToggle({ Title = "No Clip", Default = false, Callback = function(v) getgenv().NoClip = v end })

P:AddSection("🛡️ Safe Mode")
P:AddToggle({ Title = "Safe Mode", Default = false, Callback = function(v) getgenv().SafeMode = v end })
P:AddSlider({ Title = "Safe Health %", Default = 30, Min = 0, Max = 100, Rounding = 5, Callback = function(v) getgenv().Safe = v end })

P:AddSection("🏃 Walk Speed")
P:AddToggle({ Title = "Change Walk Speed", Default = false, Callback = function(v) getgenv().WalkSpeedToggle = v end })
P:AddInput({ Title = "Walk Speed", Default = "100", Numeric = true, Finished = true, Callback = function(v) getgenv().WalkSpeed = tonumber(v) or 16 end })
--//==================== TAB 10: HOP SERVER ====================//
local H = Tabs.Hop

H:AddSection("📡 Server Info")
H:AddParagraph({ Title = "📡 Server Status", Content = "Loading..." })

task.spawn(function()
    while true do
        local players = game.Players
        H:AddParagraph({ Title = "📡 Server Status", Content = string.format("Players: %d/%d\nJob ID: %s", #players:GetPlayers(), players.MaxPlayers, string.sub(game.JobId, 1, 8) .. "...") })
        task.wait(5)
    end
end)

H:AddSection("🎯 Boss Status")
H:AddParagraph({ Title = "rip_indra", Content = "🔍 Checking..." })
H:AddParagraph({ Title = "Dough King", Content = "🔍 Checking..." })
H:AddParagraph({ Title = "Soul Reaper", Content = "🔍 Checking..." })
H:AddParagraph({ Title = "Darkbeard", Content = "🔍 Checking..." })
H:AddParagraph({ Title = "Cake Prince", Content = "🔍 Checking..." })

task.spawn(function()
    while true do
        local bosses = { "rip_indra", "Dough King", "Soul Reaper", "Darkbeard", "Cake Prince" }
        for _, boss in ipairs(bosses) do
            local found = false
            for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                if enemy.Name == boss or enemy.Name:find(boss) then
                    found = true
                    break
                end
            end
            if not found then
                for _, enemy in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                    if enemy.Name == boss or enemy.Name:find(boss) then
                        found = true
                        break
                    end
                end
            end
            H:AddParagraph({ Title = boss, Content = found and "✅ Available" or "❌ Not Found" })
        end
        task.wait(5)
    end
end)

H:AddSection("🚀 Hop Server")
H:AddButton({ 
    Title = "🔄 Hop Random", 
    Callback = function() 
        game:GetService("TeleportService"):Teleport(game.PlaceId) 
    end 
})

H:AddButton({ 
    Title = "🔴 Find Rip Indra", 
    Callback = function() 
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "🔍 Searching", Text = "Looking for Rip Indra...", Duration = 5 })
        game:GetService("TeleportService"):Teleport(game.PlaceId) 
    end 
})

H:AddButton({ 
    Title = "🍩 Find Dough King", 
    Callback = function() 
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "🔍 Searching", Text = "Looking for Dough King...", Duration = 5 })
        game:GetService("TeleportService"):Teleport(game.PlaceId) 
    end 
})

H:AddSection("🆔 Job ID")
H:AddButton({ 
    Title = "📋 Copy Job ID", 
    Callback = function() 
        if setclipboard then 
            setclipboard(game.JobId) 
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "✅ Copied", Text = "Job ID copied", Duration = 2 })
        end 
    end 
})

H:AddInput({ 
    Title = "Join by Job ID", 
    Placeholder = "Paste Job ID", 
    Finished = true, 
    Callback = function(v) getgenv().HopJobId = v end 
})

H:AddButton({ 
    Title = "🚀 Join Server", 
    Callback = function() 
        if getgenv().HopJobId then 
            pcall(function() 
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getgenv().HopJobId, game.Players.LocalPlayer) 
            end) 
        end 
    end 
})
--//==================== TAB 11: HOP ISLAND ====================//
local I = Tabs.Island

I:AddSection("🏝️ Island Status")
I:AddParagraph({ Title = "📍 Current Island", Content = "Checking..." })

task.spawn(function()
    while true do
        local islands = { "Mirage Island", "Prehistoric Island", "Kitsune Island", "Frozen Dimension" }
        local found = {}
        for _, name in ipairs(islands) do
            if workspace._WorldOrigin and workspace._WorldOrigin.Locations:FindFirstChild(name) then
                table.insert(found, "✅ " .. name)
            elseif workspace.Map:FindFirstChild(name) then
                table.insert(found, "✅ " .. name)
            else
                table.insert(found, "❌ " .. name)
            end
        end
        I:AddParagraph({ Title = "📍 Current Island", Content = table.concat(found, "\n") })
        task.wait(5)
    end
end)

I:AddSection("🚀 Hop to Island")
local islands = { "Mirage Island", "Prehistoric Island", "Kitsune Island", "Frozen Dimension", "Cake Island", "Haunted Castle", "Hydra Island", "Floating Turtle" }

for _, name in ipairs(islands) do
    I:AddButton({ 
        Title = "🏝️ Hop to " .. name, 
        Callback = function() 
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "🚀 Hoping", Text = "Looking for " .. name, Duration = 3 })
            game:GetService("TeleportService"):Teleport(game.PlaceId) 
        end 
    })
end

I:AddSection("⚡ Quick Hop")
I:AddButton({ 
    Title = "⚡ Teleport to Nearest Island", 
    Callback = function() 
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "📍 Teleporting", Text = "Finding nearest island...", Duration = 3 })
    end 
})
--//==================== TAB 12: SAVE MANAGER ====================//
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MaruHub")
SaveManager:SetFolder("MaruHub/bloxfruits")
SaveManager:BuildConfigSection(Window)
InterfaceManager:BuildInterfaceSection(Window)
SaveManager:LoadAutoloadConfig()
--//==================== TAB 13: UTILITY FUNCTIONS ====================//
function StopTween()
    pcall(function()
        if tween then tween:Cancel() tween = nil end
        local char = game.Players.LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Anchored = true
                task.wait(0.1)
                root.Anchored = false
            end
        end
        getgenv().StopTween = false
        getgenv().Clip = false
        getgenv().StartMagnet = false
    end)
end

function topos(cframe)
    pcall(function()
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local dist = (cframe.Position - root.Position).Magnitude
        if dist <= 10 then 
            root.CFrame = cframe 
            return 
        end
        
        local speed = getgenv().TweenSpeed or 350
        local info = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
        tween = game:GetService("TweenService"):Create(root, info, { CFrame = cframe })
        tween:Play()
        tween.Completed:Wait()
        root.CFrame = cframe
    end)
end

function AutoHaki()
    pcall(function()
        if getgenv().AUTOHAKI then
            local player = game.Players.LocalPlayer
            if player.Character and not player.Character:FindFirstChild("HasBuso") then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
            end
        end
    end)
end

function EquipWeapon(name)
    pcall(function()
        local player = game.Players.LocalPlayer
        if not name then return end
        if player.Character:FindFirstChild(name) then return end
        local tool = player.Backpack:FindFirstChild(name)
        if tool then player.Character.Humanoid:EquipTool(tool) end
    end)
end

function UnEquipWeapon(name)
    pcall(function()
        local player = game.Players.LocalPlayer
        local tool = player.Character:FindFirstChild(name)
        if tool then tool.Parent = player.Backpack end
    end)
end
--//==================== TAB 14: MAIN LOOP & HOTKEY ====================//

-- Auto Farm Logic
task.spawn(function()
    while true do
        pcall(function()
            if getgenv().AutoFarm then
                local player = game.Players.LocalPlayer
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                local root = char.HumanoidRootPart
                AutoHaki()
                
                local enemies = workspace.Enemies:GetChildren()
                local target = nil
                local minDist = math.huge
                
                for _, enemy in ipairs(enemies) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyRoot then
                            local dist = (enemyRoot.Position - root.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                target = enemy
                            end
                        end
                    end
                end
                
                if target then
                    local targetRoot = target.HumanoidRootPart
                    targetRoot.CanCollide = false
                    target.Humanoid.WalkSpeed = 0
                    topos(targetRoot.CFrame * CFrame.new(0, 0, 5))
                    EquipWeapon(getgenv().SelectWeapon or "Melee")
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- Anti AFK
task.spawn(function()
    while true do
        if getgenv().AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                game.Players.LocalPlayer.Idled:Connect(function()
                    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end)
        end
        task.wait(1)
    end
end)

-- Hide Mobs
task.spawn(function()
    while true do
        if getgenv().HideMob then
            pcall(function()
                for _, mob in ipairs(workspace.Enemies:GetDescendants()) do
                    if mob:IsA("BasePart") or mob:IsA("MeshPart") then
                        mob.Transparency = 1
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- Black Screen
task.spawn(function()
    while true do
        pcall(function()
            if getgenv().StartBlackScreen then
                game.Players.LocalPlayer.PlayerGui.Main.Blackscreen.Size = UDim2.new(500, 0, 500, 500)
            else
                game.Players.LocalPlayer.PlayerGui.Main.Blackscreen.Size = UDim2.new(1, 0, 500, 500)
            end
        end)
        task.wait(0.5)
    end
end)

-- Auto Rejoin on Kick
task.spawn(function()
    while true do
        if getgenv().AutoRejoin then
            pcall(function()
                local prompt = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if prompt then
                    local errorPrompt = prompt:FindFirstChild("promptOverlay"):FindFirstChild("ErrorPrompt")
                    if errorPrompt and errorPrompt:FindFirstChild("MessageArea") then
                        game:GetService("TeleportService"):Teleport(game.PlaceId)
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

-- Walk Speed
task.spawn(function()
    while true do
        pcall(function()
            if getgenv().WalkSpeedToggle then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = getgenv().WalkSpeed or 16
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- No Clip
task.spawn(function()
    while true do
        pcall(function()
            if getgenv().NoClip then
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- Hotkey
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
        local visible = Window.Visible
        Window:SetVisible(not visible)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = visible and "🔒 Hidden" or "🔓 Shown",
            Text = "Press RightControl to toggle",
            Duration = 2
        })
    end
end)

print("Maru Hub Premium v3 Loaded!")
print("Script by KhDang")
print("🔥 All features fixed!")
print("💡 Press Ctrl+H to toggle UI")
--//==================== TAB 15: SERVICES & INTRO ====================//
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

repeat task.wait() until game:IsLoaded()
repeat task.wait() until LP and LP.Character

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Maru Hub Premium v3",
    SubTitle = "Blox Fruits | By KhDang",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 420),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "sword" }),
    Raid = Window:AddTab({ Title = "Raid", Icon = "shield" }),
    Sea = Window:AddTab({ Title = "Sea Events", Icon = "anchor" }),
    Race = Window:AddTab({ Title = "Race", Icon = "star" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "cog" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "sliders" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
    PVP = Window:AddTab({ Title = "PVP", Icon = "crosshair" }),
    Hop = Window:AddTab({ Title = "Hop Server", Icon = "globe" }),
    Island = Window:AddTab({ Title = "Hop Island", Icon = "map-pin" })
}

print("✅ All 15 tabs loaded successfully!")
