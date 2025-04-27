# SB Gun Tricks - Keybinding Information

## Troubleshooting F3 Key Issues

If pressing F3 does not activate the gun tricks menu, there are several possible solutions:

### Solution 1: Check Your Game Settings

1. Open your RedM game settings
2. Go to "Key Bindings" or "Controls"
3. Check if F3 is already bound to another function
4. If so, either change that binding or choose a different key for gun tricks

### Solution 2: Change the Key in Game

1. Open your in-game chat (usually T key)
2. Type: `.bind keyboard F4 sb_toggle_guntricks`
3. This will change the gun tricks toggle key to F4
4. You can replace F4 with any other key you prefer

### Solution 3: Edit the Config File

1. Open `config.lua`
2. Find the line with `Config.StartKey`
3. Change it to one of these alternative key codes:
   - F2: `0x45F26704`
   - F4: `0xF1301666`
   - F5: `0x9CC7A1A4`
   - F6: `0x5B73C77D`

Example:
```lua
Config.StartKey = 0x45F26704 -- Changed to F2
```

## Full Key Code Reference

Here are some common key codes for RedM:

- F1: `0x3C7D6A95`
- F2: `0x45F26704`
- F3: `0x3C0A40F2` or `0x156F7119`
- F4: `0xF1301666`
- F5: `0x9CC7A1A4`
- F6: `0x5B73C77D`
- F7: `0x80F28E95`
- F8: `0x422D4A25`

## Default Controls for Gun Tricks

- Toggle menu: F3
- Perform trick: R
- End trick: X
- Next trick: Right Arrow
- Previous trick: Left Arrow 