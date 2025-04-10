// Add all scripts in one
#include "Creature.h"
#include "Log.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "Maps/MapMgr.h"

class schulte_core : public WorldScript
{
public:
  schulte_core() : WorldScript("schulte_core") { }
};

void AddSchulteCore()
{
  new schulte_core();
}