/*
Inspired by the work by Rochet2 "TrinityCore Portal Master"
Download it from from http://rochet2.github.io/
*/

SET
@ENTRY            := 190001,
@NAME             := "Zoidgie",
@SUBNAME          := "Zone Relocator",

-- What the NPC looks like
-- @MODEL            := 21572, -- Default character
-- @MODEL            := 19343, -- Goblin character
@MODEL            := 3124, -- Gnome character
@SCALE          := 2,

-- Select if the NPC is casting or not
@AURA             := "30540", -- not casting
-- @AURA             := "35766", -- casting

-- If cross faction, set the faction values to 0, otherwise keep them as 469 and 67.
-- 469 = Alliance
-- 67  = Horde
-- 0   = Both factions
@ALLIANCE_FACTION := 469,
@HORDE_FACTION    := 67,

@TEXT_ID        := 300005,
@GOSSIP_MENU    := 50009;

-- Deleting code

DELETE FROM creature_template WHERE entry = @ENTRY;
DELETE FROM creature_template_model WHERE CreatureID = @ENTRY;
DELETE FROM creature_template_addon WHERE Entry = @ENTRY ;
DELETE FROM gossip_menu WHERE menuid BETWEEN @GOSSIP_MENU AND @GOSSIP_MENU+8;
DELETE FROM npc_text WHERE ID BETWEEN @TEXT_ID AND @TEXT_ID+4;
DELETE FROM gossip_menu_option WHERE menuid = @GOSSIP_MENU;
DELETE FROM gossip_menu_option WHERE menuid BETWEEN @GOSSIP_MENU AND @GOSSIP_MENU+8;
DELETE FROM smart_scripts WHERE entryorguid = @ENTRY AND source_type = 0;
DELETE FROM conditions WHERE (SourceTypeOrReferenceId = 15 OR SourceTypeOrReferenceId = 14) AND SourceGroup BETWEEN @GOSSIP_MENU AND @GOSSIP_MENU+8;
DELETE from creature WHERE id1 = @ENTRY;

-- Teleporter

INSERT INTO creature_template (entry, name, subname, IconName, gossip_menu_id, minlevel, maxlevel, faction, npcflag, speed_walk, speed_run, unit_class, unit_flags, type, type_flags, RegenHealth, flags_extra, AIName, ScriptName) VALUES
(@ENTRY, @NAME, @SUBNAME, "Directions", @GOSSIP_MENU, 71, 71, 35, 3, 1, 1.14286, 1, 1, 7, 138936390, 1, 2, "SmartAI", "SmartAI");

-- INSERT INTO  creature_template_model (CreatureID,CreatureDisplayID,DisplayScale) VALUES
-- (@ENTRY, @MODEL, @SCALE);
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(@Entry, 0, @MODEL, @SCALE, 1.0, NULL);

-- Teleporter aura

INSERT INTO creature_template_addon (entry, mount, bytes1, bytes2, emote, path_id, auras) VALUES (@ENTRY, 0, 0, 0, 0, 0, @AURA);

-- Gossip header text link to menus

INSERT INTO gossip_menu (menuid, textid) VALUES
-- (@GOSSIP_MENU+4, @TEXT_ID+3),
-- (@GOSSIP_MENU+3, @TEXT_ID+2),
-- (@GOSSIP_MENU+2, @TEXT_ID+2),
-- (@GOSSIP_MENU+1, @TEXT_ID+2),
-- (@GOSSIP_MENU+8, @TEXT_ID+4),
-- (@GOSSIP_MENU+7, @TEXT_ID+4),
-- (@GOSSIP_MENU+6, @TEXT_ID+4),
-- (@GOSSIP_MENU+5, @TEXT_ID+4),
-- (@GOSSIP_MENU, @TEXT_ID+1),
(@GOSSIP_MENU, @TEXT_ID);

-- Gossip header texts

INSERT INTO npc_text (ID, text0_0, em0_1) VALUES
(@TEXT_ID, "$BWhere would you like to be ported?$B", 0);

-- Conditions for gossip option and menu factions

INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, ConditionTypeOrReference, ConditionValue1, Comment) VALUES
(15, @GOSSIP_MENU, 1, 6, @ALLIANCE_FACTION, "Northshire Valley"),
(15, @GOSSIP_MENU, 2, 6, @HORDE_FACTION, "Valley of Trials"),
(15, @GOSSIP_MENU, 3, 6, @ALLIANCE_FACTION, "Shadowglen"),
(15, @GOSSIP_MENU, 4, 6, @ALLIANCE_FACTION, "Coldridge Valley"),
(15, @GOSSIP_MENU, 5, 6, @ALLIANCE_FACTION, "Amman Vale"),
(15, @GOSSIP_MENU, 6, 6, @HORDE_FACTION, "Camp Narache"),
(15, @GOSSIP_MENU, 7, 6, @HORDE_FACTION, "Shadow Grave"),
(15, @GOSSIP_MENU, 8, 6, @HORDE_FACTION, "Sunstrider Isle");

-- Gossip options:

INSERT INTO gossip_menu_option (menuid, optionid, optionicon, optiontext, optiontype, optionnpcflag, actionmenuid, actionpoiid, boxcoded, boxmoney, boxtext) VALUES
(@GOSSIP_MENU, 1, 2, "Northshire Valley", 1, 1, @GOSSIP_MENU, 0, 0, 0, "This is the starting area for humans, really?"),
(@GOSSIP_MENU, 2, 2, "Valley of Trials", 1, 1, @GOSSIP_MENU, 0, 0, 0, "This is the starting zone for orcs and trolls, really?"),
(@GOSSIP_MENU, 3, 2, "Shadowglen", 1, 1, @GOSSIP_MENU, 0, 0, 0, "This is the starting zone for night elves, really?"),
(@GOSSIP_MENU, 4, 2, "Coldridge Valley", 1, 1, @GOSSIP_MENU, 0, 0, 0, "This is the starting zone for dwarfs and gnomes, really?"),
(@GOSSIP_MENU, 5, 2, "Amman Vale", 1, 1, @GOSSIP_MENU, 0, 0, 0, "This is the starting area for draenei, really?"),
(@GOSSIP_MENU, 6, 2, "Camp Narache", 1, 1, @GOSSIP_MENU, 0, 0, 0, "This is the starting zone for tauren, really?"),
(@GOSSIP_MENU, 7, 2, "Shadow Grave", 1, 1, @GOSSIP_MENU, 0, 0, 0, "This is the starting area for undeads, really?"),
(@GOSSIP_MENU, 8, 2, "Sunstrider Isle", 1, 1, @GOSSIP_MENU, 0, 0, 0, "This is the starting area for blood elves, really?");

-- Teleport scripts:

INSERT INTO smart_scripts (entryorguid, source_type, id, link, event_type, event_phase_mask, event_chance, event_flags, event_param1, event_param2, event_param3, event_param4, action_type, action_param1, action_param2, action_param3, action_param4, action_param5, action_param6, target_type, target_param1, target_param2, target_param3, target_x, target_y, target_z, target_o, comment) VALUES 
(@ENTRY, 0, 1, 0, 62, 0, 100, 0, @GOSSIP_MENU, 1, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -8951.69, -137.719, 83.4182, 5.73451, "Teleporter zone script"), -- Northshire Valley
(@ENTRY, 0, 2, 0, 62, 0, 100, 0, @GOSSIP_MENU, 2, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -615.54, -4256.95, 38.9563, 5.72947, "Teleporter zone script"), -- Valley of Trials
(@ENTRY, 0, 3, 0, 62, 0, 100, 0, @GOSSIP_MENU, 3, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 10309.7, 830.437, 1326.45, 4.55531, "Teleporter zone script"), -- Shadowglen
(@ENTRY, 0, 4, 0, 62, 0, 100, 0, @GOSSIP_MENU, 4, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6240.86, 328.475, 382.421, 5.65094, "Teleporter zone script"), -- Coldridge Valley
(@ENTRY, 0, 5, 0, 62, 0, 100, 0, @GOSSIP_MENU, 5, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -3964.11,-13933.7,100.142,2.41507, "Teleporter zone script"), -- Ammen Vale
(@ENTRY, 0, 6, 0, 62, 0, 100, 0, @GOSSIP_MENU, 6, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -2918.95, -259.82, 53.1565, 5.49428, "Teleporter zone script"), -- Camp Narache
(@ENTRY, 0, 7, 0, 62, 0, 100, 0, @GOSSIP_MENU, 7, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1675.61, 1678.59, 121.671, 2.687, "Teleporter zone script"), -- Shadow Grave
(@ENTRY, 0, 8, 0, 62, 0, 100, 0, @GOSSIP_MENU, 8, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 10350.8, -6356.39, 33.2554, 6.03187, "Teleporter zone script"); -- Sunstrider Isle


-- Teleporter spawns:

ALTER TABLE creature AUTO_INCREMENT = 200000;
INSERT INTO creature (id1, map, spawnMask, phaseMask, position_x, position_y, position_z, orientation, spawntimesecs, curhealth, curmana) VALUES
(@ENTRY, 530, 1, 1, 10354, -6357.41, 33.5446, 3.41648, 300, 4163, 0),
(@ENTRY, 1, 1, 1, -2916.73, -263.231, 53.5359, 1.44586, 300, 4163, 0),
(@ENTRY, 0, 1, 1, 1670.89, 1681, 120.719, 5.81193, 300, 4163, 0),
(@ENTRY, 530, 1, 1, -3967.39, -13931.4, 100.227, 0.223838, 300, 4163, 0),
(@ENTRY, 1, 1, 1, 10308.8, 826.583, 1326.49, 1.26841, 300, 4163, 0),
(@ENTRY, 0, 1, 1, -6237.62, 326.006, 382.586, 2.61929, 300, 4163, 0),
(@ENTRY, 1, 1, 1, -612.137, -4259.88, 38.9563, 2.2266, 300, 4163, 0),
(@ENTRY, 0, 1, 1, -8949.13, -139.465, 83.5116, 2.49756, 300, 4163, 0);
