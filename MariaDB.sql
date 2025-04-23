create database 1899rp;
use 1899rp;

CREATE TABLE  `users` (
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `group` varchar(50) DEFAULT 'user',
  `warnings` int(11) DEFAULT 0,
  `banned` tinyint(1) DEFAULT NULL,
  `banneduntil` int(10) DEFAULT 0,
  `char` INT DEFAULT 5, /* max characters allowed*/
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE `bank_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `identifier` varchar(50) NOT NULL COLLATE 'utf8mb4_bin',
  `charidentifier` int(11) NOT NULL,
  `money` double(22,2) DEFAULT 0.00,
  `gold` double(22,2) DEFAULT 0.00,
  `items` varchar(1000) DEFAULT '[]',
  `invspace` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  INDEX `bankusers` (`identifier`) USING BTREE,
  CONSTRAINT `bankusers` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=UTF8MB4;

CREATE TABLE `characters` (
  `identifier` VARCHAR(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `steamname` VARCHAR(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `charidentifier` INT(11) NOT NULL AUTO_INCREMENT,
  `group` VARCHAR(10) COLLATE utf8mb4_bin DEFAULT 'user',
  `money` double(11, 2) DEFAULT 0.00,
  `gold` double(11, 2) DEFAULT 0.00,
  `rol` double(11, 2) NOT NULL DEFAULT 0.00,
  `xp` INT(11) DEFAULT 0,
  `healthouter` INT(4) DEFAULT 500,
  `healthinner` INT(4) DEFAULT 100,
  `staminaouter` INT(4) DEFAULT 100,
  `staminainner` INT(4) DEFAULT 100,
  `hours` float NOT NULL DEFAULT 0,
  `LastLogin` date DEFAULT NULL,
  `inventory` mediumtext COLLATE utf8mb4_bin DEFAULT NULL,
  `slots` DECIMAL(20,1) NOT NULL DEFAULT 35.0,
  `job` VARCHAR(50) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `joblabel` VARCHAR(255) COLLATE utf8mb4_bin DEFAULT 'Unemployed',
  `meta` VARCHAR(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `firstname` VARCHAR(50) COLLATE utf8mb4_bin DEFAULT ' ',
  `lastname` VARCHAR(50) COLLATE utf8mb4_bin DEFAULT ' ',
  `character_desc` varchar(1000) NOT NULL DEFAULT ' ' COLLATE 'utf8mb4_bin',
	`gender` VARCHAR(50) NOT NULL DEFAULT ' ' COLLATE 'utf8mb4_bin',
	`age` INT(11) NOT NULL DEFAULT '0',
	`nickname` VARCHAR(50) NULL DEFAULT ' ' COLLATE 'utf8mb4_bin',
  `skinPlayer` mediumtext COLLATE utf8mb4_bin DEFAULT NULL,
  `compPlayer` mediumtext COLLATE utf8mb4_bin DEFAULT NULL,
  `compTints` mediumtext NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
  `jobgrade` INT(11) DEFAULT 0,
  `coords` varchar(1000) COLLATE utf8mb4_bin DEFAULT '{}',
  `status` varchar(140) COLLATE utf8mb4_bin DEFAULT '{}',
  `isdead` tinyint(1) DEFAULT 0,
  `skills` text COLLATE utf8mb4_bin DEFAULT NULL,
  `walk` VARCHAR(50) COLLATE utf8mb4_bin DEFAULT 'noanim',
  `gunsmith` double(11, 2) DEFAULT 0.00,
  `ammo` varchar(1000) COLLATE utf8mb4_bin DEFAULT '{}',
  `discordid` VARCHAR(255) COLLATE utf8mb4_bin DEFAULT '0',
  `lastjoined` varchar(1000) COLLATE utf8mb4_bin DEFAULT '[]',
  UNIQUE KEY `identifier_charidentifier` (`identifier`, `charidentifier`) USING BTREE,
  KEY `charidentifier` (`charidentifier`) USING BTREE,
  KEY `identifier` (`identifier`),
  KEY `money` (`money`),
  KEY `meta` (`meta`),
  KEY `steamname` (`steamname`),
  CONSTRAINT `FK_characters_users` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

CREATE TABLE `housing` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `charidentifier` int(11) NOT NULL,
  `key` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `key` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE  `character_inventories` (
  `character_id` int(11) DEFAULT NULL,
  `inventory_type` varchar(100) NOT NULL DEFAULT 'default',
  `item_crafted_id` int(11) NOT NULL,
  `item_name` VARCHAR(50) COLLATE 'utf8mb4_general_ci' DEFAULT 'item',
  `amount` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `degradation` INT(11) NULL DEFAULT NULL,
  `percentage` INT(11) NULL DEFAULT NULL,
  KEY `character_inventory_idx` (`character_id`,`inventory_type`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE  `herbalists` (
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `location` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`identifier`) USING BTREE,
  UNIQUE KEY `identifier_charidentifier` (`identifier`,`charidentifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE `item_group` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `description` VARCHAR(255) NOT NULL COMMENT 'Description of Item Group',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=UTF8MB4;

-- Insert default item group first
INSERT INTO `item_group` (`id`, `description`) VALUES (1, 'default');

-- Insert additional item groups
INSERT INTO `item_group` (`description`) VALUES
    ('medical'),
    ('foods'),
    ('tools'),
    ('weapons'),
    ('ammo'),
    ('documents'),
    ('animals'),
    ('valuables'),
    ('horse'),
    ('herbs');

CREATE TABLE `items` (
	`item` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`label` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`limit` INT(11) NOT NULL DEFAULT '1',
	`can_remove` TINYINT(1) NOT NULL DEFAULT '1',
	`type` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`usable` TINYINT(1) NULL DEFAULT NULL,
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`groupId` INT(10) UNSIGNED NOT NULL DEFAULT '1' COMMENT 'Item Group ID for Filtering',
	`metadata` varchar(1000) NULL DEFAULT '{}' COLLATE 'utf8mb4_bin',
	`desc` VARCHAR(5550) NOT NULL DEFAULT 'nice item' COLLATE 'utf8mb4_general_ci',
    `degradation` INT(11) NOT NULL DEFAULT 0 COMMENT 'if 0 Item do not degrade use a positive number (in minutes) to enable degradation min is 1',
    `weight` DECIMAL(20,2) NOT NULL DEFAULT 0.25, /* Weight default of items  */
	PRIMARY KEY (`item`) USING BTREE,
	UNIQUE INDEX `id` (`id`) USING BTREE,
	INDEX `FK_items_item_group` (`groupId`) USING BTREE,
	CONSTRAINT `FK_items_item_group` FOREIGN KEY (`groupId`) REFERENCES `item_group`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `metadata` CHECK (json_valid(`metadata`))
)COLLATE='utf8mb4_general_ci' ENGINE=InnoDB ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1;

CREATE TABLE `items_crafted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_name` VARCHAR(50) COLLATE 'utf8mb4_general_ci' DEFAULT 'item',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `metadata` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`metadata`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ID` (`id`),
  KEY `crafted_item_idx` (`character_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=UTF8MB4;

CREATE TABLE  `loadout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
  `charidentifier` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `ammo` varchar(255) NOT NULL DEFAULT '{}',
  `components` varchar(255) NOT NULL DEFAULT '{}',
  `dirtlevel` double DEFAULT 0,
  `mudlevel` double DEFAULT 0,
  `conditionlevel` double DEFAULT 0,
  `rustlevel` double DEFAULT 0,
  `used` tinyint(4) DEFAULT 0,
  `used2` tinyint(4) DEFAULT 0,
  `dropped` int(11) NOT NULL DEFAULT 0,
  `comps` varchar(1000) NOT NULL DEFAULT '{}',
  `label` varchar(50) DEFAULT NULL,
  `curr_inv` varchar(100) NOT NULL DEFAULT 'default',
  `serial_number` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
  `custom_label` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
  `custom_desc` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=UTF8MB4;

CREATE TABLE  `mailbox_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` varchar(50) DEFAULT NULL,
  `sender_firstname` varchar(50) DEFAULT NULL,
  `sender_lastname` varchar(50) DEFAULT NULL,
  `receiver_id` varchar(50) DEFAULT NULL,
  `receiver_firstname` varchar(50) DEFAULT NULL,
  `receiver_lastname` varchar(50) DEFAULT NULL,
  `message` varchar(1000) DEFAULT NULL,
  `opened` tinyint(1) DEFAULT 0,
  `received_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE  `outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(45) NOT NULL,
  `charidentifier` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `comps` varchar(1000) DEFAULT NULL,
  `compTints` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE `wagons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(40) NOT NULL,
  `charid` int(11) NOT NULL,
  `selected` int(11) NOT NULL DEFAULT 0,
  `model` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `items` varchar(1000) DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `FK_horses_characters` (`charid`),
  KEY `model` (`model`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=UTF8MB4;

CREATE TABLE `stables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `charidentifier` int(11) NOT NULL,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `modelname` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `xp` int(11) NULL DEFAULT 0,
  `injured` int(11) NULL DEFAULT 0,
  `gear` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `isDefault` int(11) NOT NULL DEFAULT 0,
  `inventory` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

CREATE TABLE `horse_complements`  (
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `charidentifier` int(11) NOT NULL,
  `complements` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  UNIQUE INDEX `identifier`(`identifier`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE `whitelist` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`status` TINYINT(1) NULL DEFAULT NULL,
	`firstconnection` TINYINT(1) NULL DEFAULT '1',
	`discordid` VARCHAR(255) NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `identifier` (`identifier`) USING BTREE
)COLLATE='utf8mb4_general_ci' ENGINE=InnoDB ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1;




