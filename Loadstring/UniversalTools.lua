return function(Tabs)
    HttpService = game:GetService("HttpService")
    TeleportService = game:GetService("TeleportService")
    Players = game:GetService("Players")
    MarketplaceService = game:GetService("MarketplaceService")
    Stats = game:GetService("Stats")
    RunService = game:GetService("RunService")
    Workspace = game:GetService("Workspace")
    UserInputService = game:GetService("UserInputService")
    jobId = game.JobId
    placeId = game.PlaceId
    LocalPlayer = Players.LocalPlayer
    StartTime = tick()

    ENGINE_TARGET_MB = 3000
    FrameCount = 0
    LastTime = tick()
    CurrentFPS = 0

    RunService.RenderStepped:Connect(function()
        FrameCount = FrameCount + 1
        local CurrentTime = tick()
        if CurrentTime - LastTime >= 1 then
            CurrentFPS = FrameCount
            FrameCount = 0
            LastTime = CurrentTime
        end
    end)

    function format(Int)
        return string.format("%02i", Int)
    end

    function convertToDetailedTime(Seconds, Milliseconds)
        local years = math.floor(Seconds / 31536000)
        Seconds = Seconds % 31536000
        
        local months = math.floor(Seconds / 2592000)
        Seconds = Seconds % 2592000
        
        local weeks = math.floor(Seconds / 604800)
        Seconds = Seconds % 604800
        
        local days = math.floor(Seconds / 86400)
        Seconds = Seconds % 86400
        
        local hours = math.floor(Seconds / 3600)
        Seconds = Seconds % 3600
        
        local minutes = math.floor(Seconds / 60)
        local seconds = Seconds % 60
        
        return {
            Years = years,
            Months = months,
            Weeks = weeks,
            Days = days,
            Hours = hours,
            Minutes = minutes,
            Seconds = seconds,
            Milliseconds = Milliseconds or 0
        }
    end

    function GetServerUptimeString()
        local totalSeconds = time()
        local milliseconds = math.floor((totalSeconds - math.floor(totalSeconds)) * 1000)
        local uptime = convertToDetailedTime(math.floor(totalSeconds), milliseconds)
        return string.format(
            "<font color='#FFD700'>%dY</font> <font color='#FFA500'>%dMth</font> <font color='#FF8C00'>%dW</font> <font color='#32CD32'>%dD</font> <font color='#00CED1'>%dH</font> <font color='#1E90FF'>%dMin</font> <font color='#9370DB'>%dSec</font> <font color='#FF69B4'>%dMS</font>",
            uptime.Years, uptime.Months, uptime.Weeks, uptime.Days, 
            uptime.Hours, uptime.Minutes, uptime.Seconds, uptime.Milliseconds
        )
    end

    function GetLastJoinedString()
        local currentTimeSeconds = os.time()
        local joinedTimeSeconds = currentTimeSeconds - math.floor(time())
        local joinedTime = os.date("*t", joinedTimeSeconds)
        
        local hour = joinedTime.hour
        local minute = joinedTime.min
        local second = joinedTime.sec
        
        local ampm = hour >= 12 and "PM" or "AM"
        local hour12 = hour % 12
        if hour12 == 0 then hour12 = 12 end
        
        local millisecond = math.floor((time() - math.floor(time())) * 1000)
        
        local monthNames = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
        local monthName = monthNames[joinedTime.month]
        
        return string.format("<font color='#87CEEB'>%02d:%02d:%02d.%03d %s</font> - <font color='#98FB98'>%s %d, %d</font>",
            hour12, minute, second, millisecond, ampm, monthName, joinedTime.day, joinedTime.year)
    end

    function GetScriptRuntime()
        local elapsed = tick() - StartTime
        local milliseconds = math.floor((elapsed - math.floor(elapsed)) * 1000)
        local runtime = convertToDetailedTime(math.floor(elapsed), milliseconds)
        return string.format(
            "<font color='#FFD700'>%dY</font> <font color='#FFA500'>%dMth</font> <font color='#FF8C00'>%dW</font> <font color='#32CD32'>%dD</font> <font color='#00CED1'>%dH</font> <font color='#1E90FF'>%dMin</font> <font color='#9370DB'>%dSec</font> <font color='#FF69B4'>%dMS</font>",
            runtime.Years, runtime.Months, runtime.Weeks, runtime.Days, 
            runtime.Hours, runtime.Minutes, runtime.Seconds, runtime.Milliseconds
        )
    end

    function GetExecutedSince()
        local executedTime = os.date("%I:%M:%S %p", StartTime)
        return string.format("<font color='#87CEEB'>%s</font>", executedTime)
    end

    function GetOSClock()
        local now = os.date("*t")
        local hour = now.hour
        local minute = now.min
        local second = now.sec
        local ampm = hour >= 12 and "PM" or "AM"
        local hour12 = hour % 12
        if hour12 == 0 then hour12 = 12 end
        return string.format("<font color='#FFD700'>%02d:%02d:%02d %s</font>", hour12, minute, second, ampm)
    end

    function GetCalendarDate()
        local now = os.date("*t")
        local monthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
        local suffix = "th"
        if now.day == 1 or now.day == 21 or now.day == 31 then suffix = "st"
        elseif now.day == 2 or now.day == 22 then suffix = "nd"
        elseif now.day == 3 or now.day == 23 then suffix = "rd" end
        return string.format("<font color='#98FB98'>%s %d%s, %d</font>", monthNames[now.month], now.day, suffix, now.year)
    end

    function GetGPUInfo()
        local gpuTime = Stats.RenderGPUFrameTime
        local gpuMs = string.format("%.2f", gpuTime * 1000)
        local color = tonumber(gpuMs) < 10 and "#32CD32" or (tonumber(gpuMs) < 30 and "#FFD700" or "#FF6666")
        return string.format("<font color='%s'>%s ms</font>", color, gpuMs)
    end

    function GetCPUInfo()
        local cpuTime = Stats.RenderCPUFrameTime
        local cpuMs = string.format("%.2f", cpuTime * 1000)
        local color = tonumber(cpuMs) < 10 and "#32CD32" or (tonumber(cpuMs) < 30 and "#FFD700" or "#FF6666")
        return string.format("<font color='%s'>%s ms</font>", color, cpuMs)
    end

    function GetRAMInfo()
        local currentRAM = Stats:GetTotalMemoryUsageMb()
        local usagePercent = math.floor((currentRAM / ENGINE_TARGET_MB) * 100)
        local color = usagePercent < 50 and "#32CD32" or (usagePercent < 80 and "#FFD700" or "#FF6666")
        return string.format("<font color='%s'>%.2f MB / %d MB (%d%%)</font>", color, currentRAM, ENGINE_TARGET_MB, usagePercent)
    end

    function GetNetworkSent()
        local sentRate = Stats.DataSendKbps
        local color = sentRate < 100 and "#32CD32" or (sentRate < 500 and "#FFD700" or "#FF6666")
        return string.format("<font color='%s'>%.2f KB/s</font>", color, sentRate)
    end

    function GetNetworkReceived()
        local receivedRate = Stats.DataReceiveKbps
        local color = receivedRate < 100 and "#32CD32" or (receivedRate < 500 and "#FFD700" or "#FF6666")
        return string.format("<font color='%s'>%.2f KB/s</font>", color, receivedRate)
    end

    function GetPing()
        local ping = math.clamp(Stats.Network.ServerStatsItem["Data Ping"]:GetValue(), 10, 700)
        local color = ping < 100 and "#32CD32" or (ping < 200 and "#FFD700" or "#FF6666")
        return string.format("<font color='%s'>%d ms</font>", color, math.floor(ping))
    end

    function GetFPS()
        local color = CurrentFPS >= 60 and "#32CD32" or (CurrentFPS >= 30 and "#FFD700" or "#FF6666")
        return string.format("<font color='%s'>%d fps</font>", color, CurrentFPS)
    end

    function LaunchID()
        return string.format("roblox://placeId=%d&gameInstanceId=%s", placeId, jobId)
    end

    function getServerLink()
        return string.format("darahub.pages.dev/roblox-launch.html?placeId=%d&gameInstanceId=%s", placeId, jobId)
    end

    function getServers()
        local success, response = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100")
        end)
        if success and response then
            local success2, serverData = pcall(function()
                return HttpService:JSONDecode(response)
            end)
            if success2 and serverData and serverData.data then
                local serverList = {}
                for _, server in pairs(serverData.data) do
                    if server.id and server.id ~= jobId and server.playing and server.maxPlayers and server.playing < server.maxPlayers then
                        table.insert(serverList, {
                            serverId = server.id,
                            players = server.playing,
                            maxPlayers = server.maxPlayers,
                            ping = server.ping or "N/A",
                        })
                    end
                end
                return serverList
            end
        end
        return {}
    end

    function serverHop()
        local success, err = pcall(function()
            local AllIDs = {}
            local foundAnything = ""
            local actualHour = os.date("!*t").hour
            local S_T = game:GetService("TeleportService")
            local S_H = game:GetService("HttpService")
            local File = pcall(function()
                if isfile and readfile then
                    AllIDs = S_H:JSONDecode(readfile("server-hop-temp.json"))
                end
            end)
            if not File then
                table.insert(AllIDs, actualHour)
                pcall(function()
                    if writefile then
                        writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
                    end
                end)
            end
            function TPReturner(placeId)
                local Site;
                local success, response = pcall(function()
                    if foundAnything == "" then
                        return game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100')
                    else
                        return game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything)
                    end
                end)
                if not success then return end
                local success2, decoded = pcall(function()
                    return S_H:JSONDecode(response)
                end)
                if not success2 or not decoded then return end
                Site = decoded
                local ID = ""
                if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                    foundAnything = Site.nextPageCursor
                end
                local num = 0;
                if Site.data then
                    for i,v in pairs(Site.data) do
                        local Possible = true
                        ID = tostring(v.id)
                        if v.maxPlayers and v.playing and tonumber(v.maxPlayers) > tonumber(v.playing) then
                            for _,Existing in pairs(AllIDs) do
                                if num ~= 0 then
                                    if ID == tostring(Existing) then
                                        Possible = false
                                    end
                                else
                                    if tonumber(actualHour) ~= tonumber(Existing) then
                                        local delFile = pcall(function()
                                            if delfile then delfile("server-hop-temp.json") end
                                            AllIDs = {}
                                            table.insert(AllIDs, actualHour)
                                        end)
                                    end
                                end
                                num = num + 1
                            end
                            if Possible == true then
                                table.insert(AllIDs, ID)
                                task.wait()
                                pcall(function()
                                    if writefile then
                                        writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
                                    end
                                    task.wait()
                                    S_T:TeleportToPlaceInstance(placeId, ID, game.Players.LocalPlayer)
                                end)
                                task.wait(4)
                            end
                        end
                    end
                end
            end
            while task.wait() do
                pcall(function()
                    TPReturner(placeId)
                    if foundAnything ~= "" then TPReturner(placeId) end
                end)
            end
        end)
        if not success then
            Fluent:Notify({ Title = "Server Hop Error", Content = "Failed to hop: " .. tostring(err), Duration = 3 })
        end
    end

    function hopToSmallServer()
        local success, err = pcall(function()
            local servers = getServers()
            if #servers > 0 then
                table.sort(servers, function(a, b) return a.players < b.players end)
                for _, server in ipairs(servers) do
                    local teleportSuccess = pcall(function()
                        TeleportService:TeleportToPlaceInstance(placeId, server.serverId, game.Players.LocalPlayer)
                    end)
                    if teleportSuccess then break end
                    task.wait(1)
                end
            else
                serverHop()
            end
        end)
        if not success then
            Fluent:Notify({ Title = "Hop Error", Content = "Failed to hop to small server: " .. tostring(err), Duration = 3 })
        end
    end

    function rejoinServer()
        local success, err = pcall(function()
            local currentJobId = game.JobId
            local cursor = ""
            local bool = false
            
            repeat
                local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
                if cursor ~= "" then
                    url = url .. "&cursor=" .. cursor
                end
                
                local success, result = pcall(function()
                    return game:HttpGet(url)
                end)
                
                if not success then
                    return
                end
                
                local data = HttpService:JSONDecode(result)
                
                if data and data.data then
                    for _, server in ipairs(data.data) do
                        if server.id == currentJobId then
                            bool = true
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
                            return
                        end
                    end
                end
                
                cursor = data and data.nextPageCursor or ""
            until cursor == ""
            
            if not bool then
                TeleportService:Teleport(game.PlaceId)
            end
        end)
        
        if not success then
            Fluent:Notify({ Title = "Rejoin Error", Content = "Failed to rejoin: " .. tostring(err), Duration = 3 })
        end
    end

    TotalFriends = 0
    OnlineFriends = 0
    OfflineFriends = 0

    function UpdateFriendData()
        pcall(function()
            local total = 0
            local online = 0
            
            local friendsList = Players:GetFriendsAsync(LocalPlayer.UserId)
            while true do
                for _, data in friendsList:GetCurrentPage() do
                    total = total + 1
                end
                if friendsList.IsFinished then
                    break
                else
                    friendsList:AdvanceToNextPageAsync()
                end
            end
            
            local onlineFriendsData = LocalPlayer:GetFriendsOnline()
            for _ in pairs(onlineFriendsData) do
                online = online + 1
            end
            
            TotalFriends = total
            OnlineFriends = online
            OfflineFriends = total - online
        end)
    end

    UpdateFriendData()

    task.spawn(function()
        while true do
            task.wait(30)
            UpdateFriendData()
        end
    end)

    Tabs.Main:AddSection("Server Information", "solar/widget-2-bold")
    Tabs.Main:AddDivider()

    ServerInfoParagraph = Tabs.Main:AddParagraph({
        Title = "In Server For",
        Content = GetServerUptimeString()
    })

    task.spawn(function()
        while wait() do
            pcall(function()
                ServerInfoParagraph:SetDesc(GetServerUptimeString())
            end)
        end
    end)

    Tabs.Main:AddParagraph({
        Title = "Server Started",
        Content = GetLastJoinedString()
    })

    placeName = "Unknown"
    pcall(function()
        local productInfo = MarketplaceService:GetProductInfo(placeId)
        if productInfo and productInfo.Name then
            placeName = productInfo.Name
        end
    end)

    Tabs.Main:AddParagraph({
        Title = "Game",
        Content = placeName
    })

    numPlayers = #Players:GetPlayers()
    maxPlayers = Players.MaxPlayers
    CurrentPlayersParagraph = Tabs.Main:AddParagraph({
        Title = "Current Players",
        Content = numPlayers .. " / " .. maxPlayers
    })

    task.spawn(function()
        while wait() do
            pcall(function()
                CurrentPlayersParagraph:SetDesc(#Players:GetPlayers() .. " / " .. maxPlayers)
            end)
        end
    end)

    Tabs.Main:AddParagraph({
        Title = "Server ID",
        Content = string.sub(jobId, 1, 30) .. "..."
    })


    Tabs.Main:AddSpace({ Height = 20 })

    Tabs.Main:AddSection("Client Information", "solar/widget-2-bold")
    Tabs.Main:AddDivider()

    ScriptRuntimeParagraph = Tabs.Main:AddParagraph({
        Title = "Script Running For",
        Content = GetScriptRuntime()
    })

    task.spawn(function()
        while wait() do
            pcall(function()
                ScriptRuntimeParagraph:SetDesc(GetScriptRuntime())
            end)
        end
    end)

    Tabs.Main:AddParagraph({
        Title = "Executed Since",
        Content = GetExecutedSince()
    })


    Tabs.Main:AddSpace({ Height = 20 })

    Tabs.Main:AddSection("System Information", "solar/widget-2-bold")
    Tabs.Main:AddDivider()

    OSClockParagraph = Tabs.Main:AddParagraph({
        Title = "OS Clock",
        Content = GetOSClock()
    })

    task.spawn(function()
        while wait() do
            pcall(function()
                OSClockParagraph:SetDesc(GetOSClock())
            end)
        end
    end)

    CalendarParagraph = Tabs.Main:AddParagraph({
        Title = "Calendar",
        Content = GetCalendarDate()
    })

    task.spawn(function()
        while true do
            task.wait(60)
            pcall(function()
                CalendarParagraph:SetDesc(GetCalendarDate())
            end)
        end
    end)

    GPUParagraph = Tabs.Main:AddParagraph({
        Title = "GPU",
        Content = GetGPUInfo()
    })

    CPUParagraph = Tabs.Main:AddParagraph({
        Title = "CPU",
        Content = GetCPUInfo()
    })

    RAMParagraph = Tabs.Main:AddParagraph({
        Title = "RAM",
        Content = GetRAMInfo()
    })

    SentParagraph = Tabs.Main:AddParagraph({
        Title = "Sent",
        Content = GetNetworkSent()
    })

    ReceivedParagraph = Tabs.Main:AddParagraph({
        Title = "Received",
        Content = GetNetworkReceived()
    })

    PingParagraph = Tabs.Main:AddParagraph({
        Title = "Ping",
        Content = GetPing()
    })

    FPSParagraph = Tabs.Main:AddParagraph({
        Title = "FPS",
        Content = GetFPS()
    })

    task.spawn(function()
        while true do
            task.wait(0.2)
            pcall(function()
                GPUParagraph:SetDesc(GetGPUInfo())
                CPUParagraph:SetDesc(GetCPUInfo())
                RAMParagraph:SetDesc(GetRAMInfo())
                SentParagraph:SetDesc(GetNetworkSent())
                ReceivedParagraph:SetDesc(GetNetworkReceived())
                PingParagraph:SetDesc(GetPing())
                FPSParagraph:SetDesc(GetFPS())
            end)
        end
    end)


    Tabs.Main:AddSpace({ Height = 20 })

    Tabs.Main:AddSection("Player Information", "solar/widget-2-bold")
    Tabs.Main:AddDivider()

    Tabs.Main:AddParagraph({
        Title = "Username",
        Content = LocalPlayer.Name
    })

    Tabs.Main:AddParagraph({
        Title = "Display Name",
        Content = LocalPlayer.DisplayName
    })

    Tabs.Main:AddParagraph({
        Title = "User ID",
        Content = tostring(LocalPlayer.UserId)
    })

    accountCreationString = "Unknown"
    pcall(function()
        local accountAge = LocalPlayer.AccountAge
        if accountAge then
            local creationTime = os.time() - (accountAge * 86400)
            accountCreationString = os.date("%B %d, %Y", creationTime)
        end
    end)

    Tabs.Main:AddParagraph({
        Title = "Account Created",
        Content = accountCreationString
    })


    Tabs.Main:AddSpace({ Height = 20 })

    Tabs.Main:AddSection("Friends Data", "solar/widget-2-bold")
    Tabs.Main:AddDivider()

    FriendsOnlineParagraph = Tabs.Main:AddParagraph({
        Title = "Online Friends",
        Content = "0"
    })

    FriendsOfflineParagraph = Tabs.Main:AddParagraph({
        Title = "Offline Friends",
        Content = "0"
    })

    FriendsTotalParagraph = Tabs.Main:AddParagraph({
        Title = "Total Friends",
        Content = "0"
    })

    task.spawn(function()
        while true do
            task.wait(30)
            pcall(function()
                UpdateFriendData()
                FriendsOnlineParagraph:SetDesc(tostring(OnlineFriends))
                FriendsOfflineParagraph:SetDesc(tostring(OfflineFriends))
                FriendsTotalParagraph:SetDesc(tostring(TotalFriends))
            end)
        end
    end)

    pcall(function()
        UpdateFriendData()
        FriendsOnlineParagraph:SetDesc(tostring(OnlineFriends))
        FriendsOfflineParagraph:SetDesc(tostring(OfflineFriends))
        FriendsTotalParagraph:SetDesc(tostring(TotalFriends))
    end)


    Tabs.Main:AddSpace({ Height = 20 })

    Tabs.Main:AddSection("Server Tools", "solar/widget-2-bold")
    Tabs.Main:AddDivider()

    Tabs.Main:AddButton({
        Title = "Rejoin",
        Description = "Rejoin the current server",
        Icon = "refresh-cw",
        Callback = function()
            Window:Dialog({
                Title = "Rejoin",
                Content = "Are you sure you want to rejoin the current server?",
                Buttons = {
                    { Title = "Yes", Callback = function() rejoinServer() end },
                    { Title = "No" },
                },
            })
        end
    })

    Tabs.Main:AddButton({
        Title = "Copy Server Launch ID",
        Description = "Copy the current server's Launch ID",
        Icon = "link",
        Callback = function()
            pcall(function()
                if setclipboard then setclipboard(LaunchID()) end
            end)
            Fluent:Notify({ Icon = "link", Title = "Copied", Content = "Server Launch ID copied", Duration = 2 })
        end
    })

    Tabs.Main:AddButton({
        Title = "Copy Server Link",
        Description = "Copy the current server's join link",
        Icon = "link",
        Callback = function()
            pcall(function()
                if setclipboard then setclipboard(getServerLink()) end
            end)
            Fluent:Notify({ Icon = "link", Title = "Copied", Content = "Server link copied", Duration = 2 })
        end
    })

    Tabs.Main:AddButton({
        Title = "Server Hop",
        Description = "Hop to a random server",
        Icon = "shuffle",
        Callback = function()
            Window:Dialog({
                Title = "Server Hop",
                Content = "Hop to a random server? You will leave this server.",
                Buttons = {
                    { Title = "Hop", Callback = function() serverHop() end },
                    { Title = "Cancel" },
                },
            })
        end
    })

    Tabs.Main:AddButton({
        Title = "Hop to Small Server",
        Description = "Hop to the smallest available server",
        Icon = "minimize",
        Callback = function()
            Window:Dialog({
                Title = "Small Server Hop",
                Content = "Hop to the smallest available server? You will leave this server.",
                Buttons = {
                    { Title = "Hop", Callback = function() hopToSmallServer() end },
                    { Title = "Cancel" },
                },
            })
        end
    })

    Tabs.Main:AddButton({
        Title = "Advanced Server Hop",
        Description = "Finding a Server inside your game",
        Icon = "server",
        Callback = function()
            Window:Dialog({
                Title = "Advanced Server Hop",
                Content = "Load the Advanced Server Hop script? This will search for a server and teleport you.",
                Buttons = {
                    { Title = "Load", Callback = function()
                        pcall(function()
                            loadstring(game:HttpGet("https://darahub.pages.dev/raw-script/Tools/Advanced%20Server%20Hop.lua"))()
                        end)
                        Fluent:Notify({ Title = "Success", Content = "Advanced Server Hop Loaded", Duration = 3 })
                    end },
                    { Title = "Cancel" },
                },
            })
        end
    })


    AutoServerHopEnabled = false
    AutoServerHopInterval = 30
    AutoServerHopTimer = nil
    AutoServerHopType = "Random"
    lastHopTime = 0

    function stopAutoServerHop()
        pcall(function()
            if AutoServerHopTimer then
                AutoServerHopTimer:Disconnect()
                AutoServerHopTimer = nil
            end
            AutoServerHopEnabled = false
        end)
    end

    function startAutoServerHop()
        pcall(function()
            if AutoServerHopTimer then
                AutoServerHopTimer:Disconnect()
            end
            AutoServerHopEnabled = true
            lastHopTime = tick()
            AutoServerHopTimer = game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    if tick() - lastHopTime >= AutoServerHopInterval then
                        lastHopTime = tick()
                        if AutoServerHopType == "Small" then
                            pcall(hopToSmallServer)
                        else
                            pcall(serverHop)
                        end
                        Fluent:Notify({ Title = "Auto Server Hop", Content = "Hopping to " .. (AutoServerHopType == "Small" and "small" or "random") .. " server...", Duration = 3 })
                    end
                end)
            end)
        end)
    end

    AutoServerHopToggle = Tabs.Main:AddToggle("AutoServerHopToggle", {
        Title = "Auto Server Hop",
        Description = "Note: If you use this for auto farm be sure enable auto load/save config",
        Default = false,
        Callback = function(state)
            pcall(function()
                if state then
                    if AutoServerHopInterval < 20 then
                        Fluent:Notify({ Title = "Auto Server Hop", Content = "Interval must be at least 20 seconds!", Duration = 3 })
                        AutoServerHopToggle:SetValue(false)
                        return
                    end
                    startAutoServerHop()
                else
                    stopAutoServerHop()
                end
            end)
        end
    })

    AutoServerHopTypeDropdown = Tabs.Main:AddDropdown("AutoServerHopTypeDropdown", {
        Title = "Server Hop Type",
        Description = "Choose between small or random server hopping",
        Values = {"Random", "Small"},
        Default = "Random",
        Search = false,
        Callback = function(value)
            pcall(function()
                AutoServerHopType = value
                if AutoServerHopEnabled then
                    stopAutoServerHop()
                    startAutoServerHop()
                end
            end)
        end
    })

    AutoServerHopIntervalInput = Tabs.Main:AddInput("AutoServerHopIntervalInput", {
        Title = "Hop Interval (seconds)",
        Description = "Minimum 20 seconds",
        Placeholder = "30",
        Numeric = true,
        Default = "30",
        Callback = function(value)
            pcall(function()
                local num = tonumber(value)
                if num and num >= 20 then
                    AutoServerHopInterval = num
                    if AutoServerHopEnabled then
                        stopAutoServerHop()
                        startAutoServerHop()
                    end
                else
                    Fluent:Notify({ Title = "Auto Server Hop", Content = "Interval must be at least 20 seconds!", Duration = 3 })
                    AutoServerHopIntervalInput:SetValue("30")
                    AutoServerHopInterval = 30
                end
            end)
        end
    })
end
