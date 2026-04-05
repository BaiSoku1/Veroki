local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/BaiSoku1/NOT-Mine-UI/refs/heads/main/IDK.lua"))()

local Window = Library:Window({
    Title = "be a chef to become rich and famous",
    SubTitle = "by Syfa",
    Version = "v1.0"
})

local InfAllTab = Window:Tab("INF ALL", "💪")

InfAllTab:Toggle("Inf All (Auto Get Wins)", false, function(state)
    _G.GetWins = state
    while _G.GetWins do
        wait()
        
        local args = {"MadeVideoManually"}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_3"):FireServer(unpack(args))
        wait()
        
        local args2 = {"MadeVideoManually"}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_3"):FireServer(unpack(args2))
        wait()
        
        local args3 = {"MadeVideoManually"}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_3"):FireServer(unpack(args3))
        
        task.wait()
    end
end)

InfAllTab:Toggle("Auto Rebirth", false, function(state)
    _G.AutoRebirth = state
    while _G.AutoRebirth do
        wait()
        
        local args = {"BuyRebirth", 1}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_1"):FireServer(unpack(args))
        
        task.wait(1)
    end
end)

local UpgradesTab = Window:Tab("UPGRADES", "📈")

UpgradesTab:Button("Cooking Speed (Wifi)", "⚡", function()
    local args = {"Upgrade", "Wifi"}
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_2"):FireServer(unpack(args))
    Library:Notify("Upgrade", "Cooking Speed ditingkatkan!", 2)
end)

UpgradesTab:Button("Quantity of Food (ManualRev)", "🍽️", function()
    local args = {"Upgrade", "ManualRev"}
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_3"):FireServer(unpack(args))
    Library:Notify("Upgrade", "Quantity of Food ditingkatkan!", 2)
end)

UpgradesTab:Button("Better Management (FriendRev)", "👥", function()
    local args = {"Upgrade", "FriendRev"}
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_4"):FireServer(unpack(args))
    Library:Notify("Upgrade", "Better Management ditingkatkan!", 2)
end)

local InfoTab = Window:Tab("INFO", "ℹ️")

InfoTab:Button("Test Remote Connection", "🔌", function()
    local check1 = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent_1")
    local check2 = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent_2")
    local check3 = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent_3")
    local check4 = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent_4")
    
    local msg = string.format("RemoteEvent_1: %s\nRemoteEvent_2: %s\nRemoteEvent_3: %s\nRemoteEvent_4: %s",
        check1 and "✅ Ada" or "❌ Tidak Ada",
        check2 and "✅ Ada" or "❌ Tidak Ada",
        check3 and "✅ Ada" or "❌ Tidak Ada",
        check4 and "✅ Ada" or "❌ Tidak Ada"
    )
    
    Library:Notify("Status Remote", msg, 5)
end)

print("UI telah dimuat! Klik tombol bundar di kiri tengah layar untuk membuka.")
