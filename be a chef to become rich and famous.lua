Load Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BaiSoku1/Fluent/refs/heads/main/Main.lua"))()

-- Buat jendela utama
local Window = UI:CreateWindow({
    Title = "be a chef to become rich and famous",
    Author = "by Syfa",
    Folder = "MyScriptGui"
})

-- ========== DATA TITIK JALAN ==========
-- Rute Dalam (20 step)
local waypointsInside = {
    -- Step 1-11 (Y = 3.639)
    Vector3.new(-86.90888214111328, 3.639427661895752, -113.71018981933594),
    Vector3.new(-95.5901870727539, 3.639427661895752, -142.36087036132812),
    Vector3.new(-57.2030029296875, 3.639427661895752, -133.78038024902344),
    Vector3.new(-51.15392303466797, 3.639427661895752, -134.73678588867188),
    Vector3.new(-73.45311737060547, 3.639427661895752, -115.35441589355469),
    Vector3.new(-84.0821533203125, 3.639427661895752, -81.41028594970703),
    Vector3.new(-100.10214233398438, 3.639427661895752, -99.6475601196289),
    Vector3.new(-107.39704895019531, 3.639427661895752, -136.1795196533203),
    Vector3.new(-109.2454833984375, 3.639427661895752, -51.67550277709961),
    Vector3.new(-105.86814880371094, 3.639427900314331, -62.388607025146484),
    Vector3.new(-111.84703063964844, 3.639427900314331, -73.41272735595703),
    -- Step 12-20 (Y = 39.009)
    Vector3.new(-111.39494323730469, 39.00942611694336, -140.4764404296875),
    Vector3.new(-69.41545867919922, 39.00942611694336, -107.04146575927734),
    Vector3.new(-81.14928436279297, 39.00942611694336, -87.13195037841797),
    Vector3.new(-78.05371856689453, 39.00942611694336, -45.3661003112793),
    Vector3.new(-100.46971893310547, 39.00942611694336, -80.14228057861328),
    Vector3.new(-121.02754974365234, 39.00942611694336, -58.760921478271484),
    Vector3.new(-123.31614685058594, 39.00942611694336, -58.717716217041016),
    Vector3.new(-67.1987075805664, 39.00942611694336, -77.54741668701172),
    Vector3.new(-70.63610076904297, 39.00942611694336, -58.24176788330078)
}

-- Rute Luar (11 step)
local waypointsOutside = {
    Vector3.new(-96.37279510498047, 3.639427900314331, -149.60223388671875),
    Vector3.new(-120.24635314941406, 3.3211658000946045, -163.92926025390625),
    Vector3.new(-141.14598083496094, 3.3211658000946045, -183.16322326660156),
    Vector3.new(-132.9196014404297, 3.3211658000946045, -207.00489807128906),
    Vector3.new(-137.9943084716797, 3.3211658000946045, -197.60398864746094),
    Vector3.new(-101.69084930419922, 3.3211658000946045, -208.40135192871094),
    Vector3.new(-95.8270034790039, 3.3211658000946045, -215.638916015625),
    Vector3.new(-113.84325408935547, 3.3211658000946045, -202.48350524902344),
    Vector3.new(-72.63587951660156, 3.3211658000946045, -216.2047119140625),
    Vector3.new(-38.911930084228516, 3.3211658000946045, -180.9898681640625),
    Vector3.new(-73.3825454711914, 3.3211658000946045, -164.03448486328125)
}

-- ========== TAB AUTO MAKE ==========
local AutoMakeTab = Window:Tab({
    Title = "AUTO MAKE"
})

-- Variabel untuk kontrol loop
local isInsideRunning = false
local isOutsideRunning = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Fungsi untuk berjalan ke titik tertentu
local function walkToPosition(targetPos, stepNumber, totalSteps, routeName, waitTime)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    -- Hitung jarak ke target
    local distance = (rootPart.Position - targetPos).Magnitude
    
    -- Jika sudah dekat (dalam 3 unit), anggap sampai
    if distance < 3 then
        -- Notifikasi step selesai
        UI:Notify(routeName, string.format("Step %d/%d selesai", stepNumber, totalSteps), 1)
        
        -- Jeda sesuai parameter
        task.wait(waitTime)
        return true
    end
    
    -- Arahkan karakter ke target
    humanoid:MoveTo(targetPos)
    return false
end

-- Fungsi untuk menjalankan rute Dalam
local function runInsideRoute()
    local currentStep = 1
    local totalSteps = #waypointsInside
    local routeName = "Rute Dalam"
    local waitTime = 0.5 -- Jeda 0.5 detik antar step
    
    while isInsideRunning and character and humanoid and character.Parent do
        -- Ambil waypoint saat ini
        local targetPos = waypointsInside[currentStep]
        
        if not targetPos then
            -- Jika sudah sampai waypoint terakhir, ulang dari awal
            currentStep = 1
            UI:Notify(routeName, "Selesai 1 putaran, mulai ulang...", 2)
            targetPos = waypointsInside[currentStep]
        end
        
        -- Berjalan ke target
        local reached = walkToPosition(targetPos, currentStep, totalSteps, routeName, waitTime)
        
        if reached then
            -- Pindah ke waypoint berikutnya
            currentStep = currentStep + 1
        end
        
        task.wait(0.1) -- Update setiap 0.1 detik
    end
end

-- Fungsi untuk menjalankan rute Luar
local function runOutsideRoute()
    local currentStep = 1
    local totalSteps = #waypointsOutside
    local routeName = "Rute Luar"
    local waitTime = 1 -- Jeda 1 detik antar step (sesuai permintaan)
    
    while isOutsideRunning and character and humanoid and character.Parent do
        -- Ambil waypoint saat ini
        local targetPos = waypointsOutside[currentStep]
        
        if not targetPos then
            -- Jika sudah sampai waypoint terakhir, ulang dari awal
            currentStep = 1
            UI:Notify(routeName, "Selesai 1 putaran, mulai ulang...", 2)
            targetPos = waypointsOutside[currentStep]
        end
        
        -- Berjalan ke target
        local reached = walkToPosition(targetPos, currentStep, totalSteps, routeName, waitTime)
        
        if reached then
            -- Pindah ke waypoint berikutnya
            currentStep = currentStep + 1
        end
        
        task.wait(0.1) -- Update setiap 0.1 detik
    end
end

-- Toggle untuk Rute Dalam
AutoMakeTab:Toggle({
    Text = "Auto Make Rute Dalam (20 step, jeda 0.5 detik)",
    Default = false,
    Callback = function(state)
        -- Jika mencoba mengaktifkan Rute Dalam saat Rute Luar sedang aktif
        if state and isOutsideRunning then
            UI:Notify("Auto Make", "Matikan Rute Luar dulu sebelum mengaktifkan Rute Dalam!", 3)
            return
        end
        
        isInsideRunning = state
        
        -- Update karakter dan humanoid
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        
        if state then
            UI:Notify("Auto Make", "Rute Dalam dimulai! (20 step, jeda 0.5 detik)", 2)
            
            -- Jalankan di thread terpisah
            task.spawn(function()
                runInsideRoute()
            end)
        else
            -- Hentikan pergerakan
            if humanoid then
                humanoid:MoveTo(humanoid.RootPart.Position)
            end
            UI:Notify("Auto Make", "Rute Dalam dihentikan", 2)
        end
    end
})

-- Toggle untuk Rute Luar
AutoMakeTab:Toggle({
    Text = "Auto Make Rute Luar (11 step, jeda 1 detik)",
    Default = false,
    Callback = function(state)
        -- Jika mencoba mengaktifkan Rute Luar saat Rute Dalam sedang aktif
        if state and isInsideRunning then
            UI:Notify("Auto Make", "Matikan Rute Dalam dulu sebelum mengaktifkan Rute Luar!", 3)
            return
        end
        
        isOutsideRunning = state
        
        -- Update karakter dan humanoid
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        
        if state then
            UI:Notify("Auto Make", "Rute Luar dimulai! (11 step, jeda 1 detik)", 2)
            
            -- Jalankan di thread terpisah
            task.spawn(function()
                runOutsideRoute()
            end)
        else
            -- Hentikan pergerakan
            if humanoid then
                humanoid:MoveTo(humanoid.RootPart.Position)
            end
            UI:Notify("Auto Make", "Rute Luar dihentikan", 2)
        end
    end
})

-- Tombol untuk reset posisi ke step 1 Rute Dalam
AutoMakeTab:Button({
    Text = "Reset ke Step 1 (Rute Dalam)",
    Callback = function()
        if isInsideRunning or isOutsideRunning then
            UI:Notify("Auto Make", "Matikan semua Auto Make dulu sebelum reset!", 3)
            return
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart and waypointsInside[1] then
            rootPart.CFrame = CFrame.new(waypointsInside[1])
            UI:Notify("Reset", "Reset ke step 1 Rute Dalam", 2)
        end
    end
})

-- Tombol untuk reset posisi ke step 1 Rute Luar
AutoMakeTab:Button({
    Text = "Reset ke Step 1 (Rute Luar)",
    Callback = function()
        if isInsideRunning or isOutsideRunning then
            UI:Notify("Auto Make", "Matikan semua Auto Make dulu sebelum reset!", 3)
            return
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart and waypointsOutside[1] then
            rootPart.CFrame = CFrame.new(waypointsOutside[1])
            UI:Notify("Reset", "Reset ke step 1 Rute Luar", 2)
        end
    end
})

-- Tombol untuk menampilkan informasi waypoints
AutoMakeTab:Button({
    Text = "Info Waypoints",
    Callback = function()
        local insideCount = #waypointsInside
        local outsideCount = #waypointsOutside
        UI:Notify("Info", string.format("Rute Dalam: %d step (jeda 0.5 detik)\nRute Luar: %d step (jeda 1 detik)", 
                  insideCount, outsideCount), 5)
        
        print("=== Rute Dalam (20 step, jeda 0.5 detik) ===")
        for i, wp in ipairs(waypointsInside) do
            print(string.format("Step %d: (%.2f, %.2f, %.2f)", i, wp.X, wp.Y, wp.Z))
        end
        
        print("\n=== Rute Luar (11 step, jeda 1 detik) ===")
        for i, wp in ipairs(waypointsOutside) do
            print(string.format("Step %d: (%.2f, %.2f, %.2f)", i, wp.X, wp.Y, wp.Z))
        end
    end
})

-- ========== TAB INF ALL ==========
local InfAllTab = Window:Tab({
    Title = "INF ALL"
})

-- Toggle untuk Inf All
InfAllTab:Toggle({
    Text = "Inf All (Auto Get Wins)",
    Default = false,
    Callback = function(state)
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
    end
})

-- Toggle untuk Auto Rebirth
InfAllTab:Toggle({
    Text = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        _G.AutoRebirth = state
        while _G.AutoRebirth do
            wait()
            
            local args = {"BuyRebirth", 1}
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_1"):FireServer(unpack(args))
            
            task.wait(1)
        end
    end
})

-- ========== TAB UPGRADES ==========
local UpgradesTab = Window:Tab({
    Title = "UPGRADES"
})

UpgradesTab:Button({
    Text = "Cooking Speed (Wifi)",
    Callback = function()
        local args = {"Upgrade", "Wifi"}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_2"):FireServer(unpack(args))
        UI:Notify("Upgrade", "Cooking Speed ditingkatkan!", 2)
    end
})

UpgradesTab:Button({
    Text = "Quantity of Food (ManualRev)",
    Callback = function()
        local args = {"Upgrade", "ManualRev"}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_3"):FireServer(unpack(args))
        UI:Notify("Upgrade", "Quantity of Food ditingkatkan!", 2)
    end
})

UpgradesTab:Button({
    Text = "Better Management (FriendRev)",
    Callback = function()
        local args = {"Upgrade", "FriendRev"}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_4"):FireServer(unpack(args))
        UI:Notify("Upgrade", "Better Management ditingkatkan!", 2)
    end
})

-- ========== TAB INFO ==========
local InfoTab = Window:Tab({
    Title = "INFO"
})

InfoTab:Button({
    Text = "Test Remote Connection",
    Callback = function()
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
        
        UI:Notify("Status Remote", msg, 5)
    end
})

print("UI telah dimuat! Klik tombol bundar di kiri tengah layar untuk membuka.")
