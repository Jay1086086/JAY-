--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jay1086086/-/44ab5e1a4715c032f688d94def0b1a3abd86dde7/untitled.lua"))()

-- Create Main Window
local Window = Library:Window({
    Title = "JAY HUB",
    Desc = "感谢支持",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 350)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "打开/关闭"
    }
})

-- Sidebar Vertical Separator
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0) -- adjust if needed
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui") -- Or Window.Gui if accessible

-- Tab
local Tab = Window:Tab({Title = "主页", Icon = "star"}) do
    -- Section
    Tab:Section({Title = "By JAY\n免费脚本.禁止倒卖"})

    -- Button
     Tab:Button({
        Title = "感谢牢汤.风之子.WM的支持",
        Desc = "也感谢其他赞助商",
        Callback = function()
        print("Button clicked!")
            Window:Notify({
                Title = "你老点啥🤓",
                Desc = "",
                Time = 1
            })
        end
    })

    -- Slider
    Tab:Slider({
        Title = "划着玩",
        Min = 0,
        Max = 100,
        Rounding = 0,
        Value = 25,
        Callback = function(val)
            print("Slider:", val)
        end
    })

    -- Code Display
    local CodeBlock = Tab:Code({
        Title = "下方QQ群",
        Code = "-- 1049557594\n玩Jay进QQ群')"
    })

    -- Simulate update
    task.delay(5, function()
            CodeBlock:SetCode("请加入QQ群\n1049557594")
    end)
end

-- Line Separator
Window:Line()

local InkGameTab = Window:Tab({Title = "通用功能", Icon = "wrench"})
do
    
    InkGameTab:Slider({
        Title = "设置速度",
        Min = 0,
        Max = 100,
        Rounding = 0,
        Value = 25,
        Callback = function(val)
            local player = game.Players.LocalPlayer
            
            local character = player.Character or player.CharacterAdded:Wait()
            
            local humanoid = character:WaitForChild("Humanoid", 10)
            
            if humanoid then
                humanoid.WalkSpeed = val
                print("人物行走速度已设置为:", val)
            else
                warn("10秒内未找到 Humanoid 对象，无法设置速度")
            end
        end
    })
end

    InkGameTab:Slider({
    Title = "设置跳跃高度",
    Min = 0,
    Max = 200, -- 跳跃力量的合理范围，可根据需要调整
    Rounding = 0,
    Value = 50, -- 初始跳跃力量，Roblox 默认一般是 50 左右
    Callback = function(val)
        -- 获取本地玩家的人物
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then
            character = player.CharacterAdded:Wait() -- 等待人物加载
        end
        -- 获取人类oid对象
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- 设置人类oid的跳跃力量，从而改变跳跃高度
            humanoid.JumpPower = val
            print("人物跳跃力量已设置为:", val)
        else
            print("未找到人类oid对象，无法设置跳跃高度")
        end
    end
})

    InkGameTab:Button({
    Title = "透视",
    Desc = "单击开启玩家透视",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        local highlightTemplate = Instance.new("Highlight")
        highlightTemplate.Name = "PlayerHighlight"
        highlightTemplate.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlightTemplate.FillColor = Color3.new(1, 0, 0)
        highlightTemplate.OutlineColor = Color3.new(1, 1, 1)
        highlightTemplate.FillTransparency = 0.5

        local function addHighlightToPlayer(player)
            local character = player.Character
            local characterLoaded = player.CharacterAdded:Wait(5)
            character = character or characterLoaded
            if not character then return warn("玩家" .. player.Name .. "角色加载超时，无法添加透视") end

            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return warn("玩家" .. player.Name .. "角色缺少 HumanoidRootPart") end

            if not humanoidRootPart:FindFirstChild(highlightTemplate.Name) then
                local highlightClone = highlightTemplate:Clone()
                highlightClone.Adornee = character
                highlightClone.Parent = humanoidRootPart
            end
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                addHighlightToPlayer(player)
            end
        end

        Players.PlayerAdded:Connect(function(newPlayer)
            if newPlayer ~= LocalPlayer then
                addHighlightToPlayer(newPlayer)
            end
        end)

        Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function(newCharacter)
                    addHighlightToPlayer(player)
                end)
            end
        end)

        Players.PlayerRemoving:Connect(function(leavingPlayer)
            local character = leavingPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local highlight = humanoidRootPart:FindFirstChild(highlightTemplate.Name)
                    if highlight then highlight:Destroy() end
                end
            end
        end)

        -- 7. 轻量化心跳检测：仅修复偶尔丢失的透视（原代码重复添加，优化为1秒检测一次）
        local lastCheckTime = os.clock()
        RunService.Heartbeat:Connect(function()
            -- 控制检测频率：1秒一次，避免频繁循环消耗性能
            if os.clock() - lastCheckTime >= 1 then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        addHighlightToPlayer(player)
                    end
                end
                lastCheckTime = os.clock()
            end
        end)

        print("透视功能已开启，所有玩家将显示高亮")
    end
})

-- Another Tab Example
local InkGameTab = Window:Tab({Title = "墨水游戏", Icon = "skull"})do
    InkGameTab:Section({Title = "英文防封", Icon = "wrench"})
    InkGameTab:Button({
        Title = "AX",
        Desc = "单击以执行",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/TexRBLX/Roblox-stuff/refs/heads/main/ink-game/script.lua"))()
        end
    })
end

    InkGameTab:Button({
    Title = "LT",
    Desc = "单击以执行",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/inkgames.github.io/refs/heads/main/ringta.lua"))()
    end
})

InkGameTab:Section({Title = "中文不知道防不防封", Icon = "wrench"})
InkGameTab:Button({
    Title = "AX中文",
    Desc = "单击以执行",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/墨水游戏.lua"))()
    end
})
local Extra = Window:Tab({Title = "死铁轨", Icon = "knife"})do
    Extra:Section({Title = "英文"})
    Extra:Button({
        Title = "JAY",
        Desc = "单击以执行",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/DEADRAILS.github.io/refs/heads/main/mainringta.lua"))()
        end
    })
end

-- Final Notification
Window:Notify({
    Title = "JAY HUB",
    Desc = "感谢您的游玩",
    Time = 5
})
-- 连接脚本的 Destroying 信号，当脚本即将被销毁时触发回调
script.Destroying:Connect(function()
    Window:Notify({
        Title = "JAY HUB",
        Desc = "关闭",
        Time = 5
    })
end)
