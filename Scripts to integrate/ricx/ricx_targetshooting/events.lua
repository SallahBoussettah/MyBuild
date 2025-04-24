local TEXTS = Config.Texts
local TEXTURES = Config.Textures
local notifSettings = {}
-----------------------------------------------------------------------------------------------------
local notifSettings = {
	[1] = {
		"", TEXTS.NoContester, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[2] = {
		TEXTS.TargetShooting, TEXTS.NewRecord, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[3] = {
		TEXTS.TargetShooting, TEXTS.Finished, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[4] = {
		TEXTS.TargetShooting, TEXTS.SavedTime, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[5] = {
		TEXTS.TargetShooting, TEXTS.NoMoney, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[6] = {
		TEXTS.TargetShooting, TEXTS.UsedNow, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[7] = {
		TEXTS.TargetShooting, TEXTS.Starting, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[8] = {
		TEXTS.TargetShooting, TEXTS.Fail1, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[9] = {
		TEXTS.TargetShooting, TEXTS.Fail2, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[10] = {
		TEXTS.TargetShooting, TEXTS.Fail3, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[11] = {
		TEXTS.TargetShooting, TEXTS.Fail4, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[12] = {
		TEXTS.TargetShooting, TEXTS.InviteSent, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[13] = {
		TEXTS.TargetShooting, TEXTS.InviteGot, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[14] = {
		TEXTS.TargetShooting, TEXTS.NoPlayer, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[15] = {
		TEXTS.TargetShooting, TEXTS.ExpiredInvite, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[16] = {
		TEXTS.TargetShooting, TEXTS.NoInvite, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[17] = {
		TEXTS.TargetShooting, TEXTS.NotValid1, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[18] = {
		TEXTS.TargetShooting, TEXTS.DuelStart, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[19] = {
		TEXTS.TargetShooting, TEXTS.DuelEnd, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	--[[
	[] = {
		TEXTS.TEXT, TEXTS.Saved, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
]]
}

-----------------------------------------------------------------------------------------------------
function CallTargetShootingNotif(id, extra)
	local _id = tonumber(id)
	local title = notifSettings[_id][1]
	local text = notifSettings[_id][2]
	local dict = notifSettings[_id][3]
	local texture = notifSettings[_id][4]
	local timer = notifSettings[_id][5]

------------------EXTRA CODE START------------------
	if extra ~= nil then 						 --|
		if extra.title ~= nil then 				 --|
			title = extra.title					 --|
		end									 	 --|
		if extra.text ~= nil then 				 --|
			text = extra.text					 --|
		end										 --|
		if extra.extra_text ~= nil then 		 --|
			text = text..extra.extra_text		 --|
		end										 --|
		if extra.dict ~= nil then 				 --|
			dict = extra.dict					 --|
		end										 --|
		if extra.texture ~= nil then 			 --|
			texture = extra.texture				 --|
		end										 --|
		if extra.timer ~= nil then 				 --|
			timer = extra.timer					 --|
		end										 --|
	end											 --|
------------------EXTRA CODE END------------------
	TriggerEvent("Notification:ricx_targetshooting", title, text, dict, texture, timer)--change this to a different notification logic if you want
end
-----------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_targetshooting:call_notif", function(id, extra)
	local _id = tonumber(id)
	CallTargetShootingNotif(_id, extra)
end)
----------------------------Basic Notification----------------------------
RegisterNetEvent('Notification:ricx_targetshooting', function(t1, t2, dict, txtr, timer)
    local _dict = tostring(dict)
    PrepareTexture(_dict)
    exports.ricx_targetshooting.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    SetStreamedTextureDictAsNoLongerNeeded(_dict)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
