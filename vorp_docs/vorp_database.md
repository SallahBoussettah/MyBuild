# VORP Framework Database Structure

This document outlines the database tables and their relationships in the VORP framework.

## Core Tables

### users
Stores basic user information and permissions:
- `identifier` - Unique user identifier (usually Steam ID)
- `group` - User permission group
- `warnings` - Number of warnings received
- `banned` - Ban status
- `banneduntil` - Ban expiration timestamp
- `char` - Maximum number of characters allowed

### characters
Stores detailed character information:
- `identifier` - Links to user identifier
- `charidentifier` - Unique character ID
- `money`, `gold`, `rol` - Currency amounts
- `xp` - Experience points
- `health`, `stamina` - Character stats
- `job`, `joblabel`, `jobgrade` - Job information
- `firstname`, `lastname`, `gender`, `age` - Character details
- `skinPlayer`, `compPlayer` - Character appearance
- `inventory` - Character inventory contents
- `coords` - Last known position
- `status` - Character status values
- `ammo` - Ammunition data

## Inventory Tables

### items
Defines all available items in the server:
- `item` - Unique item identifier
- `label` - Display name
- `limit` - Stack limit
- `type` - Item type
- `usable` - If item can be used
- `groupId` - Item category grouping
- `metadata` - Additional item data
- `degradation` - Item degradation time
- `weight` - Item weight for inventory capacity

### item_group
Categorizes items for filtering:
- `id` - Group identifier
- `description` - Group name

### items_crafted
Tracks crafted items:
- `character_id` - Character who crafted the item
- `item_id` - Reference to item
- `metadata` - Crafted item data

### loadout
Stores weapon information:
- `identifier`, `charidentifier` - Owner references
- `name` - Weapon name
- `ammo` - Ammunition data
- `components` - Attached components
- `condition` - Weapon condition values
- `serial_number` - Unique weapon identifier

### character_inventories
Alternative inventory storage:
- `character_id` - Character reference
- `inventory_type` - Type of inventory
- `item_name` - Item identifier
- `amount` - Quantity
- `degradation` - Item wear level

## Property Tables

### housing
Stores housing ownership:
- `id` - House identifier
- `identifier`, `charidentifier` - Owner references
- `name` - House name
- `key` - House key data

### rooms
Stores room ownership:
- Similar structure to housing

## Economy Tables

### bank_users
Tracks bank accounts:
- `identifier`, `charidentifier` - Account owner
- `money`, `gold` - Account balances
- `items` - Items stored in bank
- `invspace` - Bank inventory capacity

## Horse and Vehicle Tables

### stables
Stores horse information:
- `identifier`, `charidentifier` - Owner references
- `name` - Horse name
- `modelname` - Horse model
- `status` - Horse health/stats
- `xp` - Horse experience
- `gear` - Equipment
- `inventory` - Horse inventory

### wagons
Stores wagon information:
- `identifier`, `charid` - Owner references
- `model` - Wagon model
- `name` - Wagon name
- `items` - Stored items

### horse_complements
Stores horse equipment:
- `identifier`, `charidentifier` - Owner references
- `complements` - Horse gear

## Miscellaneous Tables

### outfits
Stores saved character outfits:
- `identifier`, `charidentifier` - Owner references
- `title` - Outfit name
- `comps` - Clothing components data

### mailbox_mails
Stores in-game mail:
- `sender_id`, `receiver_id` - User references
- `message` - Mail content
- `opened` - Read status
- `received_at` - Timestamp

### whitelist
Manages server whitelist:
- `identifier` - User identifier
- `status` - Whitelist status

## Database Relationships

The database is designed with primary and foreign key relationships to maintain data integrity:

1. `users` is the primary table that links to `characters` via the `identifier` field
2. `characters` links to inventory, loadout, housing, and other character-specific tables via `charidentifier`
3. Item tables are connected through `item` and `item_group` relationships

## Database Maintenance

### Backing Up
It's recommended to regularly back up your database using:
```sql
mysqldump -u username -p database_name > backup_name.sql
```

### Optimizing Performance
For large servers, consider these optimizations:
- Add indexes to frequently queried fields
- Regularly clean up unused data
- Monitor table sizes and query performance

### Character Data Cleanup
For inactive characters:
```sql
-- Example: Find characters inactive for over 60 days
SELECT * FROM characters WHERE LastLogin < DATE_SUB(NOW(), INTERVAL 60 DAY);
```

## Common Database Operations

### Adding New Items
```sql
INSERT INTO items (item, label, limit, type, usable, groupId, desc, weight)
VALUES ('melee_knife_trader', 'Trader Knife', 1, 'item_standard', 1, 4, 'A special knife for traders', 0.5);
```

### Updating Player Money
```sql
UPDATE characters SET money = money + 100.00 WHERE charidentifier = 123;
```

### Finding Player Information
```sql
SELECT c.* FROM characters c
JOIN users u ON c.identifier = u.identifier
WHERE u.identifier = 'steam:123456789';
```

### Managing Whitelist
```sql
-- Add user to whitelist
INSERT INTO whitelist (identifier, status) VALUES ('steam:123456789', 1);

-- Remove from whitelist
DELETE FROM whitelist WHERE identifier = 'steam:123456789';
```

## Database Schema Evolution

When updating the VORP framework, you may need to update your database schema. The core module includes automatic migrations when `Config.autoUpdateDB` is enabled. 

For manual migrations, always:
1. Back up your database first
2. Test changes on a development server
3. Apply changes during scheduled maintenance
4. Verify data integrity after updates 