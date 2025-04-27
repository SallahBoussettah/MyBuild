# Custom Scripts for VORP Core

This folder contains custom scripts that extend the VORP Core framework for our RedM server.

## Available Scripts

### SB ColorMap
A comprehensive map coloring resource that allows custom coloring of map regions, territory creation, and territory notifications to enhance player experience.

### SB Mining Zone
A comprehensive mining system resource focusing on creating realistic mining gameplay with designated mining zones and a complete mining economy.

### SB Prison Break
A prison escape system allowing players to break out of jail cells using dynamite and providing law enforcement alerts for immersive roleplay.

### SB Safe Zone
A comprehensive safe zone system allowing server administrators to create designated non-combat areas with custom notifications and visual indicators.

### SB Position
A coordinate display system providing developers and administrators with precise location information in customizable formats.

## Structure

Each script is contained in its own folder and follows the VORP Core architecture:
- Client-side code in `client` folder
- Server-side code in `server` folder
- Configuration in `config.lua` or `config` folder
- Language files in `translation` folder (when applicable)
- Resource manifest in `fxmanifest.lua`
- Documentation in `README.md`
- License details in `LICENSE`

## Installation Guidelines

1. Place the desired script folder in your server's `resources/[scripts]` directory
2. Add `ensure script_name` to your `server.cfg` (example: `ensure sb_safezone`)
3. Configure the script by editing its `config.lua` file
4. Restart your server or start the resource

## Development Guidelines

- Maintain consistent coding style with VORP Core
- Document all functions, events, and tables
- Handle database operations safely
- Test thoroughly before deployment
- Keep scripts modular where possible

## License

All scripts in this collection are released under a Modified MIT License that restricts usage to personal, non-commercial purposes for the individual purchaser only. Redistribution, reselling, or sharing of these scripts is prohibited without explicit permission from the copyright holder.

See the LICENSE file in each script folder for full details.

## Credits

All scripts created by Salah. 