-- Set basic AH Bot params
UPDATE `mod_auctionhousebot` SET `minitems` = '50000', `maxitems` = '60000', `percentwhitetradegoods` = '40', `percentgreentradegoods` = '20', `percentwhiteitems` = '7', `percentgreenitems` = '12' WHERE `auctionhouse` = '2';
UPDATE `mod_auctionhousebot` SET `minitems` = '50000', `maxitems` = '60000', `percentwhitetradegoods` = '40', `percentgreentradegoods` = '20', `percentwhiteitems` = '7', `percentgreenitems` = '12' WHERE `auctionhouse` = '6';
UPDATE `mod_auctionhousebot` SET `minitems` = '50000', `maxitems` = '60000', `percentwhitetradegoods` = '40', `percentgreentradegoods` = '20', `percentwhiteitems` = '7', `percentgreenitems` = '12' WHERE `auctionhouse` = '7';

-- Disable items from AH Bot
REPLACE INTO `mod_auctionhousebot_disabled_items` (`item`) VALUES ('11099');  -- Dark Iron Ore (OLD)
-- Restore valid trade goods
DELETE FROM `mod_auctionhousebot_disabled_items` WHERE `item` IN (6291, 6358, 6359, 7286, 7392, 8171, 8365, 10620, 10939, 10978, 10998, 11082, 11083, 11084, 11134, 11135, 11137, 11138, 11139, 11174, 11175, 11176, 11177, 11178, 13422, 13754, 13756, 13758, 13759, 13760, 13888, 13889, 13890, 14343, 14344, 15409, 15410, 15415, 15417, 16202, 16203, 17012, 20381, 20498, 20500, 20501, 20725, 21071, 21153, 22202, 22446, 22447, 22450, 24243, 25699, 25700, 27422, 27437, 29539, 29547, 29548, 33823, 33824, 34057, 35285, 36910, 36912, 38561, 39151, 39334, 39338, 39339, 39340, 39341, 39342, 39343, 41800, 41801, 41802, 41803, 41805, 41806, 41807, 41808, 41809, 41810, 41812, 41813, 41814, 43103, 43104, 43105, 43106, 43107, 43108, 43109, 46849);