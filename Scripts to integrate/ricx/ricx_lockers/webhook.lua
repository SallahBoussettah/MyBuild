local WebhookConfig = {
	[1] = {
		webhook = "",
		botname = "RicX Lockers: Locker (Framework Inventory) Open",
		icon_url = "https://i.imgur.com/R66g1Pe.jpg",
		color = 15248975,
	},    
	[2] = {
		webhook = "",
		botname = "RicX Lockers: Lock Status Change",
		icon_url = "https://i.imgur.com/R66g1Pe.jpg",
		color = 15248975,
	}, 
	[3] = {
		webhook = "",
		botname = "RicX Lockers: Lock Shoot Unlocked",
		icon_url = "https://i.imgur.com/R66g1Pe.jpg",
		color = 15248975,
	}, 
	[4] = {
		webhook = "",
		botname = "RicX Lockers: Placed Locker",
		icon_url = "https://i.imgur.com/R66g1Pe.jpg",
		color = 15248975,
	}, 
	[5] = {
		webhook = "",
		botname = "RicX Lockers: Locker Destroyed",
		icon_url = "https://i.imgur.com/R66g1Pe.jpg",
		color = 15248975,
	}, 
	[6] = {
		webhook = "",
		botname = "RicX Lockers: Locker Code Open",
		icon_url = "https://i.imgur.com/R66g1Pe.jpg",
		color = 15248975,
	}, 
}

function LockersWebhook(id, wd)
    wd.title = "Information"
    local timestamp = createTimestamp()
	local wh = WebhookConfig[id]
    local embeds = {
        {
            author = {
                name = wh.botname,
                icon_url = wh.icon_url,
            },
            color = wh.color,
            title = wd.title,
            description = wd.description,
            footer = {
                text= wh.botname,
            },
            fields = {
                {
                    name = "Server Date",
                    value = timestamp,
                    inline = true
                }
            }
        },
    }
    PerformHttpRequest(wh.webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embeds, username = wh.botname}), { ['Content-Type'] = 'application/json' })
end