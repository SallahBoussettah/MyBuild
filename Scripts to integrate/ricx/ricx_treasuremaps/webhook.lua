local WebhookConfig = {
	[1] = {
		webhook ="",
		botname = "RicX Treasure Maps: Found Treasure",
		icon_url = "https://raw.githubusercontent.com/abdulkadiraktas/rdr3_discoveries/master/useful_info_from_rpfs/textures/ui_startup_textures/images/elements_stamps_icons_tu/stamp_roles_moonshiner_locked.png",
		color = 15248975,
	},    
    [2] = {
		webhook ="",
		botname = "RicX Treasure Maps: Found Map Treasure",
		icon_url = "https://raw.githubusercontent.com/abdulkadiraktas/rdr3_discoveries/master/useful_info_from_rpfs/textures/ui_startup_textures/images/elements_stamps_icons_tu/stamp_roles_moonshiner_locked.png",
		color = 15248975,
	},   
}

function TreasureMapsWH(id, wd)
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