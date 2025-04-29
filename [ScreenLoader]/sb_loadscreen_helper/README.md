# SB Loadscreen Helper

A companion utility script for the SB Loadscreen resource, enhancing functionality with improved game state detection, spawn handling, and skip controls for a seamless loading experience.

## Table of Contents
- [Core Features](#core-features)
- [Installation](#installation)
- [Technical Details](#technical-details)
- [License](#license)
- [Credits](#credits)

## Core Features

### Game State Detection
- **Initialization Tracking**: Accurately detects when the game has fully initialized
- **Spawn Monitoring**: Identifies first player spawn events
- **Online Status**: Provides reliable online state information to the loadscreen
- **Automatic Processing**: Works in the background with no configuration needed

### Skip Controls
- **Spacebar Detection**: Enhanced detection of player skip attempts
- **Intelligent Handling**: Prevents premature skipping before the game is ready
- **Consistent Experience**: Creates a smoother transition from loadscreen to gameplay

### Integration System
- **NUI Callbacks**: Communicates state changes to the loadscreen interface
- **Direct Compatibility**: Designed specifically for the SB Loadscreen resource
- **Seamless Operation**: No visible interruptions for players

## Installation

1. Download the resource
2. Place in your `resources/[screenLoader]` folder
3. Ensure the folder is named `sb_loadscreen_helper`
4. Add `ensure sb_loadscreen_helper` to your server.cfg before any loadscreen resources
5. Restart your server

## Technical Details

### Requirements
- RedM server
- SB Loadscreen resource

### Events and Callbacks

#### NUI Callbacks
- `isgameinitiated`: Returns online status and spacebar state to the loadscreen

#### Game Events
- `playerSpawned`: Handles player first spawn detection

### Client Functions
- Monitors game initialization status
- Tracks spacebar key presses for skip functionality
- Updates loadscreen with accurate game state information

### Implementation Notes
- Uses native RedM functions to check for accurate game state information
- Employs a lightweight thread system with minimal resource impact
- Provides a more reliable way to determine when the game is truly ready
- Resolves common issues with standard loadscreen timeout and skip mechanics

## License

This script is protected by the cfx.re Escrow and Keymaster system and is licensed exclusively to the individual purchaser. The license is tied to the purchaser's cfx.re account.

### Key License Terms:
- Script is bound to the purchaser's cfx.re account license key
- No modification is permitted as the script is fully encrypted
- No redistribution, reselling, or transfer allowed
- No decompilation or reverse engineering permitted
- For use only on servers owned/operated by the purchaser

For complete license terms, please see the [LICENSE](./LICENSE) file included with this script.

**IMPORTANT**: Attempting to circumvent the protection system or violate license terms will result in immediate termination of your license without refund.

## Credits

Created by Salah
