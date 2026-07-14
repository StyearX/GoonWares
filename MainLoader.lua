getgenv().BaseURL = "https://raw.githubusercontent.com"
getgenv().ScriptDirectory = "/StyearX/GoonWares/main/"

local ScriptGroups = {
    ["MurderMystery2/GoonWaresMM2.lua"] = {
        name = "Murder Mystery 2",
        placeIds = {
            335132309,
            636649648,
            142823291,
        }
    },
    ["Evade/GoonWaresLE.lua"] = {
        name = "Legacy Evade",
        placeIds = {
            96537472072550
        }
    }
}

local function isMM2Like()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    if not replicatedStorage then return false end

    local remotes = replicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local gameplay = remotes:FindFirstChild("Gameplay")
        if gameplay then
            local coinCollected = gameplay:FindFirstChild("CoinCollected")
            local roleSelect = gameplay:FindFirstChild("RoleSelect")
            local loadingMap = gameplay:FindFirstChild("LoadingMap")
            if coinCollected and roleSelect and loadingMap then
                return true
            end
        end
    end

    local modules = replicatedStorage:FindFirstChild("Modules")
    if modules then
        local currentRound = modules:FindFirstChild("CurrentRoundClient")
        if currentRound then
            return true
        end
    end

    return false
end

local currentGameId = game.PlaceId
local selectedFilename = nil

for filename, group in pairs(ScriptGroups) do
    for _, placeId in ipairs(group.placeIds) do
        if currentGameId == placeId then
            selectedFilename = filename
            break
        end
    end
    if selectedFilename then break end
end

if not selectedFilename and isMM2Like() then
    selectedFilename = "MurderMystery2/GoonWaresMM2.lua"
end

if selectedFilename then
    local url = getgenv().BaseURL .. getgenv().ScriptDirectory .. selectedFilename
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success and result then
        loadstring(result)()
    else
        warn("Failed to load script from: " .. url .. "\nError: " .. tostring(result))
    end
else
    print("No compatible script found.")
end
