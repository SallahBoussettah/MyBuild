local storedCharacters = {}

-- Function to check if a role has been changed to a privileged one
local function validatePrivilegeChange(current, previous, role)
    if previous.group ~= role and current.group == role then
        local embeds = {
            {
                color = 15158332, -- Red color
                title = Config.Database.lang.webhook.title,
                description = Config.Database.lang.webhook.description,
                fields = {
                    {
                        name = Config.Database.lang.webhook.playerName,
                        value = current.firstname..' '..current.lastname,
                    },
                    {
                        name = Config.Database.lang.webhook.identifier,
                        value = current.identifier
                    },
                    {
                        name = Config.Database.lang.webhook.characterId,
                        value = current.charidentifier
                    }
                },
                footer = {
                    text = "RedM Guardian | " .. os.date("%Y-%m-%d %H:%M:%S")
                }
            }
        }
        WebhookAlert.sendNewMessage(current.firstname..' '..current.lastname, Config.Database.lang.webhook.title, embeds)
        return false
    end
    return true
end

-- Initialize the database monitoring system
if Config.Database.active then
    Citizen.CreateThread(function()
        while true do
            if #Config.Database.privilegedRoles > 0 then
                -- Using oxmysql instead of ghmattimysql for better compatibility
                exports.oxmysql:execute('SELECT `identifier`, `steamname`, `charidentifier`, `group`, `firstname`, `lastname` FROM characters', {}, function(characters)
                    if characters and #characters > 0 then
                        local tempStorage = {}
                        for _, current in ipairs(characters) do
                            tempStorage[current.charidentifier] = current
        
                            if storedCharacters[current.charidentifier] == nil then
                                storedCharacters[current.charidentifier] = current
                                return
                            end
        
                            local previous = storedCharacters[current.charidentifier]
        
                            for _, role in ipairs(Config.Database.privilegedRoles) do
                                local passed = validatePrivilegeChange(current, previous, role)
                                if passed == false then
                                    break
                                end
                            end
                        end
        
                        storedCharacters = tempStorage
                    end
                end)
            end
            
            Citizen.Wait(Config.Database.adminCheckInterval)
        end
    end) 
end

-- Export functionality to allow checking from other resources
exports('getGuardianDB', function()
    local self = {}
    
    self.getStoredCharacters = function()
        return storedCharacters
    end
    
    return self
end) 