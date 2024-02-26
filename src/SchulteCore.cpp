// Add all scripts in one
#include "bot_ai.h"
#include "botcommon.h"
#include "botdatamgr.h"
#include "botgossip.h"
#include "botspell.h"
#include "bottext.h"
#include "botmgr.h"
#include "botwanderful.h"
#include "Creature.h"
#include "Log.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "Maps/MapMgr.h"

class schulte_core : public WorldScript
{
public:
  schulte_core() : WorldScript("schulte_core") { }
  void OnStartup()
  {
    uint8 localeIndex = 0;
    CreatureTemplateContainer const* ctc = sObjectMgr->GetCreatureTemplates();
    typedef std::vector<BotInfo> BotList;
    BotList botlist;
    uint8 phaseMask = 1;
    Map *map = sMapMgr->FindMap(0, 0);
    float posX = -11215.598;
    float posY = -1744.0117;
    float posZ = -29.961655;

    for (CreatureTemplateContainer::const_iterator itr = ctc->begin(); itr != ctc->end(); ++itr)
    {
      uint32 id = itr->second.Entry;

      if (id == BOT_ENTRY_MIRROR_IMAGE_BM)
          continue;
      // //Blademaster disabled
      // if (botclass == BOT_CLASS_BM)
      //     continue;

      NpcBotExtras const* _botExtras = BotDataMgr::SelectNpcBotExtras(id);
      if (!_botExtras || _botExtras->bclass >= BOT_CLASS_EX_START || _botExtras->bclass == BOT_CLASS_NONE)
          continue;

      if (BotDataMgr::SelectNpcBotData(id))
          continue;

      uint8 race = _botExtras->race;

      if (CreatureLocale const* creatureLocale = sObjectMgr->GetCreatureLocale(id))
      {
          if (creatureLocale->Name.size() > localeIndex && !creatureLocale->Name[localeIndex].empty())
          {
              botlist.emplace_back(id, std::string(creatureLocale->Name[localeIndex]), race);
              continue;
          }
      }

      std::string name = itr->second.Name;
      if (name.empty())
          continue;

      botlist.emplace_back(id, std::move(name), race);
    }

    if (botlist.empty())
    {
      LOG_INFO("server.loading", "ALL npcbots have been spawned");
      return;
    }

    LOG_INFO("server.loading", "Spawning all remaining npcbots...");

    std::sort(botlist.begin(), botlist.end(), [](BotInfo const& bi1, BotInfo const& bi2) { return bi1.id < bi2.id; });
    for (BotList::const_iterator itr = botlist.begin(); itr != botlist.end(); ++itr)
    {
      uint8 race = itr->race;
      if (race >= MAX_RACES)
          race = RACE_NONE;

      std::string_view raceName;
      switch (race)
      {
        case RACE_HUMAN:        raceName = "Human";     break;
        case RACE_ORC:          raceName = "Orc";       break;
        case RACE_DWARF:        raceName = "Dwarf";     break;
        case RACE_NIGHTELF:     raceName = "Night Elf"; break;
        case RACE_UNDEAD_PLAYER:raceName = "Forsaken";  break;
        case RACE_TAUREN:       raceName = "Tauren";    break;
        case RACE_GNOME:        raceName = "Gnome";     break;
        case RACE_TROLL:        raceName = "Troll";     break;
        case RACE_BLOODELF:     raceName = "Blood Elf"; break;
        case RACE_DRAENEI:      raceName = "Draenei";   break;
        case RACE_NONE:         raceName = "No Race";   break;
        default:                raceName = "Unknown";   break;
      }
      
      // LOG_INFO("server.loading", ">> Spawning {} - {} - {}", itr->id, itr->name.c_str(), raceName);
      // handler->PSendSysMessage("%d - |cffffffff|Hcreature_entry:%d|h[%s]|h|r %s", itr->id, itr->id, itr->name.c_str(), raceName);

      Creature* creature = new Creature();
      if (!creature->Create(map->GenerateLowGuid<HighGuid::Unit>(), map, phaseMask, itr->id, 0, posX, posY, posZ, 0))
      {
        delete creature;
        LOG_INFO("server.loading", ">> Unable to spawn {} - {}", itr->id, itr->name.c_str());
        return;
      }

      NpcBotExtras const* _botExtras = BotDataMgr::SelectNpcBotExtras(itr->id);
      if (!_botExtras)
      {
          delete creature;
          LOG_INFO("server.loading", ">> No class/race data found for {} - {}", itr->id, itr->name.c_str());
          return;
      }

      uint8 bot_spec = bot_ai::SelectSpecForClass(_botExtras->bclass);
      BotDataMgr::AddNpcBotData(itr->id, bot_ai::DefaultRolesForClass(_botExtras->bclass, bot_spec), bot_spec, creature->GetCreatureTemplate()->faction);

      creature->SaveToDB(map->GetId(), (1 << map->GetSpawnMode()), phaseMask);

      uint32 db_guid = creature->GetSpawnId();
      if (!creature->LoadBotCreatureFromDB(db_guid, map))
      {
          delete creature;
          LOG_INFO("server.loading", ">> Cannot load npcbot from DB!");
          return;
      }

      sObjectMgr->AddCreatureToGrid(db_guid, sObjectMgr->GetCreatureData(db_guid));

      LOG_INFO("server.loading", ">> NpcBot successfully spawned {} - {}", itr->id, itr->name.c_str());
    }
  };

private:
  struct BotInfo
  {
    explicit BotInfo(uint32 Id, std::string&& Name, uint8 Race) : id(Id), name(std::move(Name)), race(Race) {}
    uint32 id;
    std::string name;
    uint8 race;
  };
};

void AddSchulteCore()
{
  new schulte_core();
}