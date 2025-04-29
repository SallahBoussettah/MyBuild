# Pogue Robbery Script

## Overview

The NPC script is designed to enhance gameplay by introducing Non-Player Characters (NPCs) that interact with players during various robbery scenarios, such as bank and store heists. This script manages NPC behavior, police presence checks, alert notifications, and the mechanics of executing robberies.

---

## Functionalities

### 1. Bank Robbery

The bank robbery feature allows players to initiate a robbery by interacting with a designated NPC. This NPC serves as a point of contact for the robbery, providing the player with necessary information or starting the robbery process.

- **Interaction**: Players can approach the NPC and trigger a conversation or action that leads to the bank robbery.
- **Requirements**: The script checks if the player has necessary items, such as dynamite, and verifies if there is sufficient police presence in the area.
- **Execution**: Upon meeting the requirements, the robbery is executed, and players are rewarded based on their actions.

### 2. Store Robbery

Similar to bank robberies, the store robbery feature enables players to rob stores through NPC interactions.

- **Interaction**: Players can interact with the NPC to initiate the robbery.
- **Cooldown Management**: The script manages cooldown periods to prevent players from robbing the same store repeatedly in a short amount of time.
- **Rewards**: Successful robberies lead to players receiving items and other benefits.

### 3. Police Checks

To maintain balance and realism in the gameplay, the script includes checks for police presence.

- **Count Verification**: Before allowing a robbery, the script verifies how many players are currently in police roles.
- **Restriction**: If there are not enough police present, the robbery cannot proceed, and the player receives a notification explaining the situation.

### 4. Alert Notifications

When a robbery is initiated, alert notifications are sent to nearby police player, enhancing the dynamic interaction within the game.

- **Notification System**: The script triggers an alert that informs all relevant police players about the ongoing robbery.
- **Coordination**: Alerts include coordinates and details that guide police towards the location of the crime, enabling them to respond effectively.

---

## Conclusion

This NPC script provides essential functionalities that create an immersive and interactive environment for players engaging in robbery activities. By managing NPC interactions, police checks, and alert notifications, the script adds depth to gameplay and enhances the overall experience.

---

The `Config` table includes several settings that are either required or optional for the gameplay mechanics. Here’s a brief summary of the optional settings:

### Optional Settings

1. **Config.NPCS**: 
   - **outfit**: This parameter is optional. If not specified, the NPC will use a default outfit. If included, it allows for a custom outfit preset for the NPC.

2. **Config.robberyCooldown**: 
   - Optional; while it's beneficial to set a cooldown for robbery attempts, you could theoretically set it to `0` if you want to allow continuous attempts without waiting.

3. **Config.ZoneSize**: 
   - Optional; defines the interaction zone around robbery locations. You can adjust this size, but if omitted, the default behavior may apply based on your game's mechanics.

4. **Config.DynamitePrice**: 
   - Optional; it specifies the cost of dynamite used for robberies. If not defined, you could set a fixed price elsewhere in your logic.

5. **Config.StoreItems & Config.BankItems**: 
   - Optional; these tables define the rewards for successful robberies. If you choose not to use them, you can handle rewards differently within your script.

6. **Config.Languages**: 
   - Optional; while necessary for multilingual support, you can define only one language. If additional languages are not needed, you can simplify this section.

7. **Config.Banks and Config.Shops**: 
   - Optional; you can add banks or stores as needed for gameplay. This allows you to customize the robbery locations and the types of establishments available in your game world.
