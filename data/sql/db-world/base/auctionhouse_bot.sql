-- Set basic AH Bot params
UPDATE `mod_auctionhousebot` SET `minitems` = '50000', `maxitems` = '60000', `percentwhitetradegoods` = '40', `percentgreentradegoods` = '20', `percentwhiteitems` = '7', `percentgreenitems` = '12' WHERE `auctionhouse` = '2';
UPDATE `mod_auctionhousebot` SET `minitems` = '50000', `maxitems` = '60000', `percentwhitetradegoods` = '40', `percentgreentradegoods` = '20', `percentwhiteitems` = '7', `percentgreenitems` = '12' WHERE `auctionhouse` = '6';
UPDATE `mod_auctionhousebot` SET `minitems` = '50000', `maxitems` = '60000', `percentwhitetradegoods` = '40', `percentgreentradegoods` = '20', `percentwhiteitems` = '7', `percentgreenitems` = '12' WHERE `auctionhouse` = '7';

-- Disable items from AH Bot
REPLACE INTO `mod_auctionhousebot_disabled_items` (`item`) VALUES ('11099');  -- Dark Iron Ore (OLD)