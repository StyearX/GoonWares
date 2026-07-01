return function(Tabs)
    local secDiscord = Tabs.info:AddSection("Discord", "solar/chat-round-bold")

    secDiscord:AddDiscord({
        InviteCode = "QBhcVu6c",
    })

    secDiscord:AddDivider()

    Tabs.info:AddSpace({ Height = 20 })
    local secTikTok = Tabs.info:AddSection("TikTok", "solar/music-note-bold")

    secTikTok:AddImage({
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2Fwww.tiktok.com%2F%40styearx",
        AspectRatio = "16:9",
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
    secGithub:AddImage({
        Image = "https://linkspreview.netlify.app/fetchimage/https%3A%2F%2Fgithub.com%2FStyearX.png",
        AspectRatio = "16:9",
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
