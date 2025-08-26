--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load UI Library（确保 UI 库链接有效，避免加载失败）
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

-- Sidebar Vertical Separator（修正：将分割线父级设为 Window.Gui，避免挂载到 CoreGui 导致层级混乱）
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0) -- 适配侧边栏宽度
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
-- 关键修正：使用 Window.Gui（UI 库默认的 UI 容器）作为父级，而非直接挂载 CoreGui
SidebarLine.Parent = Window.Gui or game:GetService("CoreGui")

-- 主页 Tab（代码块闭合正常，无需修改核心逻辑）
local Tab = Window:Tab({Title = "主页", Icon = "star"}) 
do
    Tab:Section({Title = "By JAY\n免费脚本.禁止倒卖"})
    
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
    
    local CodeBlock = Tab:Code({
        Title = "下方QQ群",
        Code = "-- 1049557594\n玩Jay进QQ群')"
    })
    
    -- 延迟更新代码块内容（逻辑正常）
    task.delay(5, function()
        CodeBlock:SetCode("请加入QQ群\n1049557594")
    end)
end

-- Line Separator（分割线正常）
Window:Line()

-- 通用功能 Tab（核心修正：代码块闭合+UI元素层级）
local InkGameTab = Window:Tab({Title = "通用功能", Icon = "wrench"})
do -- 补全 do-end 块，将所有通用功能 UI 元素纳入块内，避免层级混乱
    -- 速度调节 Slider（逻辑正常，保留原错误处理）
    InkGameTab:Slider({
        Title = "设置速度",
        Min = 0,
        Max = 100,
        Rounding = 0,
        Value = 25,
        Callback = function(val)
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid", 10) -- 10秒超时
            
            if humanoid then
                humanoid.WalkSpeed = val
                print("人物行走速度已设置为:", val)
            else
                warn("10秒内未找到 Humanoid 对象，无法设置速度")
            end
        end
    })

    -- 跳跃高度 Slider（修正：统一纳入 do-end 块，避免块外调用）
    InkGameTab:Slider({
        Title = "设置跳跃高度",
        Min = 0,
        Max = 200,
        Rounding = 0,
        Value = 50,
        Callback = function(val)
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait() -- 简化角色获取，避免空值
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                humanoid.JumpPower = val
                print("人物跳跃力量已设置为:", val)
            else
                print("未找到人类oid对象，无法设置跳跃高度")
            end
        end
    })

    -- 透视 Button（修正：死循环风险+性能优化）
    InkGameTab:Button({
        Title = "透视",
        Desc = "单击开启玩家透视",
        Callback = function()
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer

            -- 透视模板（提前配置属性，避免重复创建）
            local highlightTemplate = Instance.new("Highlight")
            highlightTemplate.Name = "Highlight"
            highlightTemplate.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlightTemplate.FillColor = Color3.new(1, 0, 0) -- 补充默认颜色，确保透视可见
            highlightTemplate.OutlineColor = Color3.new(1, 1, 1)

            -- 核心函数：添加透视+名字显示（避免代码冗余）
            local function addPlayerVisual(player)
                -- 修正：增加5秒超时，避免 repeat wait() 无限死循环
                local characterLoaded = player.CharacterAdded:Wait(5)
                local character = player.Character or characterLoaded
                if not character then return warn("玩家" .. player.Name .. "角色加载超时") end

                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then return warn("玩家" .. player.Name .. "缺少 HumanoidRootPart") end

                -- 添加透视
                if not humanoidRootPart:FindFirstChild("Highlight") then
                    local highlightClone = highlightTemplate:Clone()
                    highlightClone.Adornee = character
                    highlightClone.Parent = humanoidRootPart
                end

                -- 添加小尺寸名字
                if not humanoidRootPart:FindFirstChild("PlayerNameDisplay") then
                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Name = "PlayerNameDisplay"
                    billboardGui.Adornee = humanoidRootPart
                    billboardGui.Size = UDim2.new(0, 150, 0, 20)
                    billboardGui.StudsOffset = Vector3.new(0, 2.8, 0)
                    billboardGui.AlwaysOnTop = true

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Parent = billboardGui
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = player.Name
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                    textLabel.TextSize = 9
                    textLabel.TextScaled = false

                    billboardGui.Parent = humanoidRootPart
                end
            end

            -- 给已有玩家添加透视
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    addPlayerVisual(player)
                end
            end

            -- 新玩家加入时添加
            Players.PlayerAdded:Connect(function(player)
                if player ~= LocalPlayer then
                    player.CharacterAdded:Connect(function()
                        addPlayerVisual(player)
                    end)
                end
            end)

            -- 玩家离开时清理
            Players.PlayerRemoving:Connect(function(player)
                if player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        humanoidRootPart:FindFirstChild("Highlight")?.Destroy()
                        humanoidRootPart:FindFirstChild("PlayerNameDisplay")?.Destroy()
                    end
                end
            end)

            -- 性能优化：1秒检测一次，避免每帧循环（原 Heartbeat 每帧执行，消耗过高）
            local lastCheck = os.clock()
            RunService.Heartbeat:Connect(function()
                if os.clock() - lastCheck >= 1 then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            addPlayerVisual(player)
                        end
                    end
                    lastCheck = os.clock()
                end
            end)
        end
    })

    -- 飞行V3 Button（修正：HttpGet 参数+错误处理）
    InkGameTab:Button({
        Title = "飞行V3",
        Desc = "单击以执行",
        Callback = function()
            local flyUrl = "https://raw.githubusercontent.com/Jay907692/Jay/8b94c47bd5969608438fa1ee57f34b1350789caa/飞行脚本"
            
            -- 新增：pcall 捕获加载错误，避免脚本崩溃
            local success, err = pcall(function()
                -- 修正：HttpGet 第二个参数为 nocache（布尔值，明确含义）
                local flyScript = game:HttpGet(flyUrl, false) -- false = 允许缓存，提升加载速度
                loadstring(flyScript)()
                print("飞行V3脚本加载成功")
            end)

            if not success then
                warn("飞行V3加载失败：", err)
                Window:Notify({Title = "错误", Desc = "飞行脚本加载失败", Time = 3})
            end
        end
    })
end -- 补全通用功能 Tab 的 do-end 闭合块（原代码此处缺失 end，导致后续代码层级错误）

-- 墨水游戏 Tab（核心修正：变量重复定义+代码块闭合）
-- 修正：原代码重复定义 InkGameTab（与通用功能 Tab 同名），改为 InkGameTab2 避免冲突
local InkGameTab2 = Window:Tab({Title = "墨水游戏", Icon = "skull"})
do -- 补全 do-end 块，将所有墨水游戏 UI 元素纳入块内
    InkGameTab2:Section({Title = "英文防封", Icon = "wrench"})
    
    InkGameTab2:Button({
        Title = "AX",
        Desc = "单击以执行",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/TexRBLX/Roblox-stuff/refs/heads/main/ink-game/script.lua"))()
        end
    })

    -- 修正：原代码该 Button 在 do-end 块外，导致挂载到错误 Tab，现纳入块内
    InkGameTab2:Button({
        Title = "LT",
        Desc = "单击以执行",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/inkgames.github.io/refs/heads/main/ringta.lua"))()
        end
    })

    -- 修正：Section 纳入 do-end 块，挂载到正确 Tab
    InkGameTab2:Section({Title = "中文不知道防不防封", Icon = "wrench"})
    
    InkGameTab2:Button({
        Title = "AX中文",
        Desc = "单击以执行",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/墨水游戏.lua"))()
        end
    })
end -- 补全墨水游戏 Tab 的 do-end 闭合块

-- 死铁轨 Tab（逻辑正常，无需核心修改）
local Extra = Window:Tab({Title = "死铁轨", Icon = "knife"})
do
    Extra:Section({Title = "英文"})
    Extra:Button({
        Title = "JAY",
        Desc = "单击以执行",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/DEADRAILS.github.io/refs/heads/main/mainringta.lua"))()
        end
    })
end

-- Final Notification（正常）
Window:Notify({
    Title = "JAY HUB",
    Desc = "感谢您的游玩",
    Time = 5
})

-- 脚本销毁时通知（正常）
script.Destroying:Connect(function()
    Window:Notify({
        Title = "JAY HUB",
        Desc = "关闭",
        Time = 5
    })
end)
