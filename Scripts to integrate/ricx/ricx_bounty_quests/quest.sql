CREATE TABLE `quests2` (
  `identifier` varchar(50) NOT NULL,
  `charid` int(11) NOT NULL,
  `questtype` int(2) NOT NULL,
  `questid` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `quests2`
	ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT FIRST,
	ADD PRIMARY KEY (`id`);