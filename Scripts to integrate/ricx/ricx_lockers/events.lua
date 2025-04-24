local TEXTS = Config.Texts
local TEXTURES = Config.Textures
local notifSettings = {}
-----------------------------------------------------------------------------------------------------
local notifSettings = {
	[1] = {
		TEXTS.Lockers, TEXTS.NoAround, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[2] = {
		TEXTS.Lockers, TEXTS.GoCloser, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[3] = {
		TEXTS.Lockers, TEXTS.LockerIsLocked, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[4] = {
		TEXTS.Lockers, TEXTS.WaitSome, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[5] = {
		TEXTS.Lockers, TEXTS.CantDo, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[6] = {
		TEXTS.Lockers, TEXTS.LockerIsUnlocked, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[7] = {
		TEXTS.Lockers, TEXTS.WaitBefore, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[8] = {
		TEXTS.Lockers, TEXTS.LockerUnlock, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[9] = {
		TEXTS.Lockers, TEXTS.LockerLock, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[10] = {
		TEXTS.Lockers, TEXTS.NotOwned, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[11] = {
		TEXTS.Lockers, TEXTS.LockerUnlock2, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[12] = {
		TEXTS.Lockers, TEXTS.MissShovel, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[13] = {
		TEXTS.Lockers, TEXTS.NoLocker, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[14] = {
		TEXTS.Lockers, TEXTS.LimitReached, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[15] = {
		TEXTS.Lockers, TEXTS.LockerPlaced, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[16] = {
		TEXTS.Lockers, TEXTS.WalkAway, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[17] = {
		TEXTS.Lockers, TEXTS.TooClose, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[18] = {
		TEXTS.Lockers, TEXTS.NoAmmo, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[19] = {
		TEXTS.Lockers, TEXTS.NoWeapon, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[20] = {
		TEXTS.Lockers, TEXTS.UnlockedAlready, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[21] = {
		TEXTS.Lockers, TEXTS.InvalidCode, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[22] = {
		TEXTS.Lockers, TEXTS.CantPlaceHere, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[23] = {
		TEXTS.Lockers, TEXTS.MissAxe, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	[24] = {
		TEXTS.Lockers, TEXTS.LockerDestroyed, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
	--[[
	[] = {
		TEXTS.TEXT, TEXTS.Saved, TEXTURES.alert[1], TEXTURES.alert[2], 3000,
	},
]]
}

-----------------------------------------------------------------------------------------------------
function CallLockerNotif(id, extra)
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
	TriggerEvent("Notification:ricx_lockers", title, text, dict, texture, timer)--change this to a different notification logic if you want
end
-----------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_lockers:call_notif", function(id, extra)
	local _id = tonumber(id)
	CallLockerNotif(_id, extra)
end)
----------------------------Basic Notification----------------------------
RegisterNetEvent('Notification:ricx_lockers', function(t1, t2, dict, txtr, timer)
    local _dict = tostring(dict)
    PrepareTexture(_dict)
    exports.ricx_lockers.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    SetStreamedTextureDictAsNoLongerNeeded(_dict)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
