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

    local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
    InkGameTab:Slider({
        Title = "跳跃高度",
        Min = 0,
        Max = 200,
        Rounding = 1,
        Value = 30,
        Callback = function(jumpPower)
            local function setJumpPower(power)
                local character = localPlayer.Character
                if not character then return end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = power
                    print("跳跃高度已设置为:", power)
                end
            end
            
            setJumpPower(jumpPower)
               
            local characterAddedConn
            characterAddedConn = localPlayer.CharacterAdded:Connect(function(newCharacter)
                newCharacter:WaitForChild("Humanoid")
                setJumpPower(jumpPower)
            end)
        end
    })
end

localPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.JumpPower = 30
end)

-- Another Tab Example
local InkGameTab = Window:Tab({Title = "墨水游戏", Icon = "wrench"})do
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
local Extra = Window:Tab({Title = "死铁轨", Icon = "zombie"})do
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
