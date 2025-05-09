Config = {}

-- XSS Protection Configuration
-- Prevents username-based XSS attacks and validates player names
Config.XSS = {
    active = true,
    
    -- Block players with potentially malicious usernames
    blockInjectionAttempts = true,
    
    -- Validate and update Steam usernames on connection
    validateSteamNames = true,
    
    -- Maximum allowed username length
    maxUsernameLength = 32,
    
    -- Regular expressions for username validation
    -- These patterns detect common XSS payload attempts
    patterns = {
        '<[^>]*>',              -- HTML tags
        'javascript:',          -- JavaScript protocol
        'onerror=',             -- JavaScript event handlers
        'onload=',              -- JavaScript event handlers
        'onclick=',             -- JavaScript event handlers
        'data:text/html',       -- Data URI with HTML content
        '&#',                   -- HTML entity
        '\\u003C',              -- Unicode escape for '<'
        '\\x3C',                -- Hex escape for '<'
        '\\073\\074',           -- Octal escape for '<'
        '\\\\u002[Bb]',         -- Backslash escapes
        '\\\\x2[Bb]',           -- Backslash escapes
        'eval\\(',              -- JavaScript eval function
        'alert\\(',             -- JavaScript alert function
        'confirm\\(',           -- JavaScript confirm function
        'prompt\\(',            -- JavaScript prompt function
        'document\\.',          -- JavaScript document object
        'window\\.',            -- JavaScript window object
        '\\(\\)'                -- Function calls
    },
    
    -- Language settings
    lang = {
        reason = "XSS Injection Attempt Detected",
        update = "Validating Steam Username",
        kick = "You cannot join due to your username"
    }
}

-- Discord webhook settings (using sb_discord if available)
Config.Discord = {
    active = false,      -- Set to true to enable webhook notifications using sb_discord
    webhookType = "xss", -- Webhook type to use (must be defined in sb_discord config)
    logLevel = 1,        -- Log level for Discord notifications
    
    lang = {
        kickTitle = "XSS Protection - Player Blocked",
        kickReason = "Blocked for potential XSS attack in username"
    }
} 