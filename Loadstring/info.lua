local HttpService = game:GetService("HttpService")

local ReqFunc = (syn and syn.request) or (http and http.request) or http_request or request

local GitHubToken = nil

local function SetToken(Token)
    GitHubToken = Token
end

local function MakeRequest(Url, Method, Headers)
    Headers = Headers or {}
    Headers["User-Agent"] = "Roblox-GitHub-Client/1.0"
    if GitHubToken then
        Headers["Authorization"] = "token " .. GitHubToken
    end
    local Success, Response = pcall(function()
        local Res = ReqFunc({ Url = Url, Method = Method or "GET", Headers = Headers })
        if Res and Res.Body then
            return HttpService:JSONDecode(Res.Body)
        end
        return nil
    end)
    if Success and Response then return true, Response end
    return false, nil
end

local function DownloadImage(Url, FileName)
    if not ReqFunc then return nil end
    local Success, Res = pcall(function()
        return ReqFunc({
            Url = Url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Roblox-GitHub-Client/1.0",
                ["Accept"] = "image/*",
            },
        })
    end)
    if not Success or not Res or not Res.Body or #Res.Body < 100 then return nil end
    pcall(function()
        if writefile then writefile(FileName, Res.Body) end
    end)
    if getcustomasset then return getcustomasset(FileName) end
    return nil
end

local GitHubAvatarSystem = {}

function GitHubAvatarSystem.SetToken(Token)
    SetToken(Token)
end

function GitHubAvatarSystem.GetAvatarUrl(UserName)
    local Url = "https://api.github.com/users/" .. UserName
    local Success, Data = MakeRequest(Url, "GET", { ["Accept"] = "application/vnd.github.v3+json" })
    if not Success or not Data then return nil end
    return Data.avatar_url
end

function GitHubAvatarSystem.GetAvatarAsset(UserName)
    local AvatarUrl = GitHubAvatarSystem.GetAvatarUrl(UserName)
    if not AvatarUrl then return nil end
    local FileName = "github_avatar_" .. UserName .. ".png"
    return DownloadImage(AvatarUrl, FileName)
end

function GitHubAvatarSystem.GetUserProfile(UserName)
    local Url = "https://api.github.com/users/" .. UserName
    local Success, Data = MakeRequest(Url, "GET", { ["Accept"] = "application/vnd.github.v3+json" })
    if not Success or not Data then return nil end
    return {
        Login = Data.login,
        Name = Data.name,
        Bio = Data.bio,
        AvatarUrl = Data.avatar_url,
    }
end

return function(Tabs)
    local secDiscord = Tabs.info:AddSection("Discord", "solar/chat-round-bold")

    secDiscord:AddDiscord({
        InviteCode = "",
    })

    secDiscord:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local secTikTok = Tabs.info:AddSection("TikTok", "solar/music-note-bold")

    secTikTok:AddImage({
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2Fwww.tiktok.com%2F%40styearx",
        AspectRatio = "1:1",
        Radius = 10,
    })

    secTikTok:AddParagraph({
        Title = "Follow my main account Pls",
        Content = "@styearx",
    })

    secTikTok:AddCode({
        Title = "",
        Code = "https://www.tiktok.com/@styearx",
        OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
    })

    secTikTok:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local secYouTube = Tabs.info:AddSection("YouTube", "solar/videocamera-record-bold")

    secYouTube:AddImage({
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2FYouTube.com%2F%40StyearX",
        AspectRatio = "16:9",
        Radius = 10,
    })

    secYouTube:AddParagraph({
        Title = "Subscribe to my main account :)",
        Content = "@StyearX",
    })

    secYouTube:AddCode({
        Title = "",
        Code = "https://m.youtube.com/@styearx",
        OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
    })

    secYouTube:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local secGithub = Tabs.info:AddSection("GitHub", "solar/code-square-bold")

    local githubAvatar = GitHubAvatarSystem.GetAvatarAsset("StyearX")
        or "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2Fgithub.com%2FStyearX.png"

    secGithub:AddImage({
        Image = githubAvatar,
        AspectRatio = "1:1",
        Radius = 10,
    })

    secGithub:AddParagraph({
        Title = "Check out my GitHub",
        Content = "@StyearX",
    })

    secGithub:AddCode({
        Title = "",
        Code = "https://github.com/StyearX",
        OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
    })

    secGithub:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local secUILibrary = Tabs.info:AddSection("UI Library", "solar/widget-bold")

    secUILibrary:AddParagraph({
        Title = "Fluent Modded",
        Content = "The UI Library used in this script.",
    })

    secUILibrary:AddCode({
        Title = "",
        Code = "https://github.com/StyearX/Fluent-modded",
        OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
    })
end

