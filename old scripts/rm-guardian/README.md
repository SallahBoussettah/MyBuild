# RedM Guardian - Anti-Cheat System

A comprehensive anti-cheat and server security system for RedM servers. This resource is designed to detect and prevent common exploits, cheats, and security vulnerabilities in your server.

## Features

- **Idle Player Management**: Automatically removes AFK players to free up server slots
- **Input Monitoring**: Detects rapid input/clicking that may indicate macro usage
- **Command Blacklisting**: Blocks suspicious commands associated with cheat menus
- **Key Combination Monitoring**: Detects key combinations used to activate cheats
- **Resource Protection**: Prevents unauthorized resource manipulation
- **Database Security**: Monitors database role changes to prevent privilege escalation
- **Event Rate Limiting**: Prevents event spam and exploitation
- **Username Validation**: Blocks SQL injection and malicious username inputs
- **Entity Blacklisting**: Prevents spawning of specific blacklisted objects
- **Weapon Blacklisting**: Controls which weapons players can use
- **Health Integrity**: Prevents health/godmode hacks
- **Discord Integration**: Sends detailed security alerts to a Discord webhook

## Installation

1. Place the `rm-guardian` folder in your server's resources directory
2. Add `ensure rm-guardian` to your server.cfg (make sure it starts before other resources)
3. Configure the options in `config.lua` to suit your server's needs
4. Restart your server

## Configuration

The `config.lua` file contains numerous options to customize the anti-cheat behavior:

- Set Discord webhook information for alerts
- Adjust detection thresholds for various checks
- Configure admin roles that have exemptions to certain checks
- Customize warning and kick messages
- Enable/disable individual protection modules

## Commands

- `/idlewhitelist [id]` - Add a player to the idle whitelist (admin only)
- `/idleunwhitelist [id]` - Remove a player from the idle whitelist (admin only)

## Developer API

RedM Guardian provides exports that other resources can use:

```lua
-- Get webhook functionality
local webhook = exports['rm-guardian']:webhookAlert()
webhook.sendMessage(webhookUrl, webhookName, webhookAvatar, name, description, embeds)

-- Get database information
local db = exports['rm-guardian']:getGuardianDB()
local characters = db.getStoredCharacters()

-- Validate text input
local textIsClean = exports['rm-guardian']:validateTextInput(text)
```

## Requirements

- RedM server
- VORP Core (for certain features, can be disabled for other frameworks)
- oxmysql

## License

This resource is protected under copyright law. You may not redistribute or repackage this resource without explicit permission.

## Credits

Created by RedM Guardian Team 