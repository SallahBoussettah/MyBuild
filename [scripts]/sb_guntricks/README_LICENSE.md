# Bounty Hunter License Requirement for Gun Tricks

## Overview

This modification adds a requirement for players to have a 'Bounty Hunter License' item in their inventory before they can use the gun tricks functionality. The license is checked in real-time through multiple mechanisms:

1. The script checks for the license on startup
2. The script checks for the license every time a player tries to use gun tricks commands
3. The script checks for the license when the player uses the license item
4. The system listens for inventory changes to detect when license is added or removed
5. A background check runs every 30 seconds as an additional safeguard
6. Active tricks are disabled immediately if a player loses their license

## Features

- **Real-time License Checking**: Multiple verification points ensure the license status is always current
- **Immediate Updates**: The script detects when players receive or lose the license in real-time
- **Force-Check System**: Commands trigger an immediate verification before activating
- **In-Use Verification**: Active gun tricks verify license status regularly
- **License as Usable Item**: Players can use the license item to receive information about gun tricks
- **Clear Notifications**: Players are informed about license status changes
- **Server-Side Validation**: License checking is done server-side using VORP inventory API for security
- **Performance Optimized**: Cooldown system prevents excessive server calls

## Implementation Details

### Client-Side (client.lua)

The client script:
- Maintains a `hasLicense` state variable
- Forces a server license check before performing any action
- Implements a callback system for synchronous license verification
- Blocks commands for players without the license
- Shows notifications based on license status changes
- Periodically checks license status during active tricks
- Immediately disables tricks if license is lost

### Server-Side (server.lua)

The server script:
- Uses VORP inventory API to check for the `bountylicns` item
- Listens for official VORP inventory events to detect changes
- Supports a callback system for immediate verification
- Makes the license a usable item that provides information
- Implements debug logging for troubleshooting

## Technical Details

### Immediate License Verification

```lua
-- Client-side force check with callback
function ForceCheckLicense(callback)
    -- Send check request to server
    TriggerServerEvent("sb_guntricks:forceCheck")
    
    -- Create a one-time event handler for this specific check
    local eventName = "sb_guntricks:licenseCallback" .. GetGameTimer()
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(hasItem)
        hasLicense = hasItem
        callback(hasLicense)
        -- Clean up after use
        RemoveEventHandler(eventName)
    end)
    
    -- Register our callback with the server
    TriggerServerEvent("sb_guntricks:registerCallback", eventName)
end

-- Usage example
ForceCheckLicense(function(hasLicense)
    if hasLicense then
        ToggleGunTricks()
    else
        ShowNotification("You need a Bounty Hunter License to perform gun tricks.")
    end
end)
```

### Real-time Inventory Monitoring

```lua
-- Server-side monitoring of inventory changes
AddEventHandler('vorp:Server:OnAddToInventory', function(player, itemData, amount)
    if itemData.item == 'bountylicns' then
        -- Immediately notify client of license status change
        VORPInv:getItemCount(player, function(count)
            TriggerClientEvent('sb_guntricks:licenseResult', player, count > 0)
        end, 'bountylicns')
    end
end)
```

## Required Item

The script looks for the following item in the player's inventory:
- **Item ID**: `bountylicns`
- **Item Name**: Bounty Hunter License

## Installation

1. Replace your existing sb_guntricks script with this version
2. Ensure the `bountylicns` item exists in your Items.sql database
3. Restart the resource after making changes

## Troubleshooting

If players are having issues with license detection:
1. Check server console for debug messages showing license status checks
2. Verify the item ID matches exactly `bountylicns` in your database
3. Make sure the VORP inventory events are working correctly
4. Test by adding/removing the license item to see if status updates immediately 