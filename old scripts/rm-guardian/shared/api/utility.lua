-- Shared utility functions for RM Guardian

-- String sanitization helper
function SanitizeString(str)
    if not str then return "" end
    
    -- Remove HTML tags
    local sanitized = str:gsub("<[^>]*>", "")
    
    -- Remove common SQL injection patterns
    sanitized = sanitized:gsub("'", "''"):gsub(";", ""):gsub("-%-", "")
    
    return sanitized
end

-- Safe JSON encode with error handling
function SafeJsonEncode(data)
    local status, result = pcall(function() 
        return json.encode(data)
    end)
    
    if status then
        return result
    else
        print("JSON encode error: " .. tostring(result))
        return "{}"
    end
end

-- Safe JSON decode with error handling
function SafeJsonDecode(jsonStr)
    if not jsonStr or jsonStr == "" then
        return {}
    end
    
    local status, result = pcall(function()
        return json.decode(jsonStr)
    end)
    
    if status then
        return result
    else
        print("JSON decode error: " .. tostring(result))
        return {}
    end
end

-- Validate if a value is in a table
function IsInTable(tbl, val)
    if not tbl or type(tbl) ~= "table" then
        return false
    end
    
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    
    return false
end

-- Check if a string contains a substring (case insensitive)
function ContainsString(str, substr)
    if not str or not substr then
        return false
    end
    
    return string.find(string.lower(str), string.lower(substr), 1, true) ~= nil
end 