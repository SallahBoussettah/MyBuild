# sb_police Commands

This document provides a comprehensive list of all commands available in the SB_POLICE resource.

## Standard Commands

| Command | Description | Usage | Permission |
|---------|-------------|-------|------------|
| `goonduty` | Go on duty as law enforcement | `/goonduty` | Must be in one of the off-duty law jobs |
| `gooffduty` | Go off duty from law enforcement | `/gooffduty` | Must be in one of the on-duty law jobs |
| `adjustbadge` | Toggle your badge visibility | `/adjustbadge` | Law enforcement |
| `pmenu` | Open the police menu | `/pmenu` | Law enforcement |
| `jail` | Jail a player | `/jail [player_id] [time_in_minutes] [jail_id]` | Law enforcement or admin |
| `unjail` | Release a player from jail | `/unjail [player_id]` | Law enforcement or admin |
| `fine` | Fine a player | `/fine [player_id] [amount]` | Law enforcement or admin |

## Jail IDs Reference

When using the `/jail` command, you can specify a jail location using the following jail IDs:

| Jail ID | Location |
|---------|----------|
| `sk` | Sisika (default) |
| `bw` | Blackwater |
| `ar` | Armadillo |
| `tu` | Tumbleweed |
| `st` | Strawberry |
| `val` | Valentine |
| `sd` | Saint Denis |
| `an` | Annesburg |

Example usage: `/jail 5 10 bw` will jail player ID 5 for 10 minutes in Blackwater jail.

## Law Enforcement Jobs

The following jobs are considered law enforcement roles in the system:

### On-Duty Jobs
- `police`
- `marshal`
- `lawmen`
- `sheriffrhodes`

### Off-Duty Jobs
- `offpolice`
- `offmarshal`
- `offlawmen`
- `offsheriffrhodes`

## Events for Developers

For developers integrating with this resource, the following server events are available:

| Event Name | Description | Parameters |
|------------|-------------|------------|
| `lawmen:JailPlayer` | Jail a player from another script | `function(id, time, "location_id")` |
| `sb_police:JailPlayer` | Internal event to jail a player | `player_id, time, location` |
| `sb_police:unjailed` | Release a player from jail | `player_id` |

## Additional Features

- **Handcuffs**: Press the handcuff hotkey (if enabled) or use the police menu to handcuff nearby players.
- **Search**: Use the search function in the police menu to search players for items.
- **Community Service**: Assign community service to players as an alternative to jail time.
- **Police Storage**: Access police storage at various law enforcement locations. 