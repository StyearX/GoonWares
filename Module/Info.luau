local function SocialsModule(Tabs)
    local SecDiscord = Tabs.info:AddSection("Discord", "solar/chat-round-bold")

    SecDiscord:AddDiscord({
        InviteCode = "QBhcVu6c",
    })

    SecDiscord:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local SecTikTok = Tabs.info:AddSection("TikTok", "solar/music-note-bold")

    SecTikTok:AddImage({
        Image = "https://unavatar.io/tiktok/styearx",
        AspectRatio = "16:9",
        Radius = 10,
    })

    SecTikTok:AddParagraph({
        Title = "Follow my main account Pls",
        Content = "@styearx",
    })

    SecTikTok:AddCode({
        Title = "",
        Code = "https://www.tiktok.com/@styearx",
        OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
    })

    SecTikTok:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local SecYouTube = Tabs.info:AddSection("YouTube", "solar/videocamera-record-bold")

    SecYouTube:AddImage({
        Image = "https://unavatar.io/youtube/StyearX",
        AspectRatio = "16:9",
        Radius = 10,
    })

    SecYouTube:AddParagraph({
        Title = "Subscribe to my main account :)",
        Content = "@StyearX",
    })

    SecYouTube:AddCode({
        Title = "",
        Code = "https://m.youtube.com/@styearx",
        OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
    })

    SecYouTube:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local SecGithub = Tabs.info:AddSection("GitHub", "solar/code-square-bold")
    SecGithub:AddImage({
        Image = "https://unavatar.io/github/StyearX",
        AspectRatio = "16:9",
        Radius = 10,
    })

    SecGithub:AddParagraph({
        Title = "Check out my GitHub",
        Content = "@StyearX",
    })

    SecGithub:AddCode({
        Title = "",
        Code = "https://github.com/StyearX",
        OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
    })

    SecGithub:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local SecUILibrary = Tabs.info:AddSection("UI Library", "solar/widget-bold")

    SecUILibrary:AddParagraph({
        Title = "Fluent Modded",
        Content = "The UI Library used in this script.",
    })

    SecUILibrary:AddCode({
        Title = "",
        Code = "https://github.com/StyearX/Fluent-modded",
        OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
    })

    SecUILibrary:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
