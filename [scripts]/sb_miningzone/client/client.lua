local VORPcore = exports.vorp_core:GetCore()
local blips = {}
local inMiningZone = false
local currentZone = nil
local playerMiningState = "idle" -- Can be: idle, mining
local T = TranslationStores.Langs.English
local storePrompt = {}
local storeBlips = {}
local npcStore = {}
local promptGroup
local promptOpenKey
local isInMenu = false
local MenuData = exports.vorp_menu:GetMenuData() -- Add MenuData for vorp_menu
local imgPathMenu = "<img style='max-height:120px;max-width:120px;float: center;' src='nui://vorp_stores/images/%s.png'><br>"
local imgPath = "<img style='max-height:64px;max-width:64px; float:%s; margin-top: -5px;' src='nui://vorp_inventory/html/img/items/%s.png'>"
local font = '<span style="font-family: crock; src:nui://vorp_menu/html/fonts/crock.ttf) format("truetype")</span>'
local subMenuStyle = "<span style='font-size: 1.0vw;'>%s<br><br></span>"
local labelStyle = "<span style='opacity:0.6;'>%s</span>"
local divider = "<img style='margin-top: 10px;margin-bottom: 10px; margin-left: -10px;'src='nui://vorp_stores/images/divider_line.png'>"

-- Function to check if a player is in a mining zone
local function IsPlayerInMiningZone()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local result = { inZone = false, zoneName = nil, zoneObject = nil }
    
    for _, zone in pairs(Config.MiningZones) do
        local distance = #(playerCoords - vector3(zone.coords.x, zone.coords.y, zone.coords.z))
        
        if distance <= zone.radius then
            result.inZone = true
            result.zoneName = zone.name
            result.zoneObject = zone
            break
        end
    end
    
    return result
end

-- Create blips for mining zones
local function CreateMiningZoneBlips()
    if not Config.ShowMiningZoneBlips then return end
    
    for _, zone in pairs(Config.MiningZones) do
        if not zone.blip then goto continue end
        
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(blip, Config.Blip.sprite, 1)
        SetBlipScale(blip, Config.Blip.scale)
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, Config.Blip.color)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, zone.name)
        
        table.insert(blips, blip)
        
        ::continue::
    end
end

-- Thread to continuously check if player is in a mining zone
CreateThread(function()
    Wait(2000) -- Give time for configs to load
    
    CreateMiningZoneBlips()
    
    while true do
        local zoneInfo = IsPlayerInMiningZone()
        
        if zoneInfo.inZone ~= inMiningZone then
            inMiningZone = zoneInfo.inZone
            currentZone = zoneInfo.zoneObject
            
            -- Trigger state change events
            if inMiningZone then
                TriggerEvent("sb_miningzone:enteredMiningZone", currentZone)
                VORPcore.NotifyRightTip("Entered Mining Zone: " .. currentZone.name, 4000)
            else
                TriggerEvent("sb_miningzone:exitedMiningZone")
                if currentZone then
                    VORPcore.NotifyRightTip("Exited Mining Zone: " .. currentZone.name, 4000)
                else
                    VORPcore.NotifyRightTip("Exited Mining Zone", 4000)
                end
            end
        end
        
        Wait(Config.CheckInterval)
    end
end)

-- MINING STORE FUNCTIONS --

-- Function to create store NPC
local function createStoreNPC(storeName, npcModel, x, y, z, h)
    local hashModel = GetHashKey(npcModel)
    if IsModelValid(hashModel) then
        if not HasModelLoaded(hashModel) then
            RequestModel(hashModel)
            while not HasModelLoaded(hashModel) do
                Wait(100)
            end
        end
    end

    local NPC = CreatePed(hashModel, x, y, z, h, false, true, true, true)
    Citizen.InvokeNative(0x283978A15512B2FE, NPC, true)
    SetEntityNoCollisionEntity(PlayerPedId(), NPC, false)
    SetEntityCanBeDamaged(NPC, false)
    SetEntityInvincible(NPC, true)
    Wait(1000)
    FreezeEntityPosition(NPC, true)
    SetBlockingOfNonTemporaryEvents(NPC, true)
    return NPC
end

-- Function to create store blips
local function createStoreBlip(storeName, blipData)
    if blipData.Allowed then
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, blipData.Pos.x, blipData.Pos.y, blipData.Pos.z)
        SetBlipSprite(blip, blipData.sprite, 1)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipData.Name)
        storeBlips[storeName] = blip
    end
end

-- Function to create store prompts
local function CreatePrompt()
    promptGroup = GetRandomIntInRange(0, 0xffffff)
    promptOpenKey = PromptRegisterBegin()
    PromptSetControlAction(promptOpenKey, 0x760A9C6F) -- G key
    PromptSetText(promptOpenKey, CreateVarString(10, "LITERAL_STRING", T.storePrompt))
    PromptSetEnabled(promptOpenKey, true)
    PromptSetVisible(promptOpenKey, true)
    PromptSetStandardMode(promptOpenKey, true)
    PromptSetGroup(promptOpenKey, promptGroup)
    PromptRegisterEnd(promptOpenKey)
end

-- Function to handle opening store menu
local function OpenStoreMenu(storeName, storeData)
    -- Check if store is open based on time
    local hour = GetClockHours()
    if storeData.StoreHoursAllowed then
        if hour >= storeData.StoreClose or hour < storeData.StoreOpen then
            VORPcore.NotifyRightTip(T.storeClosed .. " " .. storeData.StoreOpen .. ":00", 4000)
            return
        end
    end
    
    isInMenu = true
    
    -- Hide HUD elements while in menu if needed
    Config.UI(true)
    
    -- Notify player about pickaxe purchase limit
    VORPcore.NotifyRightTip(T.pickaxeLimitReminder, 5000)
    
    -- Trigger the server event to open the store menu
    TriggerServerEvent("sb_miningstore:OpenStore", storeName)
end

-- Initialize store NPCs, blips, and prompts
CreateThread(function()
    Wait(3000) -- Give time for configs to load
    
    CreatePrompt()
    
    for storeName, storeData in pairs(Config.MiningStores) do
        if not storeData.isDeactivated then
            -- Create blip for store
            createStoreBlip(storeName, storeData.Blip)
            
            -- Create NPC for store
            if storeData.Npc.Allowed then
                local npcPos = storeData.Npc.Pos
                local npc = createStoreNPC(storeName, storeData.Npc.Model, npcPos.x, npcPos.y, npcPos.z, npcPos.w)
                npcStore[storeName] = npc
            end
        end
    end
end)

-- Thread to handle store interaction
CreateThread(function()
    Wait(5000) -- Wait for everything to initialize
    
    while true do
        local sleep = true
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for storeName, storeData in pairs(Config.MiningStores) do
            if not storeData.isDeactivated and not isInMenu then
                local storePos = storeData.Blip.Pos
                local distance = #(playerCoords - storePos)
                
                if distance <= storeData.distanceOpenStore then
                    sleep = false
                    local label = CreateVarString(10, 'LITERAL_STRING', storeData.storeName .. " " .. storeData.PromptName)
                    PromptSetActiveGroupThisFrame(promptGroup, label)
                    
                    if PromptHasStandardModeCompleted(promptOpenKey) then
                        -- Check if player has required job if specified
                        if #storeData.AllowedJobs > 0 then
                            TriggerServerEvent("sb_miningstore:CheckJob", storeName)
                        else
                            OpenStoreMenu(storeName, storeData)
                        end
                    end
                end
            end
        end
        
        if sleep then
            Wait(500)
        else
            Wait(0)
        end
    end
end)

-- Clean up NPCs and blips if resource stops
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    -- Cleanup store NPCs
    for _, npc in pairs(npcStore) do
        if DoesEntityExist(npc) then
            DeletePed(npc)
            SetEntityAsNoLongerNeeded(npc)
        end
    end
    
    -- Cleanup store blips
    for _, blip in pairs(storeBlips) do
        RemoveBlip(blip)
    end
    
    -- Cleanup mining zone blips
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
end)

-- Callback for job check
RegisterNetEvent("sb_miningstore:JobCheck")
AddEventHandler("sb_miningstore:JobCheck", function(allowed, storeId)
    if allowed then
        local storeData = Config.MiningStores[storeId]
        OpenStoreMenu(storeId, storeData)
    else
        VORPcore.NotifyRightTip("You do not have permission to use this store", 3000)
    end
end)

-- Event to open store menu from server
RegisterNetEvent("sb_miningstore:OpenStoreMenu")
AddEventHandler("sb_miningstore:OpenStoreMenu", function(storeId, buyItems, sellItems, storeCfg)
    -- Replace the notification with actual menu implementation
    isInMenu = true
    Config.UI(true)
    
    -- If buyItems or sellItems are nil, use Config as fallback
    if not buyItems then
        buyItems = Config.BuyItems[storeId] or {}
        
        -- Additional safety check
        if not buyItems then
            buyItems = {}  -- Initialize as empty table to prevent errors
        end
    end
    
    if not sellItems then
        sellItems = Config.SellItems[storeId] or {}
        
        -- Additional safety check
        if not sellItems then
            sellItems = {}  -- Initialize as empty table to prevent errors
        end
    end
    
    OpenStoreMainMenu(storeId, buyItems, sellItems, storeCfg)
end)

-- Function to handle the main store menu (categories)
function OpenStoreMainMenu(storeId, buyItems, sellItems, storeCfg)
    MenuData.CloseAll()
    
    -- Make sure buyItems and sellItems are not nil
    if not buyItems then
        buyItems = Config.BuyItems[storeId] or {}
    end
    
    if not sellItems then
        sellItems = Config.SellItems[storeId] or {}
    end
    
    local elements = {}
    
    for _, category in pairs(storeCfg.category) do
        elements[#elements + 1] = {
            label = category.label .. "<br>" .. labelStyle:format("choose category"),
            value = category.Type,
            desc = imgPathMenu:format(category.img) .. " <br> " .. category.desc .. "<br><br><br><br><br><br><br><br><br>" .. divider .. "press enter for options"
        }
    end
    
    MenuData.Open('default', GetCurrentResourceName(), 'MiningStoreCategory_' .. storeId, {
        title = storeCfg.storeName,
        subtext = subMenuStyle:format(T.SubMenu or "Choose an option"),
        align = "left",
        elements = elements,
        itemHeight = "4vh",
    }, function(data, menu)
        -- When an option is selected
        if data.current.value == "tools" then
            -- For tools, directly show buy menu
            OpenDirectBuyMenu(storeId, "tools", buyItems, storeCfg)
        else
            -- For ore, show the sell interface
            OpenDirectSellMenu(storeId, "ore", sellItems, storeCfg)
        end
    end, function(data, menu)
        -- When menu is closed
        CloseStoreMenu()
    end)
end

-- Function to directly display buyable tools without showing buy/sell submenu
function OpenDirectBuyMenu(storeId, category, buyItems, storeCfg)
    MenuData.CloseAll()
    
    -- Ensure buyItems is not nil by using Config as a fallback
    if not buyItems then
        buyItems = Config.BuyItems[storeId] or {}
        
        -- If still nil or empty after fallback, show an error
        if not buyItems then
            VORPcore.NotifyRightTip("Store has no items to sell", 3000)
            CloseStoreMenu()
            return
        end
    end
    
    local elements = {}
    local buyTable = {}
    local tempElements = {}
    
    -- Filter items by category
    for i, item in ipairs(buyItems) do
        if item.category == category and item.itemName ~= "mininghelmet" then -- Skip the helmet
            -- Calculate buy price based on configuration
            local itemPrice = item.buyprice
            if storeCfg.RandomPrices then
                itemPrice = item.randomprice
            end
            
            -- Format price with proper decimals
            local formattedPrice = string.format("%.2f", itemPrice)
            
            -- Add the item to our elements list for the menu
            tempElements[#tempElements + 1] = {
                label = imgPath:format("left", item.itemName) .. item.itemLabel .. " <br> " .. labelStyle:format(T.chooseAmount or "Choose amount"),
                value = 0,
                min = 0,
                max = item.itemLimit or 100,
                type = "slider",
                action = "buy",
                info = item,
                itemIndex = i, -- Store the actual index in the original table
                index = item.itemName,
                desc = item.desc .. "<br><br><br><br><br>" .. divider .. "<br>" .. font .. 
                      "<span style='font-family:crock; float:left; font-size: 22px;'>" .. 
                      (T.Price or "Price") .. " </span>" .. font .. 
                      "<span style='font-family:crock;float:right; font-size: 22px;'>$" .. 
                      formattedPrice .. "</span><br>" .. divider .. "<br><br>"
            }
        end
    end
    
    -- Sort elements alphabetically by label
    table.sort(tempElements, function(a, b)
        return a.label < b.label
    end)
    
    -- Copy sorted elements to final elements table
    for _, v in ipairs(tempElements) do
        elements[#elements + 1] = v
    end
    
    -- Add "Complete Purchase" button
    elements[#elements + 1] = {
        label = (T.totalToPay or "Total to pay") .. " <br> " .. labelStyle:format("$0.00"),
        value = "finish",
        info = "finish",
        desc = (T.pressHereToFinish or "Press here to complete purchase") .. "<br><br><br><br><br>" .. 
               divider .. "<br>" .. font .. 
               "<span style='font-family:crock; float:left; font-size: 22px;'>" .. 
               (T.Total or "Total") .. " </span>" .. font .. 
               "<span style='font-family:crock;float:right; font-size: 22px;'>$" .. 
               "0.00" .. "</span><br>" .. divider .. "<br><br>"
    }
    
    MenuData.Open('default', GetCurrentResourceName(), 'MiningStoreBuy_' .. storeId .. category, {
        title = storeCfg.storeName,
        subtext = subMenuStyle:format(T.buyMenu or "Buy Tools"),
        align = "left",
        elements = elements,
        itemHeight = "4vh",
        lastmenu = "MiningStoreCategory"
    }, function(data, menu)
        if (data.current == "backup") then
            -- Use Config.SellItems directly to avoid nil issues
            local sellItems = Config.SellItems[storeId] or {}
            CloseStoreMenu() -- First close this menu
            Wait(100) -- Small delay to ensure proper menu closing
            OpenStoreMainMenu(storeId, buyItems, sellItems, storeCfg) -- Then reopen the main menu
            return
        end
        
        if data.current.action == "buy" then
            -- Handle quantity selection
            local itemName = data.current.info.itemName
            local quantity = data.current.value
            local buyPrice = data.current.info.buyprice * quantity
            
            -- Update buyTable with selected items
            if quantity > 0 then
                buyTable[itemName] = {
                    itemIndex = data.current.itemIndex, -- Use the stored index
                    quantity = quantity,
                    price = buyPrice
                }
            else
                buyTable[itemName] = nil
            end
            
            -- Update total price display
            local totalPrice = 0
            for _, item in pairs(buyTable) do
                totalPrice = totalPrice + item.price
            end
            
            -- Update the "finish" element with new total
            menu.setElement(#elements, "label", (T.totalToPay or "Total to pay") .. " <br> " .. labelStyle:format("$" .. string.format("%.2f", totalPrice)))
            menu.setElement(#elements, "desc", (T.pressHereToFinish or "Press here to complete purchase") .. "<br><br><br><br><br>" .. 
                   divider .. "<br>" .. font .. 
                   "<span style='font-family:crock; float:left; font-size: 22px;'>" .. 
                   (T.Total or "Total") .. " </span>" .. font .. 
                   "<span style='font-family:crock;float:right; font-size: 22px;'>$" .. 
                   string.format("%.2f", totalPrice) .. "</span><br>" .. divider .. "<br><br>")
            menu.refresh()
        end
        
        if data.current.value == "finish" then
            -- Process purchase
            local hasItems = false
            local itemsToBuy = 0
            
            -- First count how many items we're buying
            for _, itemData in pairs(buyTable) do
                if itemData.quantity > 0 then
                    itemsToBuy = itemsToBuy + 1
                end
            end
            
            -- Early check if we're not buying anything
            if itemsToBuy == 0 then
                VORPcore.NotifyRightTip(T.noItems or "You haven't selected any items to purchase", 3000)
                return -- Don't close menu, just return
            end
            
            -- Process purchases
            for itemName, itemData in pairs(buyTable) do
                if itemData.quantity > 0 then
                    hasItems = true
                    -- Add detailed debug info and ensure we have the correct index
                    local actualIndex = itemData.itemIndex
                    TriggerServerEvent("sb_miningstore:BuyItem", storeId, actualIndex, itemData.quantity)
                    
                    -- Add a small delay between each purchase to avoid race conditions
                    Wait(200)
                end
            end
        end
    end, function(data, menu)
        -- When menu is closed
        CloseStoreMenu()
    end)
end

-- Function to directly display sellable ore items
function OpenDirectSellMenu(storeId, category, sellItems, storeCfg)
    MenuData.CloseAll()
    
    -- First check if we have any items that can be sold
    local elements = {}
    local sellTable = {}
    local tempElements = {}
    local tempCategories = {}
    local count = 0
    
    -- Use the callback to get player inventory
    VORPcore.Callback.TriggerAsync("sb_miningzone:getInventoryItems", function(playerItems)
        if playerItems then
            -- Get all items in this category
            for idx, item in ipairs(sellItems) do
                if item.category == category then
                    -- Simple check if player has this item
                    local playerItem = playerItems[item.itemName]
                    if playerItem and playerItem.count > 0 then
                        -- Calculate sell price based on configuration
                        local itemPrice = item.sellprice
                        if storeCfg.RandomPrices then
                            itemPrice = item.randomprice
                        end
                        
                        -- Setup slider options
                        local sliderOptions = {}
                        for i = 0, playerItem.count do
                            sliderOptions[#sliderOptions + 1] = i
                        end
                        
                        -- Format price with proper decimals
                        local formattedPrice = string.format("%.2f", itemPrice)
                        
                        -- Add the item to our elements list for the menu
                        tempElements[#tempElements + 1] = {
                            label = string.format("<span style='color: white;'>%s</span>", item.itemLabel) .. "<br>" .. 
                                    string.format("<span style='color: gray;'>%s $%s " .. (T.each or "each") .. "</span>", T.worth or "Worth", formattedPrice),
                            value = 0,  -- Default to 0 (none selected)
                            item = playerItem,
                            info = {
                                itemName = item.itemName,
                                itemLabel = item.itemLabel,
                                sellprice = itemPrice,
                                desc = item.desc or "No description available."
                            },
                            itemIndex = idx, -- Save the item index for later use
                            type = "slider",
                            min = 0,
                            max = playerItem.count,
                            hop = 1,
                            options = sliderOptions,
                            action = "sell",
                            desc = item.desc .. "<br><br>you have x" .. playerItem.count .. 
                                   "<br><br> " .. (T.Price or "Price") .. " $" .. formattedPrice .. 
                                   "<br><br><br><br><br>" .. divider .. "<br>" .. font .. 
                                   "<span style='font-family:crock; float:left; font-size: 22px;'>" .. 
                                   (T.Total or "Total") .. " </span>" .. font .. 
                                   "<span style='font-family:crock;float:right; font-size: 22px;'>$0.00</span><br>" .. 
                                   divider .. "<br><br>"
                        }
                        count = count + 1
                    end
                end
            end
            
            -- Sort elements alphabetically by label
            table.sort(tempElements, function(a, b)
                return a.label < b.label
            end)
            
            -- Copy sorted elements to final elements table
            for _, v in ipairs(tempElements) do
                elements[#elements + 1] = v
            end
            
            -- Add total element and sell button if we have items
            local ctp = ""
            if count > 0 then
                ctp = "<span style='color: green;'>$</span>"
            end
            
            -- Add a FINISH button if we have elements
            if #elements > 0 then
                elements[#elements + 1] = {
                    label = (T.totalToReceive or "Total to receive") .. " <br> " .. ctp .. "0",
                    value = "sell",
                    info = "finish",
                    desc = (T.pressEnterToSell or "Press enter to sell") .. "<br><br><br><br><br>" .. 
                           divider .. "<br>" .. font .. 
                           "<span style='font-family:crock; float:left; font-size: 22px;'>" .. 
                           (T.Total or "Total") .. " </span>" .. font .. 
                           "<span style='font-family:crock;float:right; font-size: 22px;'>$" .. 
                           "0.00" .. "</span><br>" .. divider .. "<br><br>"
                }
            else
                elements[#elements + 1] = {
                    label = "No items to sell in this category",
                    value = "none",
                    desc = "You don't have any items that can be sold in this category."
                }
            end
            
            MenuData.Open('default', GetCurrentResourceName(), 'MiningStoreSell_' .. storeId .. category, {
                title = storeCfg.storeName,
                subtext = subMenuStyle:format(T.sellmenu or "Sell Mining Resources"),
                align = "left",
                elements = elements,
                itemHeight = "4vh",
                lastmenu = "MiningStoreCategory"
            }, function(data, menu)
                if (data.current == "backup") then
                    return OpenStoreMainMenu(storeId, buyItems, sellItems, storeCfg)
                end
                
                if data.current.action == "sell" then
                    -- Handle quantity selection
                    local itemName = data.current.info.itemName
                    local quantity = data.current.value
                    local sellPrice = data.current.info.sellprice * quantity
                    
                    -- Update sellTable with selected items
                    if quantity > 0 then
                        sellTable[itemName] = {
                            itemIndex = data.current.itemIndex, -- Use the stored index
                            quantity = quantity,
                            price = sellPrice
                        }
                    else
                        sellTable[itemName] = nil
                    end
                    
                    -- Update total price display
                    local totalPrice = 0
                    for _, item in pairs(sellTable) do
                        totalPrice = totalPrice + item.price
                    end
                    
                    -- Update item description with selected amount
                    menu.setElement(data.current.index, "desc", data.current.info.desc .. "<br><br>you have x" .. data.current.item.count .. 
                                    "<br><br> " .. (T.Price or "Price") .. "$" .. string.format("%.2f", sellPrice) .. 
                                    "<br><br><br><br><br>" .. divider .. "<br>" .. font .. 
                                    "<span style='font-family:crock; float:left; font-size: 22px;'>" .. 
                                    (T.Total or "Total") .. " </span>" .. font .. 
                                    "<span style='font-family:crock;float:right; font-size: 22px;'>$" .. 
                                    string.format("%.2f", sellPrice) .. "</span><br>" .. divider .. "<br><br>")
                    
                    -- Update the "finish" element with new total
                    menu.setElement(#elements, "desc", (T.pressEnterToSell or "Press enter to sell") .. "<br><br><br><br><br>" .. 
                                    divider .. "<br>" .. font .. 
                                    "<span style='font-family:crock; float:left; font-size: 22px;'>" .. 
                                    (T.Total or "Total") .. " </span>" .. font .. 
                                    "<span style='font-family:crock;float:right; font-size: 22px;'>$" .. 
                                    string.format("%.2f", totalPrice) .. "</span><br>" .. divider .. "<br><br>")
                    
                    -- Also update the label of the finish element
                    menu.setElement(#elements, "label", (T.totalToReceive or "Total to receive") .. " <br> <span style='color: green;'>$" .. string.format("%.2f", totalPrice) .. "</span>")
                    
                    menu.refresh()
                end
                
                if data.current.value == "sell" then
                    -- Process sale
                    local hasItems = false
                    local itemsSold = 0
                    local itemsToSell = 0
                    
                    -- First count how many items we're selling
                    for _, itemData in pairs(sellTable) do
                        if itemData.quantity > 0 then
                            itemsToSell = itemsToSell + 1
                        end
                    end
                    
                    -- Early check if we're not selling anything
                    if itemsToSell == 0 then
                        VORPcore.NotifyRightTip(T.notSelectedItem or "You haven't selected any items to sell", 3000)
                        return -- Don't close menu, just return
                    end
                    
                    -- Process sale in a safer way
                    for itemName, itemData in pairs(sellTable) do
                        if itemData.quantity > 0 then
                            hasItems = true
                            
                            -- Find the correct index in sellItems
                            local actualIndex = 0
                            for idx, item in ipairs(sellItems) do
                                if item.itemName == itemName then
                                    actualIndex = idx
                                    break
                                end
                            end
                            
                            -- Check if we found a valid index
                            if actualIndex > 0 then
                                TriggerServerEvent("sb_miningstore:SellItem", storeId, actualIndex, itemData.quantity)
                                
                                -- Increment our counter for sold items
                                itemsSold = itemsSold + 1
                                
                                -- Add a wait between each item sold
                                Wait(200)
                            else
                                VORPcore.NotifyRightTip("Error finding item " .. itemName, 3000)
                            end
                        end
                    end
                end
            end, function(data, menu)
                -- When menu is closed
                CloseStoreMenu()
            end)
        else
            VORPcore.NotifyRightTip("Error retrieving inventory", 3000)
            CloseStoreMenu()
        end
    end)
end

-- Register global event handlers for store responses
RegisterNetEvent("sb_miningstore:SellItemResponse")
AddEventHandler("sb_miningstore:SellItemResponse", function(success, message)
    if success then
        VORPcore.NotifyRightTip(message, 3000)
        -- Close menu after successful sale
        Wait(500) -- Give time for notification
        CloseStoreMenu()
    else
        -- On error, show message but don't close menu
        VORPcore.NotifyRightTip(message, 3000)
    end
end)

RegisterNetEvent("sb_miningstore:BuyItemResponse")
AddEventHandler("sb_miningstore:BuyItemResponse", function(success, message)
    if success then
        VORPcore.NotifyRightTip(message, 3000)
        -- Close menu after successful purchase
        Wait(500) -- Give time for notification
        CloseStoreMenu()
    else
        -- On error, show message but don't close menu
        VORPcore.NotifyRightTip(message, 3000)
    end
end)

-- Function to close store menu
function CloseStoreMenu()
    MenuData.CloseAll()
    isInMenu = false
    Config.UI(false)
end

-- Event for when store menu is closed
RegisterNetEvent("sb_miningstore:CloseMenu")
AddEventHandler("sb_miningstore:CloseMenu", function()
    isInMenu = false
    Config.UI(false)
end)

-- When mining finishes reset state
AddEventHandler("vorp_mining:finishedMining", function()
    playerMiningState = "idle"
end)

-- Handler for receiving player inventory data
RegisterNetEvent("vorp_inventory:client:getItemsTable")
AddEventHandler("vorp_inventory:client:getItemsTable", function(callback)
    -- This is a client-side implementation to simulate the inventory callback
    -- In a real scenario, VORP inventory would provide the actual items
    TriggerServerEvent("sb_miningzone:getPlayerItems", function(items)
        callback(items)
    end)
end)

-- Register the exports
exports("IsPlayerInMiningZone", IsPlayerInMiningZone)
exports("GetCurrentMiningZone", function() return currentZone end)
exports("GetConfigValue", function(key) 
    if Config[key] ~= nil then
        return Config[key]
    end
    return nil
end) 