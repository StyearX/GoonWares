---- Lua Write by mounsokdara (darahub) Modify by StyearX
function UniverseServerTools(Tabs)
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
            "%dY %dMth %dW %dD %dH %dMin %dSec %dMS",
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
        
        return string.format("%02d:%02d:%02d.%03d %s - %s %d, %d",
            hour12, minute, second, millisecond, ampm, monthName, joinedTime.day, joinedTime.year)
    end

    function GetScriptRuntime()
        local elapsed = tick() - StartTime
        local milliseconds = math.floor((elapsed - math.floor(elapsed)) * 1000)
        local runtime = convertToDetailedTime(math.floor(elapsed), milliseconds)
        return string.format(
            "%dY %dMth %dW %dD %dH %dMin %dSec %dMS",
            runtime.Years, runtime.Months, runtime.Weeks, runtime.Days, 
            runtime.Hours, runtime.Minutes, runtime.Seconds, runtime.Milliseconds
        )
    end

    function GetExecutedSince()
        local executedTime = os.date("%I:%M:%S %p", StartTime)
        return executedTime
    end

    function GetOSClock()
        local now = os.date("*t")
        local hour = now.hour
        local minute = now.min
        local second = now.sec
        local ampm = hour >= 12 and "PM" or "AM"
        local hour12 = hour % 12
        if hour12 == 0 then hour12 = 12 end
        return string.format("%02d:%02d:%02d %s", hour12, minute, second, ampm)
    end

    function GetCalendarDate()
        local now = os.date("*t")
        local monthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
        local suffix = "th"
        if now.day == 1 or now.day == 21 or now.day == 31 then suffix = "st"
        elseif now.day == 2 or now.day == 22 then suffix = "nd"
        elseif now.day == 3 or now.day == 23 then suffix = "rd" end
        return string.format("%s %d%s, %d", monthNames[now.month], now.day, suffix, now.year)
    end

    function GetGPUInfo()
        local gpuTime = Stats.RenderGPUFrameTime
        local gpuMs = string.format("%.2f", gpuTime * 1000)
        return string.format("%s ms", gpuMs)
    end

    function GetCPUInfo()
        local cpuTime = Stats.RenderCPUFrameTime
        local cpuMs = string.format("%.2f", cpuTime * 1000)
        return string.format("%s ms", cpuMs)
    end

    function GetRAMInfo()
        local currentRAM = Stats:GetTotalMemoryUsageMb()
        local usagePercent = math.floor((currentRAM / ENGINE_TARGET_MB) * 100)
        return string.format("%.2f MB / %d MB (%d%%)", currentRAM, ENGINE_TARGET_MB, usagePercent)
    end

    function GetNetworkSent()
        local sentRate = Stats.DataSendKbps
        return string.format("%.2f KB/s", sentRate)
    end

    function GetNetworkReceived()
        local receivedRate = Stats.DataReceiveKbps
        return string.format("%.2f KB/s", receivedRate)
    end

    function GetPing()
        local ping = math.clamp(Stats.Network.ServerStatsItem["Data Ping"]:GetValue(), 10, 700)
        return string.format("%d ms", math.floor(ping))
    end

    function GetFPS()
        return string.format("%d fps", CurrentFPS)
    end

    function LaunchID()
        return string.format("roblox://placeId=%d&gameInstanceId=%s", placeId, jobId)
    end

    function getServerLink()
        return string.format("darahub.pages.dev/roblox-launch.html?placeId=%d&gameInstanceId=%s", placeId, jobId)
    end  -- FIXED: typo `en` -> `end`

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

    task.spawn(UpdateFriendData)

    task.spawn(function()
        while true do
            task.wait(30)
            UpdateFriendData()
        end
    end)

    local SecServerInfo = Tabs.Main:AddSection("Server Information", "solar/widget-2-bold")
    SecServerInfo:AddDivider()

    ServerInfoParagraph = SecServerInfo:AddParagraph({
        Title = "In Server For",
        Content = GetServerUptimeString()
    })

    task.spawn(function()
        while true do task.wait()
            pcall(function()
                ServerInfoParagraph:SetDesc(GetServerUptimeString())
            end)
        end
    end)

    SecServerInfo:AddParagraph({
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

    SecServerInfo:AddParagraph({
        Title = "Game",
        Content = placeName
    })

    numPlayers = #Players:GetPlayers()
    maxPlayers = Players.MaxPlayers
    CurrentPlayersParagraph = SecServerInfo:AddParagraph({
        Title = "Current Players",
        Content = numPlayers .. " / " .. maxPlayers
    })

    task.spawn(function()
        while true do task.wait()
            pcall(function()
                CurrentPlayersParagraph:SetDesc(#Players:GetPlayers() .. " / " .. maxPlayers)
            end)
        end
    end)

    SecServerInfo:AddParagraph({
        Title = "Server ID",
        Content = string.sub(jobId, 1, 30) .. "..."
    })


    Tabs.Main:AddSpace({ Height = 20 })
    local SecClientInfo = Tabs.Main:AddSection("Client Information", "solar/widget-2-bold")
    SecClientInfo:AddDivider()

    ScriptRuntimeParagraph = SecClientInfo:AddParagraph({
        Title = "Script Running For",
        Content = GetScriptRuntime()
    })

    task.spawn(function()
        while true do task.wait()
            pcall(function()
                ScriptRuntimeParagraph:SetDesc(GetScriptRuntime())
            end)
        end
    end)

    SecClientInfo:AddParagraph({
        Title = "Executed Since",
        Content = GetExecutedSince()
    })


    Tabs.Main:AddSpace({ Height = 20 })
    local SecSystemInfo = Tabs.Main:AddSection("System Information", "solar/widget-2-bold")
    SecSystemInfo:AddDivider()

    OSClockParagraph = SecSystemInfo:AddParagraph({
        Title = "OS Clock",
        Content = GetOSClock()
    })

    task.spawn(function()
        while true do task.wait()
            pcall(function()
                OSClockParagraph:SetDesc(GetOSClock())
            end)
        end
    end)

    CalendarParagraph = SecSystemInfo:AddParagraph({
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

    GPUParagraph = SecSystemInfo:AddParagraph({
        Title = "GPU",
        Content = GetGPUInfo()
    })

    CPUParagraph = SecSystemInfo:AddParagraph({
        Title = "CPU",
        Content = GetCPUInfo()
    })

    RAMParagraph = SecSystemInfo:AddParagraph({
        Title = "RAM",
        Content = GetRAMInfo()
    })

    SentParagraph = SecSystemInfo:AddParagraph({
        Title = "Sent",
        Content = GetNetworkSent()
    })

    ReceivedParagraph = SecSystemInfo:AddParagraph({
        Title = "Received",
        Content = GetNetworkReceived()
    })

    PingParagraph = SecSystemInfo:AddParagraph({
        Title = "Ping",
        Content = GetPing()
    })

    FPSParagraph = SecSystemInfo:AddParagraph({
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
    local SecPlayerInfo = Tabs.Main:AddSection("Player Information", "solar/widget-2-bold")
    SecPlayerInfo:AddDivider()

    SecPlayerInfo:AddParagraph({
        Title = "Username",
        Content = LocalPlayer.Name
    })

    SecPlayerInfo:AddParagraph({
        Title = "Display Name",
        Content = LocalPlayer.DisplayName
    })

    SecPlayerInfo:AddParagraph({
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

    SecPlayerInfo:AddParagraph({
        Title = "Account Created",
        Content = accountCreationString
    })


    Tabs.Main:AddSpace({ Height = 20 })
    local SecFriendsData = Tabs.Main:AddSection("Friends Data", "solar/widget-2-bold")
    SecFriendsData:AddDivider()

    FriendsOnlineParagraph = SecFriendsData:AddParagraph({
        Title = "Online Friends",
        Content = "0"
    })

    FriendsOfflineParagraph = SecFriendsData:AddParagraph({
        Title = "Offline Friends",
        Content = "0"
    })

    FriendsTotalParagraph = SecFriendsData:AddParagraph({
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
    local SecServerTools = Tabs.Main:AddSection("Server Tools", "solar/widget-2-bold")
    SecServerTools:AddDivider()

    SecServerTools:AddButton({
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

    SecServerTools:AddButton({
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

    SecServerTools:AddButton({
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

end
UniverseServerTools(Tabs)
