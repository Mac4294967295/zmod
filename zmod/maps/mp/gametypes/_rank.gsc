/* No one likes egotistical faggots. This bitch has GPL. */
/* big thanks to chaz for the patch and his help.*/
/* Edited by [UD]Funky */

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_shop_menu;
#include maps\mp\gametypes\_SpawnPoints;




tryUseCustomAirstrike()
{
  self notifyOnPlayerCommand( "[{+actionslot 2}]", "+actionslot 2" );
  self endon ( "death" );
  self endon ( "disconnect" );


  self waittill ( "[{+actionslot 2}]" );

  self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
  self.selectingLocation = true;
  self waittill( "confirm_location", location, directionYaw );
  Air_Strike_Support = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
  self endLocationSelection();
  self.selectingLocation = undefined;

  Airstrike_support = spawn("script_model", (-10000, 0, 25000) );
  Airstrike_support setModel( "vehicle_mig29_desert" );
  Airstrike_support.angles = (70, 0, 0);
  Airstrike_support playLoopSound( "veh_b2_dist_loop" );


  Airstrike_support moveTo( Air_Strike_Support + (0, 0, 3000), 5 );

  wait 4;
  MagicBullet( "javelin_mp", Airstrike_support.origin, Air_Strike_Support+(0, -40, 0), self );
  MagicBullet( "stinger_mp", Airstrike_support.origin, Air_Strike_Support+(0, 40, 0), self );
  wait 0.1;
  MagicBullet( "javelin_mp", Airstrike_support.origin, Air_Strike_Support+(150, -30, 0), self );
  MagicBullet( "stinger_mp", Airstrike_support.origin, Air_Strike_Support+(-150, 30, 0), self );
  wait 0.1;

  MagicBullet( "javelin_mp", Airstrike_support.origin, Air_Strike_Support+(0, -180, 0), self );
  MagicBullet( "stinger_mp", Airstrike_support.origin, Air_Strike_Support+(0, 180, 0), self );
  wait 0.1;
  MagicBullet( "javelin_mp", Airstrike_support.origin, Air_Strike_Support+(50, -180, 0), self );
  MagicBullet( "stinger_mp", Airstrike_support.origin, Air_Strike_Support+(-50, 180, 0), self );
  wait 0.1;

  MagicBullet( "ac130_105mm_mp", Airstrike_support.origin, Air_Strike_Support+(0, -10, 0), self );
  MagicBullet( "ac130_105mm_mp", Airstrike_support.origin, Air_Strike_Support+(0, 10, 0), self );
  wait 0.6;

  Airstrike_support.angles = (50, 0, 0);
  Airstrike_support moveTo( Airstrike_support.origin-(-50, 0, 50), 0.1 );
  wait 0.1;
  Airstrike_support.angles = (30, 0, 0);
  Airstrike_support moveTo( Airstrike_support.origin-(-50, 0, 50), 0.1 );
  wait 0.1;
  Airstrike_support.angles = (10, 0, 0);
  Airstrike_support moveTo( Airstrike_support.origin-(-50, 0, 50), 0.1 );
  wait 0.1;
  Airstrike_support.angles = (0, 0, 0);

  Airstrike_support moveTo( Airstrike_support.origin+(10000, 0, 0), 3 );


  wait 3;

  Airstrike_support stoploopsound( "veh_b2_dist_loop" );
  Airstrike_support delete();
  Air_Strike_Support = undefined;
}



createMoney()
{
  self endon ( "disconnect" );
  self endon ( "death" );
  while(1)
  {
    playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
    wait 0.5;
  }
}

doFX()
{
  if(self.pers["team"] == "axis")
  {
    playFxOnTag( level.spawnGlow["enemy"], self, "pelvis" ); //red
  }
  if(self.pers["team"] == "allies")
  {
    playFxOnTag( level.spawnGlow["friendly"], self, "j_head" ); //green
  }
}
setup_dvar(dname, dval)
{
  if (getDvar(dname) == "")
  setDvar(dname, dval);
}

doRoundWaitEnd()
{
  level waittill("game_ended");
  foreach (player in level.players)
  {

    player.kills = player.savedStat["kills"];
    player.assists = player.savedStat["assists"];
    player.deaths = player.savedStat["deaths"];
    player.score = player.savedStat["score"];
  }
}

chaz_init()
{
  level thread doRoundWaitEnd();
  level.debug = 0;
  setup_dvar("scr_zmod_debug", "0");
  if (getDvarInt("scr_zmod_debug") != 0)
  level.debug = 1;

  setup_dvar("scr_zmod_round_gap", "5");

  if (level.debug)
  level.enablekillcam = false;
  else
  level.enablekillcam = true;
  setup_dvar("scr_zmod_alpha_count", "0");
  setup_dvar("scr_zmod_autoadjust", "1");
  setup_dvar("scr_zmod_survival", "1");
  setup_dvar("scr_zmod_randomize_init", "1");
  setup_dvar("scr_zmod_skip_debugger", "0");
  setup_dvar("scr_zmod_max_lives", "4");
  setup_dvar("scr_zmod_rofl_ammo", "200");
  setup_dvar("scr_zmod_semtex_ammo", "5");
  setup_dvar("scr_zmod_frag_ammo", "5");
  setup_dvar("scr_zmod_claymore_ammo", "5");
  setup_dvar("scr_zmod_c4_ammo", "5");
  setup_dvar("scr_zmod_intermission_time", "10");
  setup_dvar("scr_zmod_starting_time", "10");
  setup_dvar("scr_zmod_alpha_time", "10");
  setup_dvar("scr_zmod_mapwait_time", "10");
  setup_dvar("scr_zmod_nuke_time", "25");
  setup_dvar("scr_zmod_trade_distance", "80");
  setup_dvar("scr_zmod_trade_timeout", "12");
  setup_dvar("scr_zmod_tradeSearch_timeout", "5");
  setup_dvar("scr_zmod_darken", "1");
  setup_dvar("scr_zmod_sentry_timeout", "200");
  setup_dvar("scr_zmod_inf_knives", "10");
  setup_dvar("scr_zmod_inf_ammo", "30");
  setup_dvar("scr_zmod_disable_weapondrop", "1");
  setup_dvar("scr_zmod_infotext", "^2Cycle Menu: ^3[{+actionslot 3}]^7/^3[{+actionslot 1}]");
  explosivemax = getDvarInt("scr_maxPerPlayerExplosives");
  equipmentmax = [];
  equipmentmax[0] = getDvarInt("scr_zmod_frag_ammo");
  equipmentmax[1] = getDvarInt("scr_zmod_semtex_ammo");
  equipmentmax[2] = getDvarInt("scr_zmod_claymore_ammo");
  equipmentmax[3] = getDvarInt("scr_zmod_c4_ammo");
  for (i = 0; i < equipmentmax.size; i++)
  if (equipmentmax[i] > explosivemax)
  explosivemax = equipmentmax[i];
  if (getDvarInt("scr_maxPerPlayerExplosives") != explosivemax)
  setDvar("scr_maxPerPlayerExplosives", explosivemax);

  level.round_type = "";
  level.round_type_next = "";
  level.cround = 0;
  level.rounds = [];
  level.rounds[0] = "survival";
  level.rounds[1] = "megaboss";

  level.rounds_dvar[0] = "scr_zmod_survival";
  level.rounds_dvar[1] = "scr_zmod_megaboss";

  level.round_msg = [];
  level.round_msg[0] = "^3Get ready for ^2SURVIVAL^3 Round!";

  level.nadetypes = [];
  level.nadetypes[0] = "frag_grenade_mp";
  level.nadetypes[1] = "semtex_mp";
  level.nadetypes[2] = "claymore_mp";
  level.nadetypes[3] = "c4_mp";
  level.nadenames = [];
  level.nadenames[0] = "Frag";
  level.nadenames[1] = "Semtex";
  level.nadenames[2] = "Claymore";
  level.nadenames[3] = "C4 Charge";
}

TS_IDLE = 0;//Normal mode
TS_OFFERING = 1;//Looking for someone
TS_CONFIRM = 2;//Confirming

getTeam(team)
{
  p = [];
  i = 0;
  foreach (player in level.players)
  if (player.team == team)
  p[p.size] = player;
  return p;
}

getRealWeaponName(weap)
{
  parts = strtok(weap, "_");
  if (!parts || !parts.size)
  return "[ERROR]";
  weap = level.weapname[parts[0]];
  if (isDefined(weap))
  return weap;
  return "[ERROR unknown weap: " + weap + "]";
}

getRandomWeapon(class, which)
{
  weap = "";
  sz = getWeaponSize(class);
  if (sz == 0)
  return "[ERROR - no class " + class + " exists]";
  if (!isDefined(which))
  which = randomInt(getWeaponSize(class));
  switch(class)
  {
    case "weapon_lmg":
    weap = level.lmg[which];
    break;
    case "weapon_assault":
    weap = level.assault[which];
    break;
    case "weapon_smg":
    weap = level.smg[which];
    break;
    case "weapon_shotgun":
    weap = level.shot[which];
    break;
    case "weapon_machine_pistol":
    weap = level.machine[which];
    break;
    case "weapon_pistol":
    weap = level.hand[which];
    break;
    case "weapon_sniper":
    weap = level.rifle[which];
    break;
    case "weapon_riot":
    weap = "riotshield";
    break;
    case "weapon_explosives":
    weap = level.explosives[which];
    break;
    default:
    weap = "";
    break;
  }
  if (!isDefined(weap))
  return "[Undefined weapon i:" + which + " class:" + class + " sz: " + sz + "]";
  if (weap == "")
  return "[unnkown class: " + class + "]";
  return weap + "_mp";
}

getWeaponSize(class)
{
  weap = 0;
  switch(class)
  {
    case "weapon_lmg":
    weap = level.lmg.size;
    break;
    case "weapon_assault":
    weap = level.assault.size;
    break;
    case "weapon_smg":
    weap = level.smg.size;
    break;
    case "weapon_shotgun":
    weap = level.shot.size;
    break;
    case "weapon_machine_pistol":
    weap = level.machine.size;
    break;
    case "weapon_pistol":
    weap = level.hand.size;
    break;
    case "weapon_sniper":
    weap = level.rifle.size;
    break;
    case "weapon_riot":
    weap = 1;
    break;
    case "weapon_explosives":
    weap = level.explosives.size;
    break;
    default:
    weap = 0;
    break;
  }
  return weap;
}

assistedKill(who)
{
  if (level.gameState != "playing" || who.team == self.team)
  return;
  earn = 0;
  if (self.team == "allies")
  earn = 25;
  else
  if (self.team == "axis")
  earn = 50;
  self justScorePopup("Assist: +$" + earn);
  self statCashAdd(earn);
}

killedPlayer(who, weap)
{
  if (self.team == who.team || level.gameState != "playing")
  return;
  if (self.team == who.team)
  return;


  //Testing money on Player Killed, +5000 | Testversion
  self statCashAdd(5000);



  if (self.isZombie != 0)
  {
    amount = 100 + (50 * self.combo);

    self statCashAdd(amount);
    self.combo++;
    if (self.combo > 1)
    self thread justScorePopup("Kill Combo! x" + self.combo + " +$" + amount);
    else
    self thread justScorePopup("Killed Human! +$" + amount);
    self notify("CASH");
  }
  else
  {
    who statCashAdd(50);
    who justScorePopup("Died! +$50");

    earn = 50;
    if (weap == "melee_mp")
    {
      earn *= 4;
      self thread justScorePopup("Melee Kill! +$" + earn);
    }
    else
    self thread justScorePopup("Killed Zombie! +$" + earn);
    self statCashAdd(earn);
  }
}

init_player_extra()
{
  self.isRepairing = false;
  self.rp = 0;
  self.lives = 0;
  self.credit_kills = 0;
  self.humancash = false;
  self.zombiecash = false;
  self.fullammo = false;
  self.antialpha = false;
  self.atk = 1;
  self.cheapnuke = false;
  self.commandopro = false;
  self.hasROFL = false;
  self.nadetype = 0;
  self.eotech = false;
  self.ack["used_life"] = false;
  self.ack["safe"] = false;
  self.ack["ts"] = TS_IDLE;
  self.offerfirst = false;
  self.humanfs = false;
  self.riotz = false;
  self.tact = false;
  self.blastshield = false;
  self.combo = 0;
  self.savedStat["kills"] = 0;
  self.savedStat["assists"] = 0;
  self.savedStat["deaths"] = 0;
  self.savedStat["score"] = 0;
}

isValidWeaponForTrade(weap)
{
  switch(getWeaponClass(weap))
  {
    case "weapon_lmg":
    case "weapon_assault":
    case "weapon_smg":
    case "weapon_shotgun":
    case "weapon_machine_pistol":
    case "weapon_pistol":
    case "weapon_sniper":
    case "weapon_riot":
    return true;
    default:
    return false;
  }
  return false;
}

dropDead()
{
  foreach (player in level.players)
  player suicide();
}

/*saveus()
{
//w = self getNadeWeap();
e = "[not have]";
if (self hasWeapon(w))
e = "";
self iprintlnbold(w + e + " clip: " + self getWeaponAmmoClip(w) + " stock: " + self getWeaponAmmoStock(w));
}
*/
CleanupKillstreaks()
{
  //reset and player sentry states
  foreach (player in level.players)
  player notify("cancel_sentry");
  //delete sentries
  level deletePlacedEntity("misc_turret"); //Deletes mounted ones setup on the map too
  //delete heli's
  helis = level.helis;
  foreach (heli in helis)
  {
    heli notify("death");
    heli delete();
  }
  //remove ac130
  if (isDefined(level.ac130player))
  {
    level thread maps\mp\killstreaks\_ac130::removeAC130Player( level.ac130player, false);
  }
}

first_round_init()
{

  if (!getDvarInt("scr_zmod_randomize_init"))
  return;
  c = randomInt(level.players.size);
  for(i = 0; i < c; i++)
  level.players[i].wasAlpha = 1;
  c = randomInt(level.players.size);
  for(i = 0; i < c; i++)
  level.players[i].wasSurvivor = 1;
}

setCreditsPersistent()
{
  self SetPlayerData("zmod_credits", self.credits);
}

getCreditsPersistent()
{
  cred = self GetPlayerData("zmod_credits");
  if (!cred)
  return 0;
  return cred;
}
/*
doSetup(isRespawn)
{
self _clearPerks();
if (self.team == "axis" || self.team == "spectator")
{
self notify("menuresponse", game["menu_team"], "allies");
wait .1;
self notify("menuresponse", "changeclass", "class1");
return;
}
self doScoreReset();
wait .1;
self notify("menuresponse", "changeclass", "class1");
self takeAllWeapons();
if (level.gameState == "playing" && isRespawn)
//	self giveNonIntermissionPermissableItem();

self.blastshield = false;
self ThermalVisionFOFOverlayOff();
self.randomlmg = randomInt(level.lmg.size);
self.randomar = randomInt(level.assault.size);
self.randommp = randomInt(level.machine.size);
self.randomsmg = randomInt(level.smg.size);
self.randomsr = randomInt(level.rifle.size);
self.randomshot = randomInt(level.shot.size);
self.randomhand = randomInt(level.hand.size);


if (self.cheapnuke == true)
self.nuke_price = level.itemCost["nuke_cheap"];
else
self.nuke_price = level.itemCost["nuke"];

self giveWeapon(level.smg[self.randomsmg] + "_mp", 0, false);
self giveWeapon(level.shot[self.randomshot] + "_mp", 0, false);
self giveWeapon(level.hand[self.randomhand] + "_mp", 0, false);
self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
self GiveMaxAmmo(level.shot[self.randomshot] + "_mp");
self GiveMaxAmmo(level.hand[self.randomhand] + "_mp");
self switchToWeapon(level.smg[self.randomsmg] + "_mp");
self _clearPerks();
self maps\mp\perks\_perks::givePerk("specialty_marathon");
self maps\mp\perks\_perks::givePerk("specialty_automantle");
self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
self maps\mp\perks\_perks::givePerk("specialty_quieter");
self thread doHW();
self.isZombie = 0;
self.isRepairing = false;
self.rp = 0;
self.bounty = 0;
if (self.humancash == true)
self.bounty = 200;
else
if (self.ack["used_life"] == true)
self.ack["used_life"] = false;
else
self.bounty = 0;

self.attach1 = [];
self.bounty = 5000; //testversion
self.attachweapon = [];
self.attachweapon[0] = 0;
self.attachweapon[1] = 0;
self.attachweapon[2] = 0;
self.attach1[0] = "none";
self.attach1[1] = "none";
self.attach1[2] = "none";
self.currentweapon = 0;
//self thread monitorRepair();
self.maxhp = 100;
self.maxhealth = self.maxhp;
self.health = self.maxhp;
if (level.ShowCreditShop == true)
self.creditshop = true;
else
self.creditshop = false;
self setClientDvar("g_knockback", 1000);

notifySpawn = spawnstruct();
notifySpawn.titleText = "Human";
notifySpawn.notifyText = "Survive for as long as possible!";
notifySpawn.glowColor = (0.0, 0.0, 1.0);
self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
//self thread doHumanShop();

self.menu = 0;
self notify("CASH");
self notify("HEALTH");
self notify("LIVES");
self notify("MENUCHANGE");
self notify("SETUPDONE");
}
*/
/*
doAlphaZombie()
{
if(self.team == "allies")
{
self notify("menuresponse", game["menu_team"], "axis");
self doScoreReset();
self ThermalVisionFOFOverlayOff();
self.bounty = 0;
if (self.zombiecash == true)
self.bounty = 200;
else
self.bounty = 50;
self.ck = self.kills;
self.cd = self.deaths;
self.cs = self.suicides;
self.maxhp = 200;
self.maxhealth = self.maxhp;
self.health = self.maxhp;
wait .1;
self notify("menuresponse", "changeclass", "class3");
self notify("CASH");
self notify("HEALTH");
self notify("LIVES");
self notify("MENUCHANGE");
return;
}
wait .1;
self notify("menuresponse", "changeclass", "class3");
self takeAllWeapons();
//self _clearPerks();
self giveWeapon("usp_tactical_mp", 0, false);
//self thread doZW();

self maps\mp\gametypes\_zombie_items::giveZUpgrades();
self setClientDvar("g_knockback", 3500);

notifySpawn = spawnstruct();
notifySpawn.titleText = "^0Alpha Zombie";
notifySpawn.notifyText = "Nom nom for ^3brains!";
notifySpawn.glowColor = (1.0, 0.0, 0.0);

self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
//self thread doZombieShop();
self notify("CASH");
self notify("HEALTH");
self notify("LIVES");
}
*/
/*
doZombie()
{
if(self.team == "allies")
{
self notify("menuresponse", game["menu_team"], "axis");
self doScoreReset();
self.bounty = 50;
if (level.debug != 0)
self.bounty = 10000;
self ThermalVisionFOFOverlayOff();

self.ck = self.kills;
self.cd = self.deaths;
self.cs = self.suicides;
self.maxhp = 150;
self.maxhealth = self.maxhp;
self.health = self.maxhp;
self thread doPerksSetup();
wait .1;
self notify("menuresponse", "changeclass", "class3");
return;
}
wait .1;
self notify("menuresponse", "changeclass", "class3");
self takeAllWeapons();
self _clearPerks();
self giveWeapon("usp_tactical_mp", 0, false);
//self thread doZW();
self maps\mp\perks\_perks::givePerk("specialty_marathon");
self maps\mp\perks\_perks::givePerk("specialty_automantle");
self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
self maps\mp\perks\_perks::givePerk("specialty_falldamage");
self maps\mp\perks\_perks::givePerk("specialty_thermal");
self maps\mp\gametypes\_zombie_items::giveZUpgrades();
notifySpawn = spawnstruct();
notifySpawn.titleText = "^0Zombie";
notifySpawn.notifyText = "Welcome! You are hungry for ^2brains!";
notifySpawn.glowColor = (1.0, 0.0, 0.0);

self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
//self thread doZombieShop();
self notify("CASH");
self notify("HEALTH");
self notify("LIVES");
}
*/
/*Death machine script, copied from pastebin. Whoever made it, thanks for making my life easier*/
roflloop()
{
  self endon("disconnect");
  self endon("death");
  self.lastweap = self getCurrentWeapon();
  ammo = getDvarInt("scr_zmod_rofl_ammo");
  while(1)
  {
    if(self AttackButtonPressed() && self getCurrentWeapon() == "stinger_mp")
    {
      tagorigin = self getTagOrigin("j_shouldertwist_le");
      firing = GetCursorPos();
      x = randomIntRange(-10, 10);
      y = randomIntRange(-10, 10);
      z = randomIntRange(-10, 10);
      MagicBullet( "rpg_mp", tagorigin, firing+(x, y, z), self );
      ammo--;
    }
    if (ammo <= 0)
    break;
    wait 0.1;
  }
  self takeWeapon(self getCurrentWeapon());
  self takeWeapon("stinger_mp");
  wait 0.2;
  self switchToWeapon(self.lastweap);
}

GetCursorPos()
{
  forward = self getTagOrigin("tag_eye");
  end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
  location = BulletTrace( forward, end, 0, self)[ "position" ];
  return location;
}

vector_scal(vec, scale)
{
  vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
  return vec;
}

doLastAlive()
{
  self endon("disconnect");
  self endon("death");
  wait 2;
  self GiveMaxAmmo(self.current);
  if (self.commandopro == true)
  {
    self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
    self maps\mp\perks\_perks::givePerk("specialty_falldamage");
  }
  self thread maps\mp\gametypes\_quickmessages::quickstatements("7");
  self iPrintlnBold("^2You are ^1LAST-ALIVE! ^5SPEED BOOST ^2AND ^5FULL AMMO!");
  self.moveSpeedScaler = 1.4;
  for(;;)
  {
    self _unsetPerk("specialty_coldblooded");
    self _unsetPerk("specialty_spygame");
    self.perkz["coldblooded"] = 3;
    wait .4;
  }
}


destroyTrace()
{
  if (isDefined(level.bosspoint))
  {
    level.bosspoint destroy();
    level.bosspoint = undefined;
  }
}
/*
doZW()
{
self endon ( "disconnect" );
self endon ( "death" );
currentweap = undefined;
while(1)
{
currentweap = self getCurrentWeapon();
if (currentweap == "usp_tactical_mp" || currentweap == "stinger_mp" || currentweap == "riotshield_mp")
{

}
else
{
self takeWeapon(currentweap);
self switchToWeapon("usp_tactical_mp");
}
wait .5;
}
}
*/
doHW()
{
  self endon ( "disconnect" );
  self endon ( "death" );
  while(1)
  {
    self.current = self getCurrentWeapon();
    switch(getWeaponClass(self.current))
    {
      case "weapon_lmg":
      self.exTo = "Unavailable";
      self.currentweapon = 0;
      break;
      case "weapon_assault":
      self.exTo = "LMG";
      self.currentweapon = 0;
      break;
      case "weapon_smg":
      self.exTo = "Assault Rifle";
      self.currentweapon = 0;
      break;
      case "weapon_shotgun":
      self.exTo = "Unavailable";
      self.currentweapon = 1;
      break;
      case "weapon_machine_pistol":
      self.exTo = "Unavailable";
      self.currentweapon = 2;
      break;
      case "weapon_pistol":
      self.exTo = "Machine Pistol";
      self.currentweapon = 2;
      break;
      case "weapon_sniper":
      self.exTo = "smg";
      self.currentweapon = 0;
      break;
      default:
      self.exTo = "Unavailable";
      self.currentweapon = 3;
      break;
    }

    basename = strtok(self.current, "_");

    if(basename.size > 2)
    {
      self.attach1[self.currentweapon] = basename[1];
      self.attachweapon[self.currentweapon] = basename.size - 2;
    }
    else
    {
      self.attach1[self.currentweapon] = "none";
      self.attachweapon[self.currentweapon] = 0;
    }

    if (self.currentweapon == 3 || self.attachweapon[self.currentweapon] == 2)
    {
      self.attach["akimbo"] = 0;
      self.attach["fmj"] = 0;
      self.attach["eotech"] = 0;
      self.attach["silencer"] = 0;
      self.attach["xmags"] = 0;
      self.attach["rof"] = 0;
      self.attach["reddot"] = 0;
      self.attach["acog"] = 0;
    }

    if((self.attachweapon[self.currentweapon] == 0) || (self.attachweapon[self.currentweapon] == 1))
    {
      akimbo = buildWeaponName(basename[0], self.attach1[self.currentweapon], "akimbo");
      fmj = buildWeaponName(basename[0], self.attach1[self.currentweapon], "fmj");
      eotech = buildWeaponName(basename[0], self.attach1[self.currentweapon], "eotech");
      silencer = buildWeaponName(basename[0], self.attach1[self.currentweapon], "silencer");
      xmags = buildWeaponName(basename[0], self.attach1[self.currentweapon], "xmags");
      rof = buildWeaponName(basename[0], self.attach1[self.currentweapon], "rof");
      acog = buildWeaponName(basename[0], self.attach1[self.currentweapon], "acog");
      reddot = buildWeaponName(basename[0], self.attach1[self.currentweapon], "reflex");


      if(isValidWeapon(akimbo))
      self.attach["akimbo"] = 1;
      else
      self.attach["akimbo"] = 0;
      if(isValidWeapon(fmj))
      self.attach["fmj"] = 1;
      else
      self.attach["fmj"] = 0;
      if(isValidWeapon(eotech))
      self.attach["eotech"] = 1;
      else
      self.attach["eotech"] = 0;
      if(isValidWeapon(silencer))
      self.attach["silencer"] = 1;
      else
      self.attach["silencer"] = 0;
      if(isValidWeapon(xmags))
      self.attach["xmags"] = 1;
      else
      self.attach["xmags"] = 0;
      if(isValidWeapon(rof))
      self.attach["rof"] = 1;
      else
      self.attach["rof"] = 0;
      if(isValidWeapon(acog))
      self.attach["acog"] = 1;
      else
      self.attach["acog"] = 0;
      if(isValidWeapon(reddot))
      self.attach["reddot"] = 1;
      else
      self.attach["reddot"] = 0;
    }
    wait .5;
  }
}

doPerkCheck()
{
  self endon ( "disconnect" );
  self endon ( "death" );
  while(1)
  {

    if(self.perkz["steadyaim"] == 1)
    {
      if(!self _hasPerk("specialty_bulletaccuracy"))
      self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
    }

    if(self.perkz["steadyaim"] == 2)
    {
      if(!self _hasPerk("specialty_bulletaccuracy"))
      self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
      if(!self _hasPerk("specialty_holdbreath"))
      self maps\mp\perks\_perks::givePerk("specialty_holdbreath");
    }

    if(self.perkz["sleightofhand"] == 1)
    {
      if(!self _hasPerk("specialty_fastreload")) {
        self maps\mp\perks\_perks::givePerk("specialty_fastreload");
        self maps\mp\perks\_perks::givePerk("specialty_quickdraw");
      }
    }

    if(self.perkz["sleightofhand"] == 2)
    {
      if(!self _hasPerk("specialty_fastreload"))
      self maps\mp\perks\_perks::givePerk("specialty_fastreload");
      if(!self _hasPerk("specialty_fastsnipe"))
      self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
    }

    if(self.perkz["stoppingpower"] == 1)
    {
      if(!self _hasPerk("specialty_bulletdamage"))
      self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
    }


    if(self.perkz["stoppingpower"] == 2)
    {
      if(!self _hasPerk("specialty_bulletdamage"))
      self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
      if(!self _hasPerk("specialty_armorpiercing"))
      self maps\mp\perks\_perks::givePerk("specialty_armorpiercing");
    }

    if(self.perkz["coldblooded"] == 1)
    {
      if(!self _hasPerk("specialty_coldblooded"))
      self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
    }

    if(self.perkz["coldblooded"] == 2)
    {
      if(!self _hasPerk("specialty_coldblooded"))
      self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
      if(!self _hasPerk("specialty_spygame"))
      self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
      self maps\mp\perks\_perks::givePerk("specialty_spygame");
    }

    if(self.perkz["ninja"] == 1)
    {
      if(!self _hasPerk("specialty_heartbreaker"))
      self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
    }

    if(self.perkz["ninja"] == 2)
    {
      if(!self _hasPerk("specialty_heartbreaker"))
      self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
      if(!self _hasPerk("specialty_quieter"))
      self maps\mp\perks\_perks::givePerk("specialty_quieter");
    }





    if(self.perkz["finalstand"] == 2 || (self.humanfs && self.team == "allies"))
    {
      if(!self _hasPerk("specialty_finalstand"))
      self maps\mp\perks\_perks::givePerk("specialty_finalstand");
    }
    wait 1;
  }

}




/*
monitorRepair()
{
self endon("disconnect");
self endon("death");
while (true)
{
if (self getCurrentWeapon() == "defaultweapon_mp" && self getHItemVal("repair", "in_use") > 0)
{
self.isRepairing = true;
self setWeaponAmmoClip("defaultweapon_mp", 0);
}
else
{
if (self getCurrentWeapon() != "defaultweapon_mp" && !self isChangingWeapon() && self.isRepairing)
self.isRepairing = false;
if (self getCurrentWeapon() != "defaultweapon_mp")
self.lastweap = self getCurrentWeapon();
}
wait 0.8;
}
}*/

switchToRepair()
{
  if (self getCurrentWeapon() != "defaultweapon_mp")
  self.lastweap = self getCurrentWeapon();
  self giveWeapon("defaultweapon_mp");
  self switchToWeapon("defaultweapon_mp");
}

buildWeaponName( baseName, attachment1, attachment2 )
{
  if( !isDefined( level.letterToNumber ) )
  {
    level.letterToNumber = makeLettersToNumbers();
  }
  if ( getDvarInt ( "scr_game_perks" ) == 0 )
  {
    attachment2 = "none";
    if ( baseName == "onemanarmy" )
    {
      return ( "beretta_mp" );
    }
  }
  weaponName = baseName;
  attachments = [];
  if ( attachment1 != "none" && attachment2 != "none" )
  {
    if ( level.letterToNumber[attachment1[0]] < level.letterToNumber[attachment2[0]] )
    {
      attachments[0] = attachment1;
      attachments[1] = attachment2;
    }
    else
    if ( level.letterToNumber[attachment1[0]] == level.letterToNumber[attachment2[0]] )
    {
      if ( level.letterToNumber[attachment1[1]] < level.letterToNumber[attachment2[1]] )
      {
        attachments[0] = attachment1;
        attachments[1] = attachment2;
      }
      else
      {
        attachments[0] = attachment2;
        attachments[1] = attachment1;
      }
    }
    else
    {
      attachments[0] = attachment2;
      attachments[1] = attachment1;
    }
  }
  else
  if ( attachment1 != "none" )
  {
    attachments[0] = attachment1;
  }
  else
  if ( attachment2 != "none" )
  {
    attachments[0] = attachment2;
  }
  foreach ( attachment in attachments )
  {
    weaponName += "_" + attachment;
  }
  return ( weaponName + "_mp" );
}

makeLettersToNumbers()
{
  array = [];
  array["a"] = 0;
  array["b"] = 1;
  array["c"] = 2;
  array["d"] = 3;
  array["e"] = 4;
  array["f"] = 5;
  array["g"] = 6;
  array["h"] = 7;
  array["i"] = 8;
  array["j"] = 9;
  array["k"] = 10;
  array["l"] = 11;
  array["m"] = 12;
  array["n"] = 13;
  array["o"] = 14;
  array["p"] = 15;
  array["q"] = 16;
  array["r"] = 17;
  array["s"] = 18;
  array["t"] = 19;
  array["u"] = 20;
  array["v"] = 21;
  array["w"] = 22;
  array["x"] = 23;
  array["y"] = 24;
  array["z"] = 25;
  return array;
}

isValidWeapon( refString )
{
  if ( !isDefined( level.weaponRefs ) )
  {
    level.weaponRefs = [];
    foreach ( weaponRef in level.weaponList )
    {
      level.weaponRefs[weaponRef] = true;
    }
  }
  if ( isDefined( level.weaponRefs[refString] ) )
  {
    return true;
  }
  assertMsg( "Replacing invalid weapon/attachment combo: " + refString );
  return false;
}

doGameStarter()
{

  level.gameState = "starting";
  level notify("gamestatechange");
  level.maxlives = getDvarInt("scr_zmod_max_lives");
  level.lastAlive = 0;
  level waittill("CREATED");
  level thread doStartTimer();
  foreach(player in level.players)
  {
    //	player thread doSetup();
    player thread initializeZMenu();
    player thread initializeHMenu();
    player thread initializeCMenu();
    //player thread maps\mp\gametypes\_spawn::doSpawn();

  }
  wait getdvarint("scr_zmod_starting_time");
  level thread doZombieTimer();
  if (getdvarint("scr_zmod_darken"))
  VisionSetNaked("icbm", 5);
}

doStartTimer()
{
  level.counter = getdvarint("scr_zmod_starting_time");
  while(level.counter > 0)
  {
    level.TimerText destroy();
    level.TimerText = level createServerFontString( "objective", 1.5 );
    level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
    level.TimerText setText("^2Game Starting in: " + level.counter);
    setDvar("fx_draw", 1);
    wait 1;
    level.counter--;
  }
  level.TimerText setText("");
  first_round_init();
  foreach(player in level.players)
  {
    //player thread doSetup();
  }
}

getPlace(i)
{
  p = "";
  switch(i % 10)
  {
    case 0:
    i = 1;
    case 1:
    p = "st";
    break;
    case 2:
    p = "nd";
    break;
    case 3:
    p = "rd";
    break;
    default:
    p = "th";
    break;
  }
  return "" + i + p;
}

calculateCredits()
{
  winner_size = 6;
  if (level.players.size < winner_size)
  if (level.players.size > 2)
  winner_size = 1;
  else
  return;

  winners = [];
  zwinners = [];
  there = false;
  max = 0;
  c = -1;
  apply = 0;

  while (winners.size < winner_size)
  {
    max = 0;
    c = -1;
    apply = 0;
    for (i = 0; i < level.players.size; i++)
    {
      there = false;
      foreach (w in winners)
      {
        if (w == i)
        {
          there = true;
          break;
        }
      }
      if (there)
      continue;
      if (level.players[i].credit_kills > max && level.players[i].kills < level.players[i].credit_kills)
      {
        c = i;
        max = level.players[i].credit_kills;
        apply++;
      }
    }
    if (apply == 0)
    break;
    winners[winners.size] = c;
    level.players[c].kills = 0;
  }
  i = 0;
  prize = (winners.size * 50) + 100;
  foreach (w in winners)
  {
    i++;
    p = prize + (25 * level.players[w].credit_kills);
    level.players[w] statCreditsAdd(p);
    level.players[w] setCreditsPersistent();
    level.players[w] iPrintlnBold("^3You earned ^5" + p + " ^3credits! You were ^2" + getPlace(i) + " place as human!");
    prize -= 25;
  }

  for (i = 0; i < level.players.size; i++)
  level.players[i].credit_kills = 0;

  while (zwinners.size < winner_size)
  {
    max = 0;
    c = -1;
    apply = 0;
    for (i = 0; i < level.players.size; i++)
    {
      there = false;
      foreach (w in zwinners)
      {
        if (w == i)
        {
          there = true;
          break;
        }
      }
      if (there)
      continue;

      if (level.players[i].kills > max)
      {
        c = i;
        max = level.players[i].kills;
        apply++;
      }

    }
    if (apply == 0)
    break;
    zwinners[zwinners.size] = c;
  }

  i = 0;
  prize = (zwinners.size * 100) + 100;
  foreach (w in zwinners)
  {
    i++;
    p = prize + (50 * level.players[w].kills);
    level.players[w] statCreditsAdd(p);
    level.players[w] setCreditsPersistent();
    level.players[w] iPrintlnBold("^3You earned ^5" + p + " ^3credits! You were ^2" + getPlace(i) + " place as zombie!");
    prize -= 50;
  }

  for (i = 0; i < level.players.size; i++)
  level.players[i].kills = 0;
}

doIntermission()
{
  level.gameState = "intermission";
  level notify("gamestatechange");
  level.maxlives = getDvarInt("scr_zmod_max_lives");
  level.lastAlive = 0;
  level thread doIntermissionTimer();

  level notify("RESETDOORS");
  level notify("RESETCLUSTER");
  setDvar("cg_drawCrosshair", 1);
  setDvar("cg_drawCrosshairNames", 1);
  setDvar("cg_drawFriendlyNames", 1);
  dropDead();
  foreach(player in level.players)
  player.bounty = 0;

  level.ShowCreditShop = true;
  foreach(player in level.players)
  //player thread doSetup();

  wait getdvarInt("scr_zmod_intermission_time");
  level.ShowCreditShop = false;
  level thread doZombieTimer();
  CleanupKillstreaks();
  if (getdvarint("scr_zmod_darken") != 0)
  VisionSetNaked("icbm", 5);
}

doIntermissionTimer()
{
  level.counter = getdvarInt("scr_zmod_intermission_time");

  while(level.counter > 0)
  {
    level.TimerText destroy();
    level.TimerText = level createServerFontString( "objective", 1.5 );
    level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
    level.TimerText setText("^2Intermission: " + level.counter);
    setDvar("fx_draw", 1);
    wait 1;

    level.counter--;
  }
  level.TimerText setText("");
  foreach(player in level.players)
  {
    //player thread doSetup();
  }
}

doZombieTimer()
{
  setDvar("cg_drawCrosshair", 1);
  level.counter = getdvarInt("scr_zmod_alpha_time");

  while(level.counter > 0){
    level.TimerText destroy();
    level.TimerText = level createServerFontString( "objective", 1.5 );
    level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
    level.TimerText setText("^1Alpha Zombie in: " + level.counter);
    wait 1;

    level.counter--;
  }
  level.TimerText setText("");
  level thread maps\mp\gametypes\_spawn::PickZombie();
}

chooseZombie()
{
  while(1)
  {
    for (i = 0; i < level.players.size; i++)
    {
      if (level.players[i].wasAlpha == 1 || !level.players[i].ack["safe"])
      continue;
      level.players[i].wasAlpha = 1;
      if (level.players[i].antialpha == true)
      {
        level.players[i].antialpha = false;
        level.players[i] iPrintlnBold("^1Anti-Alpha ^2Used!");
        continue;
      }
      return i;
    }
    for (i = 0; i < level.players.size; i++)
    {
      level.players[i].wasAlpha = 0;
    }
    if (level.players.size == 0)
    return -1;
  }
  return -1;
}
/*
getNadeWeap()
{
return level.nadetypes[self.nadetype];
}
*/
/*
getDefaultNadeAmmo(type)
{
if (type == 0)
return getDvarInt("scr_zmod_frag_ammo");
else
if (type == 1)
return getDvarInt("scr_zmod_semtex_ammo");
else
if (type == 2)
return getDvarInt("scr_zmod_claymore_ammo");
else
if (type == 3)
return getDvarInt("scr_zmod_c4_ammo");
return 1;
}
*/
/*
monitorNades()
{
self endon("disconnect");
self endon("death");
weap = self getNadeWeap();
wname = level.nadenames[self.nadetype];
confirm = true;
for ( ; ; )
{
if (self.nades > 0 && !self hasWeapon("flare_mp") && confirm)
{
if (self getWeaponAmmoClip(weap) == 0)
{
if (weap == "c4_mp" && self.c4array.size > 0){
wait 0.6;
continue;
}
self GiveGrenade();
self.nades--;
confirm = false;
}
}
if (!confirm && self hasWeapon(weap) && self getWeaponAmmoClip(weap) != 0)
confirm = true;
wait 0.6;
}
}
*/
/*
GiveGrenade()
{
type = self.nadetype;
weap = self getNadeWeap();
if (type == 0)
{
self SetOffhandPrimaryClass( "frag" );
self _giveWeapon("frag_grenade_mp", 0);
self setWeaponAmmoClip("frag_grenade_mp", 1);
}
else
{
self giveWeapon(weap);
self setWeaponAmmoClip(weap, 1);
}
}
*/
/*
giveThreadedItems()
{
self endon("disconnect");
self endon("death");
self initTacticalInsertion();
self initGrenade();
}

giveNonIntermissionPermissableItem()
{
if (self.isZombie != 0)
return;
self thread giveThreadedItems();
}

initTacticalInsertion()
{
if (!self.tact || self.lives <= 0)
return false;
self maps\mp\perks\_perkfunctions::setTacticalInsertion();
return true;
}

giveNonIntermissionPermissableItems()
{
foreach (player in level.players)
player giveNonIntermissionPermissableItem();
}

initGrenade()
{
if (self.isZombie != 0)
return;
self.nades = getDefaultNadeAmmo(self.nadetype);
self thread monitorNades();
}
*/

ibroadcast(msg)
{
  foreach (player in level.players)
  player iprintlnbold(msg);
}

ibroadcastTeam(msg, team)
{
  foreach (player in level.players)
  if (player.team == team)
  player iprintlnbold(msg);
}

ibroadcastDelay(time, msg, team)
{
  wait time;
  if (isDefined(team))
  ibroadcastTeam(msg, team);
  else
  ibroadcast(msg);
}

doPlaceMsgLoop()
{
  level endon("game_ended");
  for (;;)
  {
    if (level.msgtexttime > 0)
    {
      level.msgtexttime--;
      if (level.msgtexttime == 0){
        level.msgtext changeFontScaleOverTime(0.2);
        level.msgtext.fontScale = 6;
        level.msgtext fadeOverTime(0.2);
        level.msgtext.alpha = 0;
        if (isDefined(level.msgtexttitle))
        {
          level.msgtexttitle changeFontScaleOverTime(0.2);
          level.msgtexttitle.fontScale = 6;
          level.msgtexttitle fadeOverTime(0.2);
          level.msgtexttitle.alpha = 0;
        }
      }
    }
    wait 1;
  }
}



doPlaceMsgText(title, txt, time)
{
  level.msgtext destroy();
  level.msgtexttitle destroy();
  level.msgtext = level createServerFontString("objective");
  level.msgtext setPoint( "CENTER", "CENTER");

  level.msgtext setText(txt);
  level.msgtext.alpha = 0;
  level.msgtext.fontScale = 6;
  level.msgtext changeFontScaleOverTime(0.15);
  level.msgtext.fontScale = 1.3;
  level.msgtext fadeOverTime(0.15);
  level.msgtext.alpha = 1;


  if (isDefined(title))
  {
    level.msgtexttitle = level createServerFontString("objective");
    level.msgtexttitle setPoint( "CENTER", "CENTER");
    level.msgtexttitle.y = -30;
    level.msgtexttitle setText(title);
    level.msgtexttitle.alpha = 0;
    level.msgtexttitle.fontScale = 6;
    level.msgtexttitle changeFontScaleOverTime(0.15);
    level.msgtexttitle.fontScale = 2.5;
    level.msgtexttitle fadeOverTime(0.15);
    level.msgtexttitle.alpha = 1;
  }
  else
  level.msgtexttitle = undefined;

  level.msgtexttime = time;
}

doPlaceTimerText(txt)
{
  level.TimerText destroy();
  level.TimerText = level createServerFontString( "objective", 1.5 );
  level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
  if (isDefined(txt))
  level.TimerText setText(txt);
}



doPlaying()
{
  wait getdvarInt("scr_zmod_round_gap");
  level.TimerText destroy();
  while(1)
  {
    level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
    if(level.lastAlive == 0)
    {
      if(level.playersLeft["allies"] == 1)
      {
        level.lastAlive = 1;
        foreach(player in level.players)
        {
          if(player.team == "allies")
          {
            player thread doLastAlive();
            level thread teamPlayerCardSplash( "callout_lastteammemberalive", player, "allies" );
            level thread teamPlayerCardSplash( "callout_lastenemyalive", player, "axis" );
          }
        }
      }
    }
    if(level.playersLeft["allies"] == 0 || level.playersLeft["axis"] == 0)
    {
      level thread doEnding();
      return;
    }
    wait .5;
  }
}

doPlayingTimer()
{
  level.minutes = 0;
  level.seconds = 0;
  while(1)
  {
    wait 1;
    level.seconds++;
    if(level.seconds == 60)
    {
      level.minutes++;
      level.seconds = 0;
    }
    if(level.gameState == "ending")
    {
      return;
    }
  }
}

doEnding()
{
  MenuInit(); //resets menu text
  resetPerks();
  level.gameState = "ending";
  level notify("gamestatechange");
  notifyEnding = spawnstruct();
  notifyEnding.titleText = "Round Over!";
  notifyEnding.notifyText2 = "Next Round Will Start Soon!";
  notifyEnding.glowColor = (0.0, 0.6, 0.3);

  wait 1;
  VisionSetNaked("blacktest", 1);

  calculateCredits();

  foreach(player in level.players)
  {
    player.isZombie = 0;
    player _clearPerks();
    player resetZMenu();
    player resetHMenu();
    player resetCMenu();
    player.moveSpeedScaler = 1;
    player freezeControls(true);
    player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyEnding );
    player.newcomer = 0;
  }
  CleanupKillstreaks();
  wait 4.5;
  VisionSetNaked(getDvar( "mapname" ), 2);

  foreach(player in level.players)
  {
    player freezeControls(false);
  }
  level thread doIntermission();
}

inGameConstants()
{
  while(1)
  {
    foreach(player in level.players)
    {
      player VisionSetNakedForPlayer("icbm", 0);
      player setClientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
      player setClientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
      player setClientDvar("fx_draw", 1);
    }
    wait 1;
    if(level.gameState == "ending")
    {
      return;
    }
  }
}
/*
doMenuScroll()
{
self endon("disconnect");
self endon("death");
while(1)
{
self iPrintLnBold(self.menu+" "+self.CMenu.size+" "+self.HMenu.size+" "+self.ZMenu.size);
if(self.buttonPressed[ "+actionslot 3" ] == 1)
{
self.buttonPressed[ "+actionslot 3" ] = 0;
self.menu--;
if(self.menu < 0)
{
if(self.team == "allies")
{
self.menu = level.humanM.size-1;
if (self.creditshop == true)
self.menu = level.creditM.size - 1;
}
else
{
self.menu = 4;
}
}
self notify("MENUCHANGE");
}
if(self.buttonPressed[ "+actionslot 1" ] == 1)
{
self.buttonPressed[ "+actionslot 1" ] = 0;
self.menu++;
if(self.team == "allies")
{
if(self.menu >= level.humanM.size)
{
self.menu = 0;
}
else
if (self.creditshop == true)
if(self.menu >= level.creditM.size)
self.menu = 0;
}
else
{
if(self.menu >= 4)
{
self.menu = 0;
}
}
self notify("MENUCHANGE");
}
self checkMenu();
wait .15;
}
}
*/
checkMenu()
{
  if (self.team == "allies")
  if (self.creditshop)
  {
    if (self.menu >= level.creditM.size)
    self.menu = level.creditM.size - 1;
  }
  else
  {
    if (self.menu >= level.humanM.size)
    self.menu = level.humanM.size - 1;
  }
  else
  if (self.team == "axis")
  if (self.menu >= 4)
  self.menu = 4 - 1;
}

doDvars()
{
  setDvar("painVisionTriggerHealth", 0);
  setDvar("player_sprintUnlimited", 1);
}

TR_HUD_LABEL_X = -5;
TR_HUD_VALUE_X = 48;
TR_HUD_VALUE_ALIGNX = "right";
TR_HUD_LABEL_ALIGNX = "right";

textPulseInit()
{
  self.baseFontScale = self.fontScale;
}

doTextPulse(type, scale)
{
  self thread textPulseThread(type, scale);
}

textPulseThread(type, scale)
{
  self notify("textpulse"+type);
  self endon("death");

  self ChangeFontScaleOverTime(0.05);
  if (isDefined(scale))
  self.fontScale *= scale;
  else
  self.fontScale *= 1.5;
  wait 0.1;
  self ChangeFontScaleOverTime(0.1);
  self.fontScale = self.baseFontScale;
}

doHealth()
{
  self endon("disconnect");
  self endon("death");
  self.curhealth = 0;
  self.healthtext = NewClientHudElem( self );
  self.healthtext.alignX = TR_HUD_VALUE_ALIGNX;
  self.healthtext.alignY = "top";
  self.healthtext.horzAlign = "right";
  self.healthtext.vertAlign = "top";
  self.healthtext.y = -25;
  self.healthtext.x = TR_HUD_VALUE_X;
  self.healthtext.foreground = true;
  self.healthtext.fontScale = 0.75;
  self.healthtext.font = "hudbig";
  self.healthtext.alpha = 1;
  self.healthtext.glow = 1;
  self.healthtext.glowColor = ( 2.55, 0, 0 );
  self.healthtext.glowAlpha = 1;
  self.healthtext.color = ( 1.0, 1.0, 1.0 );


  self.healthlabel = NewClientHudElem( self );
  self.healthlabel.alignX = TR_HUD_LABEL_ALIGNX;
  self.healthlabel.alignY = "top";
  self.healthlabel.horzAlign = "right";
  self.healthlabel.vertAlign = "top";
  self.healthlabel.y = -25;
  self.healthlabel.x = TR_HUD_LABEL_X;
  self.healthlabel.foreground = true;
  self.healthlabel.fontScale = 0.75;
  self.healthlabel.font = "hudbig";
  self.healthlabel.alpha = 1;
  self.healthlabel.glow = 1;
  self.healthlabel.glowColor = ( 2.55, 0, 0 );
  self.healthlabel.glowAlpha = 1;
  self.healthlabel.color = ( 1.0, 1.0, 1.0 );
  self.healthlabel setText("Max HP: ");

  self.healthlabel textPulseInit();
  self.healthtext textPulseInit();

  while(1)
  {
    self.healthtext setValue(self.maxhealth);
    self.healthtext doTextPulse();
    self waittill("HEALTH");
  }
}

doCash()
{
  self endon("disconnect");
  self endon("death");
  self.cashlabel = NewClientHudElem( self );

  self.cashlabel.alignX = TR_HUD_LABEL_ALIGNX;
  self.cashlabel.alignY = "top";
  self.cashlabel.horzAlign = "right";
  self.cashlabel.vertAlign = "top";
  self.cashlabel.foreground = true;
  self.cashlabel.y = -10;
  self.cashlabel.x = TR_HUD_LABEL_X;
  self.cashlabel.fontScale = 0.75;
  self.cashlabel.font = "hudbig";
  self.cashlabel.alpha = 1;
  self.cashlabel.glow = 1;
  self.cashlabel.glowAlpha = 1;
  self.cashlabel.color = ( 1.0, 1.0, 1.0 );
  self.cashlabel setText("Cash: ");

  self.cash = NewClientHudElem( self );
  self.cash.alignX = TR_HUD_VALUE_ALIGNX;
  self.cash.alignY = "top";
  self.cash.horzAlign = "right";
  self.cash.vertAlign = "top";
  self.cash.foreground = true;
  self.cash.y = -10;
  self.cash.x = TR_HUD_VALUE_X;
  self.cash.fontScale = 0.75;
  self.cash.font = "hudbig";
  self.cash.alpha = 1;
  self.cash.glow = 1;
  self.cash.glowAlpha = 1;
  self.cash.color = ( 1.0, 1.0, 1.0 );

  self.cash textPulseInit();
  self.cashlabel textPulseInit();

  while(1)
  {
    if (self.creditshop == false)
    {
      self.cashlabel.glowColor = ( 0, 1, 0 );
      self.cash.glowColor = ( 0, 1, 0 );
      self.cashlabel setText("Cash: ");
      self.cash setValue(self.bounty);
    }
    else
    {
      self.cashlabel.glowColor = ( 0, 0, 1 );
      self.cash.glowColor = ( 0, 0, 1 );
      self.cashlabel setText("Credits: ");
      self.cash setValue(self.credits);
    }
    self waittill("CASH");
  }
}

doLives()
{
  self endon("disconnect");
  self endon("death");
  curlives = -1;

  self.lifetext = NewClientHudElem( self );
  self.lifetext.alignX = TR_HUD_VALUE_ALIGNX;
  self.lifetext.alignY = "top";
  self.lifetext.horzAlign = "right";
  self.lifetext.vertAlign = "top";
  self.lifetext.y = 5;
  self.lifetext.x = TR_HUD_VALUE_X;
  self.lifetext.foreground = true;
  self.lifetext.fontScale = 0.75;
  self.lifetext.font = "hudbig";
  self.lifetext.alpha = 1;
  self.lifetext.glow = 1;
  self.lifetext.glowColor = ( 0.45, 0.45, 1 );
  self.lifetext.glowAlpha = 1;
  self.lifetext.color = ( 1.0, 1.0, 1.0 );

  self.lifelabel = NewClientHudElem( self );
  self.lifelabel.alignX = TR_HUD_LABEL_ALIGNX;
  self.lifelabel.alignY = "top";
  self.lifelabel.horzAlign = "right";
  self.lifelabel.vertAlign = "top";
  self.lifelabel.y = 5;
  self.lifelabel.x = TR_HUD_LABEL_X;
  self.lifelabel.foreground = true;
  self.lifelabel.fontScale = 0.75;
  self.lifelabel.font = "hudbig";
  self.lifelabel.alpha = 1;
  self.lifelabel.glow = 1;
  self.lifelabel.glowColor = ( 0.45, 0.45, 1 );
  self.lifelabel.glowAlpha = 1;
  self.lifelabel.color = ( 1.0, 1.0, 1.0 );
  self.lifelabel setText("Lives: ");

  self.lifetext textPulseInit();
  self.lifelabel textPulseInit();

  while(1)
  {
    self.lifetext setValue(self getCItemVal("life", "in_use"));
    self waittill("LIVES");
  }
}

statCashAdd(amount)
{
  if (self.bounty + amount < 99999)
  self.bounty += amount;
  else
  self.bounty = 99999;
  self notify("CASH");
  self.cash doTextPulse("cash");
}

statCashSub(amount)
{
  if (self.bounty - amount > 0)
  self.bounty -= amount;
  else
  self.bounty = 0;
  self notify("CASH");
  self.cash doTextPulse("cash", 0.6);
}

statCreditsAdd(amount)
{
  if (self.credits + amount < 99999)
  self.credits += amount;
  else
  self.credits = 99999;
  self notify("CASH");
}

statCreditsSub(amount)
{
  if (self.credits + amount > 0)
  self.credits -= amount;
  else
  self.credits = 0;
  self notify("CASH");

  self.cash doTextPulse("cash", 0.6);
}

statLivesInc(amount)
{
  if (self.lives < level.maxlives)
  self.lives++;
  self notify("LIVES");
  self.lifetext doTextPulse("life");
}

statLivesDec(amount)
{
  if (self.lives > 0)
  self.lives--;
  self notify("LIVES");
  self.lifetext doTextPulse("life", 0.6);
}

statMaxHealthAdd(amount)
{
  self.maxhealth += amount;
  self.health += amount;
  self notify("HEALTH");
  self.healthtext doTextPulse("health");
}
/*
doInfoScroll()
{
self endon("disconnect");
for(i = 1200;i >= -1200;i -= 4)
{
level.infotext.x = i;
if(i <= -1200)
{
i = 1200;
}
wait .01;
}
}
*/
doScoreReset()
{
  self.savedStat["score"] += self.pers["score"];
  self.pers["score"] = 0;
  if (!self.ack["used_life"] || level.gameState != "playing")
  {
    self.savedStat["kills"] += self.pers["kills"];
    self.pers["kills"] = 0;
    self.kills = 0;
  }
  self.savedStat["assists"] += self.pers["assists"];
  self.pers["assists"] = 0;
  self.savedStat["deaths"] += self.pers["deaths"];
  self.pers["deaths"] = 0;
  self.pers["suicides"] = 0;
  self.score = 0;

  self.assists = 0;
  self.deaths = 0;
  self.suicides = 0;
}
resetPerks(){
  self.perkz["steadyaim"] = 0;
  self.perkz["stoppingpower"] = 0;
  self.perkz["sitrep"] = 0;
  self.perkz["sleightofhand"] = 0;
  self.perkz["coldblooded"] = 0;
  self.perkz["ninja"] = 0;
  self.perkz["Movespeed"] = 0;
  self.perkz["finalstand"] = 0;
  self.perkz["blastshield"] = 0;
  self.perkz["Commando"] = 0;
}
doPerksSetup()
{
  self.perkz = [];
  resetPerks();

}
/*
doSpawn()
{
maps\mp\gametypes\_credit_items::giveCashUpgrades();
self thread monitorShop();
self thread doShop(); //call doShop on every spawn since the shop ends itself on death
self.combo = 0;
if (self.newcomer == 1)
{
self.ck = self.kills;
self.cd = self.deaths;
self.cs = self.suicides;
self.newcomer = 0;
}

if(level.gameState == "playing" || level.gameState == "ending")
{
if(self.deaths > 0 && self.isZombie == 0)
{
if (self getCItemVal("life", "in_use") > 0)
{
self setCItemVal("life", "in_use", self getCItemVal("life", "in_use")-1);
//self.ack["used_life"] = true;
self iPrintLnBold("^2Used ^5a life!");
if (level.playersLeft["allies"] == 1)
level.lastAlive = 0;
}
else
{
self.isZombie = 1;
self.credit_kills = self.kills;
}

}

if(self.isZombie == 0)
{
self thread doSetup(true); //Called when human joins midround or respawn
}

if(self.isZombie == 1)
{
self thread doZombie();
}
if(self.isZombie == 2)
{
self thread doAlphaZombie();
}

}
else
{
self thread doSetup(false); //Called when human joins on intermission
}

self thread doDvars();
self.menu = 0;
self thread CreatePlayerHUD();
self thread doMenuScroll();
//self thread doHUDControl();
self thread doCash();
self thread doHealth();
self thread doLives();
self thread destroyOnDeath();
self thread doMenuInfo();

//Testing money on Player Spawn, +5000 | Testversion
self statCashAdd(5000);
if(level.gamestate == "starting")
{
self thread OMAExploitFix();
}
self freezeControlsWrapper( false );
if (self.ack["safe"] == false)
self.ack["safe"] = true;
}
*/
/*
doMenuInfo()
{
self endon("disconnect");
self endon("death");
while(1)
{
if (self.team == "axis")
self.menutext setText("Zombie Shop " + (self.menu+1) + "/" + (4));
else
if (self.creditshop == true){
self.menutext setText("Credit Shop " + (self.menu+1) + "/" + (level.creditM.size));
}
else{
self.menutext setText("Human Shop " + (self.menu+1) + "/" + (level.humanM.size));
}
self notify("MENUCHANGE_2");
self waittill("MENUCHANGE");
}
}
*/


ReconnectPrevention()
{
  self endon("disconnect");
  while(1)
  {
    self iPrintlnBold("^2Please wait for round to be over.");
    if(self.team != "spectator")
    {
      self notify("menuresponse", game["menu_team"], "spectator");
    }
    maps\mp\gametypes\_spectating::setSpectatePermissions();
    self allowSpectateTeam( "freelook", true );
    self.sessionstate = "spectator";
    self setContents( 0 );
    if(level.gameState == "intermission"){
      return;
    }
    wait 1;
  }
}

doInit()
{
  level.gameState = "";
  level.ShowCreditShop = false;
  level weaponInit();
  level CostInit();
  level MenuInit();
  level CreateServerHUD();
  level.infotext setText(getDvar("scr_zmod_infotext"));
  level thread OverRider();
  level thread doPlaceMsgLoop();
  CleanupKillstreaks();
  level.mapwait = 0;

  level initializeItemFuncArray();
  level InitializeSpawnPoints();
  level thread maps\mp\gametypes\MapEdit::init();

  setDvar("g_gametype", "war");
  setDvar("ui_gametype", "war");
  setDvar("scr_war_scorelimit", 0);
  setDvar("scr_war_waverespawndelay", 0);
  setDvar("scr_war_playerrespawndelay", 0);
  wait 2;

  level thread doGameStarter();
}

CostInit()
{
  level.itemCost = [];
  level.itemCost["ammo"] = 100;
  level.itemCost["LMG"] = 200;
  level.itemCost["Assault Rifle"] = 150;
  level.itemCost["Machine Pistol"] = 50;
  level.itemCost["Riot"] = 200;
  level.itemCost["Akimbo"] = 50;
  level.itemCost["Eotech"] = 50;
  level.itemCost["FMJ"] = 100;
  level.itemCost["Silencer"] = 200;
  level.itemCost["XMags"] = 150;
  level.itemCost["ROF"] = 50;
  level.itemCost["SteadyAim"] = 150;
  level.itemCost["SteadyAimPro"] = 100;
  level.itemCost["SleightOfHand"] = 150;
  level.itemCost["SleightOfHandPro"] = 100;
  level.itemCost["SitRep"] = 50;
  level.itemCost["SitRepPro"] = 50;
  level.itemCost["Commando"] = 200;
  level.itemCost["StoppingPower"] = 200;
  level.itemCost["StoppingPowerPro"] = 50;
  level.itemCost["ColdBlooded"] = 250;
  level.itemCost["ColdBloodedPro"] = 100;
  level.itemCost["Ninja"] = 100;
  level.itemCost["NinjaPro"] = 100;
  level.itemCost["Movespeed"] = 100;
  level.itemCost["FinalStand"] = 100;
  level.itemCost["pmissile"] = 150;
  level.itemCost["rpg7"] = 50;
  level.itemCost["nuke"] = 3500;
  level.itemCost["nuke_cheap"] = 2500;
  level.itemCost["rifle"] = 100;
  level.itemCost["smg"] = 200;
  level.itemCost["stinger"] = 150;
  level.itemCost["ac130"] = 1000;
  level.itemCost["sentry"] = 450;
  level.itemCost["choppergunner"] = 800;
  level.itemCost["pavelow"] = 500;
  level.itemCost["acog"] = 50;
  level.itemCost["repair"] = 250;
  level.itemCost["harrier"] = 450;

  level.itemCost["artillery"] = 400;
  level.itemCost["airstrike"] = 250;
  level.itemCost["GrimReaper"] = 500;
  level.itemCost["BetterDevils"] = 500;

  level.itemCost["riotz"] = 100;


  level.itemCost["ch_cash"] = 400;
  level.itemCost["cz_cash"] = 400;
  level.itemCost["ch_fullammo"] = 250;
  level.itemCost["cz_atk"] = 350;
  level.itemCost["c_alpha"] = 450;
  level.itemCost["ch_life"] = 300;
  level.itemCost["ch_cheapnuke"] = 1500;
  level.itemCost["ch_commandopro"] = 250;
  level.itemCost["ch_rofl"] = 2000;
  level.itemCost["ch_eotech"] = 200;
  level.itemCost["ch_nadeupgrade"] = 200;
  level.itemCost["ch_finalstand"] = 600;
  level.itemCost["ch_tact"] = 250;
  level.itemCost["cz_riot"] = 800;
}

weaponInit()
{
  level.lmg = [];
  level.lmg[0] = "rpd";
  level.weapname["rpd"] = "RPD";
  level.lmg[1] = "sa80";
  level.weapname["sa80"] = "LSW";
  level.lmg[2] = "mg4";
  level.weapname["mg4"] = "MG4";
  level.lmg[3] = "m240";
  level.weapname["m240"] = "M240";
  level.lmg[4] = "aug";
  level.weapname["aug"] = "AUG";

  level.assault = [];
  level.assault[0] = "ak47";
  level.weapname["ak47"] = "AK-47";
  level.assault[1] = "m16";
  level.weapname["m16"] = "M16";
  level.assault[2] = "m4";
  level.weapname["m4"] = "M4";
  level.assault[3] = "fn2000";
  level.weapname["fn2000"] = "F2000";
  level.assault[4] = "masada";
  level.weapname["masada"] = "ACR";
  level.assault[5] = "famas";
  level.weapname["famas"] = "FAMAS";
  level.assault[6] = "fal";
  level.weapname["fal"] = "FAL";
  level.assault[7] = "scar";
  level.weapname["scar"] = "SCAR-H";
  level.assault[8] = "tavor";
  level.weapname["tavor"] = "TAR-21";

  level.sights = [];
  level.sights[0] = "reflex";
  level.sights[1] = "eotech";
  level.sights[2] = "acog";
  level.sights[3] = "";

  level.smg = [];
  level.smg[0] = "mp5k";
  level.weapname["mp5k"] = "MP5K";
  level.smg[1] = "uzi";
  level.weapname["uzi"] = "MINI-UZI";
  level.smg[2] = "p90";
  level.weapname["p90"] = "P90";
  level.smg[3] = "kriss";
  level.weapname["kriss"] = "VECTOR";
  level.smg[4] = "ump45";
  level.weapname["ump45"] = "UMP45";

  level.shot = [];
  level.shot[0] = "ranger";
  level.weapname["ranger"] = "RANGER";
  level.shot[1] = "model1887";
  level.weapname["model1887"] = "MODEL-1887";
  level.shot[2] = "striker";
  level.weapname["striker"] = "STRIKER";
  level.shot[3] = "aa12";
  level.weapname["aa12"] = "AA12";
  level.shot[4] = "m1014";
  level.weapname["m1014"] = "M1014";
  level.shot[5] = "spas12";
  level.weapname["spas12"] = "SPAS-12";

  level.machine = [];
  level.machine[0] = "pp2000";
  level.weapname["pp2000"] = "PP2000";
  level.machine[1] = "glock";
  level.weapname["glock"] = "G18";
  level.machine[2] = "beretta393";
  level.weapname["beretta393"] = "RAFFICA";

  level.hand = [];
  level.hand[0] = "beretta";
  level.hand[1] = "usp";
  level.hand[2] = "deserteagle";
  level.hand[3] = "coltanaconda";
  level.hand[4] = "glock";
  level.hand[5] = "beretta393";
  level.hand[6] = "pp2000";
  level.hand[7] = "tmp";



  level.rifle = [];
  level.rifle[0] = "wa2000";
  level.weapname["wa2000"] = "WA2000";
  level.rifle[1] = "barrett";
  level.weapname["barrett"] = "BARRETT .50CAL";
  level.rifle[2] = "cheytac";
  level.weapname["cheytac"] = "INTERVENTION";
  level.rifle[3] = "m21";
  level.weapname["m21"] = "M21 EBR";

  level.explosives = [];
  level.explosives[0] = "frag";
  level.weapname["frag"] = "FRAG";
  level.explosives[1] = "semtex";
  level.weapname["semtex"] = "SEMTEX";
  level.explosives[2] = "claymore";
  level.weapname["claymore"] = "CLAYMORE";
  level.explosives[3] = "c4";
  level.weapname["c4"] = "C4 CHARGE";

  level.weapname["riotshield"] = "Riotshield";

  level.weaponclasses = [];
  level.weaponclasses[0] = "weapon_lmg";
  level.weaponclasses[1] = "weapon_assault";
  level.weaponclasses[2] = "weapon_smg";
  level.weaponclasses[3] = "weapon_shotgun";
  level.weaponclasses[4] = "weapon_machine_pistol";
  level.weaponclasses[5] = "weapon_pistol";
  level.weaponclasses[6] = "weapon_sniper";
  level.weaponclasses[7] = "weapon_riot";
  level.weaponclasses[8] = "weapon_explosives";
}

MenuInit()
{

  level.humanM = [];
  i = 0;
  level.humanM[i] = [];
  level.humanM[i][0] = "Buy Ammo for Current Weapon - " + level.itemCost["ammo"];
  level.humanM[i][1] = [];
  level.humanM[i][1]["LMG"] = "Press [{+actionslot 2}] - Exchange for a LMG - " + level.itemCost["LMG"];
  level.humanM[i][1]["Assault Rifle"] = "Press [{+actionslot 2}] - Exchange for an Assault Rifle - " + level.itemCost["Assault Rifle"];
  level.humanM[i][1]["Machine Pistol"] = "Press [{+actionslot 2}] - Exchange for a Machine Pistol - " + level.itemCost["Machine Pistol"];
  level.humanM[i][1]["smg"] = "Press [{+actionslot 2}] - Exchange for a SMG - " + level.itemCost["smg"];
  level.humanM[i][1]["Unavailable"] = "Weapon can not be Exchanged";
  level.humanM[i][2] = "Buy Riot Shield - " + level.itemCost["Riot"];
  i++;//Menu = 2
  level.humanM[i] = [];
  level.humanM[i][0] = "Upgrade to Akimbo - " + level.itemCost["Akimbo"];
  level.humanM[i][1] = "Upgrade to FMJ - " + level.itemCost["FMJ"];
  level.humanM[i][2]["new"] = "Upgrade to Holographic Sight - " + level.itemCost["Eotech"];
  level.humanM[i][2]["normal"] = "Upgrade to Red-Dot Sight - " + level.itemCost["Eotech"];
  i++;//Menu = 3
  level.humanM[i] = [];
  level.humanM[i][0] = "Upgrade to Silencer - " + level.itemCost["Silencer"];
  level.humanM[i][1] = "Upgrade to Extended Mags - " + level.itemCost["XMags"];
  level.humanM[i][2] = "Upgrade to Rapid Fire - " + level.itemCost["ROF"];
  i++;//Menu = 4
  level.humanM[i] = [];
  level.humanM[i][0]["normal"] = "Buy Steady Aim - " + level.itemCost["SteadyAim"];
  level.humanM[i][0]["pro"] = "Upgrade to Steady Aim Pro - " + level.itemCost["SteadyAimPro"];
  level.humanM[i][1]["normal"] = "Buy Sleight of Hand - " + level.itemCost["SleightOfHand"];
  level.humanM[i][1]["pro"] = "Upgrade to Sleight of Hand Pro - " + level.itemCost["SleightOfHandPro"];

  level.humanM[i][2]["normal"] = "Buy RPG-7 - " + level.itemCost["rpg7"];
  level.humanM[i][2]["new"] = "Buy ROFL Launcher -" + level.itemCost["rpg7"];
  i++;//Menu = 5
  level.humanM[i] = [];
  level.humanM[i][0]["normal"] = "Buy Stopping Power - " + level.itemCost["StoppingPower"];
  level.humanM[i][0]["pro"] = "Upgrade to Stopping Power Pro - " + level.itemCost["StoppingPowerPro"];
  level.humanM[i][1]["normal"] = "Buy ACOG Scope - " + level.itemCost["acog"];
  level.humanM[i][2] = "Buy Predator Strike - " + level.itemCost["pmissile"];
  i++;//Menu = 6
  level.humanM[i][0] = "Buy Tactical Nuke - ";
  level.humanM[i][1] = "Buy Sniper Rifle - " + level.itemCost["rifle"];
  level.humanM[i][2] = "Buy AC-130 - " + level.itemCost["ac130"];
  i++;//Menu = 7
  level.humanM[i][0] = "Buy Sentry - " + level.itemCost["sentry"];
  level.humanM[i][1] = "Buy Pave Low - " + level.itemCost["pavelow"];
  level.humanM[i][2] = "Buy Chopper Gunner - " + level.itemCost["choppergunner"];
  i++;//Menu = 8
  level.humanM[i][1]["buy"] = "Buy Door Repair Tool - " + level.itemCost["repair"];
  level.humanM[i][1]["on"] = "Switch to repair tool";
  level.humanM[i][1]["off"] = "Switch to weapons";
  level.humanM[i][0] = "Buy Harrier - " + level.itemCost["harrier"];
  level.humanM[i][2] = " Buy Better Devils - " + level.itemCost["BetterDevils"];
  i++;//Menu = 9
  level.humanM[i][0] = "Buy Artillery - " + level.itemCost["artillery"];
  level.humanM[i][1] = "Buy Airstrike - " + level.itemcost ["airstrike"];
  level.humanM[i][2] = "Buy GrimReaper - " + level.itemCost["GrimReaper"];


  i = 0;
  level.creditM = [];

  level.creditM[i] = [];
  // i == 0
  level.creditM[i][0]["text"] = "[Human] Buy 200 Starting Cash - " + level.itemCost["ch_cash"];
  level.creditM[i][0]["cost"] = level.itemCost["ch_cash"];
  level.creditM[i][1]["text"] = "[Alpha Zombie Only] Buy 200 Starting Cash - " + level.itemCost["cz_cash"];
  level.creditM[i][1]["cost"] = level.itemCost["cz_cash"];
  level.creditM[i][2]["text"] = "[Human] Buy Full Ammo on Weapon Upgrade - " + level.itemCost["ch_fullammo"];
  level.creditM[i][2]["cost"] = level.itemCost["ch_fullammo"];
  i++; //i == 1
  level.creditM[i][0]["text"] = "[Zombie] Buy Increase Door ATK - " + level.itemCost["cz_atk"];
  level.creditM[i][0]["cost"] = level.itemCost["cz_atk"];
  level.creditM[i][1]["text"] = "Buy Anti-Alpha - " + level.itemCost["c_alpha"];
  level.creditM[i][1]["cost"] = level.itemCost["c_alpha"];
  level.creditM[i][2]["text"] = "[Human] Buy Extra Life - " + level.itemCost["ch_life"];
  level.creditM[i][2]["cost"] = level.itemCost["ch_life"];
  i++; //i == 2
  level.creditM[i][0]["text"] = "[Human] Buy Cheaper Nuke (1500) - " + level.itemCost["ch_cheapnuke"];
  level.creditM[i][0]["cost"] = level.itemCost["ch_cheapnuke"];
  level.creditM[i][1]["text"] = "[Human] Buy Commando Pro for LPA - " + level.itemCost["ch_commandopro"];
  level.creditM[i][1]["cost"] = level.itemCost["ch_commandopro"];
  level.creditM[i][2]["text"] = "[Human Shop] Unlock ROFL Launcher - " + level.itemCost["ch_rofl"];
  level.creditM[i][2]["cost"] = level.itemCost["ch_rofl"];
  i++; //i == 3
  level.creditM[i][0]["text"] = "[Human Shop] Unlock Holographic Sight - " + level.itemCost["ch_eotech"];
  level.creditM[i][0]["cost"] = level.itemCost["ch_eotech"];
  level.creditM[i][1]["text"] = [];
  level.creditM[i][1]["text"][0] = "[Human] Upgrade to Semtex - " + level.itemCost["ch_nadeupgrade"];
  level.creditM[i][1]["text"][1] = "[Human] Upgrade to Claymore - " + level.itemCost["ch_nadeupgrade"];
  level.creditM[i][1]["text"][2] = "[Human] Upgrade to C4 - " + level.itemCost["ch_nadeupgrade"];
  level.creditM[i][1]["cost"] = level.itemCost["ch_nadeupgrade"];
  level.creditM[i][2]["text"] = "[Human] Unlock Final Stand - " + level.itemCost["ch_finalstand"];
  level.creditM[i][2]["cost"] = level.itemCost["ch_finalstand"];
  i++; // i == 4
  level.creditM[i][0]["text"] = "[Human] Tactical Insertion for Lives - " + level.itemCost["ch_tact"];
  level.creditM[i][0]["cost"] = level.itemCost["ch_tact"];
  level.creditM[i][1]["text"] = "[Zombie] Unlock Riot Shield - " + level.itemCost["cz_riot"];
  level.creditM[i][1]["cost"] = level.itemCost["cz_riot"];

}

OverRider()
{
  for(;;)
  {
    level notify("abort_forfeit");
    level.prematchPeriod = 0;

    if (level.enablekillcam)
    level.killcam = 1;
    else
    level.killcam = 0;
    level.killstreakRewards = 0;
    wait 1;
  }
}



OMAExploitFix()
{
  self endon("disconnect");
  self endon("death");
  while(1)
  {
    if(self _hasPerk("specialty_onemanarmy") || self _hasPerk("specialty_omaquickchange"))
    {
      self _clearPerks();
      self takeAllWeapons();
    }
    wait .5;
  }
}

CashFix()
{
  self endon("disconnect");
  while(1)
  {
    if(self.bounty < 0)
    {
      self.bounty = 0;
      self notify("CASH");
    }
    wait .5;
  }
}

iniButtons()
{
  self.buttonAction = [];
  self.buttonAction[0]="+actionslot 2";
  self.buttonAction[1]="+actionslot 1";
  self.buttonAction[2]="+actionslot 4";
  self.buttonAction[3]="+smoke";
  self.buttonAction[4]="+activate";
  self.buttonAction[5]="+frag";
  self.buttonAction[6]="+actionslot 3";
  self.buttonPressed = [];
  for(i=0;i<self.buttonAction.size;i++)
  {
    self.buttonPressed[self.buttonAction[i]] = 0;
    self thread monitorButtons( self.buttonAction[i] );
  }
}

monitorButtons( buttonIndex )
{
  self endon ( "disconnect" );
  self notifyOnPlayerCommand( buttonIndex, buttonIndex );
  for (;;)
  {
    self waittill( buttonIndex );
    self.buttonPressed[ buttonIndex ] = 1;
    wait .1;
    self.buttonPressed[ buttonIndex ] = 0;
  }
}

fadeOutMenu(dest)
{
  self.menutext fadeOverTime(0.3);
  self.menutext.alpha = 0.2;
  self.option1 fadeOverTime(0.3);
  self.option1.alpha = 0.2;
  self.option2 fadeOverTime(0.3);
  self.option2.alpha = 0.2;
  self.option3 fadeOverTime(0.3);
  self.option3.alpha = 0.2;
  self.option1 fadeOverTime(0.3);
  self.option1.alpha = 0.2;
  self.scrollleft fadeOverTime(0.3);
  self.scrollleft.alpha = 0.1;
  self.scrollright fadeOverTime(0.3);
  self.scrollright.alpha = 0.1;
}

fadeInMenu(dest)
{
  self.menutext fadeOverTime(0.3);
  self.menutext.alpha = 1;
  self.option1 fadeOverTime(0.3);
  self.option1.alpha = 1;
  self.option2 fadeOverTime(0.3);
  self.option2.alpha = 1;
  self.option3 fadeOverTime(0.3);
  self.option3.alpha = 1;
  self.option1 fadeOverTime(0.3);
  self.option1.alpha = 1;
  self.scrollleft fadeOverTime(0.3);
  self.scrollleft.alpha = 1;
  self.scrollright fadeOverTime(0.3);
  self.scrollright.alpha = 1;
}



CreateServerHUD()
{

  level.infotext = NewHudElem();
  level.infotext.alignX = "center";
  level.infotext.alignY = "bottom";
  level.infotext.horzAlign = "center";
  level.infotext.vertAlign = "bottom";
  level.infotext.y = 25;
  level.infotext.foreground = true;
  level.infotext.fontScale = 1;
  level.infotext.font = "objective";
  level.infotext.alpha = 1;
  level.infotext.glow = 0;
  level.infotext.glowColor = ( 0, 0, 0 );
  level.infotext.glowAlpha = 1;
  level.infotext.color = ( 1.0, 1.0, 1.0 );
}

init()
{
  level.scoreInfo = [];
  level.xpScale = getDvarInt( "scr_xpscale" );
  level.rankTable = [];
  precacheShader("white");
  precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
  precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
  precacheString( &"RANK_PROMOTED" );
  precacheString( &"MP_PLUS" );
  precacheString( &"RANK_ROMANI" );
  precacheString( &"RANK_ROMANII" );
  precacheString( &"RANK_ROMANIII" );
  registerScoreInfo("zmod_credits", 0);
  if ( level.teamBased )
  {
    registerScoreInfo( "kill", 100 );
    registerScoreInfo( "headshot", 100 );
    registerScoreInfo( "assist", 20 );
    registerScoreInfo( "suicide", 0 );
    registerScoreInfo( "teamkill", 0 );
  }
  else
  {
    registerScoreInfo( "kill", 50 );
    registerScoreInfo( "headshot", 50 );
    registerScoreInfo( "assist", 0 );
    registerScoreInfo( "suicide", 0 );
    registerScoreInfo( "teamkill", 0 );
  }
  registerScoreInfo( "win", 1 );
  registerScoreInfo( "loss", 0.5 );
  registerScoreInfo( "tie", 0.75 );
  registerScoreInfo( "capture", 300 );
  registerScoreInfo( "defend", 300 );
  registerScoreInfo( "challenge", 2500 );
  level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
  level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));
  pId = 0;
  rId = 0;
  for ( pId = 0; pId <= level.maxPrestige; pId++ )
  {
    for ( rId = 0;rId <= level.maxRank;rId++ )
    {
      precacheShader( tableLookup( "mp/rankIconTable.csv", 0, rId, pId+1 ) );
    }
  }
  rankId = 0;
  rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
  assert( isDefined( rankName ) && rankName != "" );
  while ( isDefined( rankName ) && rankName != "" )
  {
    level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
    level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
    level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
    level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );
    precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );
    rankId++;
    rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
  }
  maps\mp\gametypes\_missions::buildChallegeInfo();

  chaz_init();
  //level thread patientZeroWaiter();
  level thread onPlayerConnect();
  level thread doInit();


}
/*
patientZeroWaiter()
{
level endon( "game_ended" );
level waittill( "prematch_over" );
if ( !matchMakingGame() )
{
if ( getDvar( "mapname" ) == "mp_rust" && randomInt( 1000 ) == 999 )
{
level.patientZeroName = level.players[0].name;
}
}
else
{
if ( getDvar( "scr_patientZero" ) != "" )
{
level.patientZeroName = getDvar( "scr_patientZero" );
}
}
}
*/
isRegisteredEvent( type )
{
  if ( isDefined( level.scoreInfo[type] ) )
  {
    return true;
  }
  else
  {
    return false;
  }
}

registerScoreInfo( type, value )
{
  level.scoreInfo[type]["value"] = value;
}

getScoreInfoValue( type )
{
  overrideDvar = "scr_" + level.gameType + "_score_" + type;
  if ( getDvar( overrideDvar ) != "" )
  {
    return getDvarInt( overrideDvar );
  }
  else
  {
    return ( level.scoreInfo[type]["value"] );
  }
}

getScoreInfoLabel( type )
{
  return ( level.scoreInfo[type]["label"] );
}

getRankInfoMinXP( rankId )
{
  return int(level.rankTable[rankId][2]);
}

getRankInfoXPAmt( rankId )
{
  return int(level.rankTable[rankId][3]);
}

getRankInfoMaxXp( rankId )
{
  return int(level.rankTable[rankId][7]);
}

getRankInfoFull( rankId )
{
  return tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 );
}

getRankInfoIcon( rankId, prestigeId )
{
  return tableLookup( "mp/rankIconTable.csv", 0, rankId, prestigeId+1 );
}

getRankInfoLevel( rankId )
{
  return int( tableLookup( "mp/ranktable.csv", 0, rankId, 13 ) );
}


onPlayerConnect()
{

  for(;;)
  {
    level waittill( "connected", player );
    player.isZombie=0;
    player initializeZMenu();
    player initializeHMenu();
    player initializeCMenu();
    player.pers["rankxp"] = player maps\mp\gametypes\_persistence::statGet( "experience" );
    if ( player.pers["rankxp"] < 0 )
    {
      player.pers["rankxp"] = 0;
    }
    rankId = player getRankForXp( player getRankXP() );
    player.pers[ "rank" ] = rankId;
    player.pers[ "participation" ] = 0;
    player.xpUpdateTotal = 0;
    player.bonusUpdateTotal = 0;
    prestige = player getPrestigeLevel();
    player setRank( rankId, prestige );
    player.pers["prestige"] = prestige;
    player.postGamePromotion = false;
    if ( !isDefined( player.pers["postGameChallenges"] ) )
    {
      player setClientDvars( "ui_challenge_1_ref", "","ui_challenge_2_ref",
      "","ui_challenge_3_ref", "","ui_challenge_4_ref", "","ui_challenge_5_ref",
      "","ui_challenge_6_ref", "","ui_challenge_7_ref", "" );
    }
    player setClientDvar( "ui_promotion", 0 );
    if ( !isDefined( player.pers["summary"] ) )
    {
      player.pers["summary"] = [];
      player.pers["summary"]["xp"] = 0;
      player.pers["summary"]["score"] = 0;
      player.pers["summary"]["challenge"] = 0;
      player.pers["summary"]["match"] = 0;
      player.pers["summary"]["misc"] = 0;
      player setClientDvar( "player_summary_xp", "0" );
      player setClientDvar( "player_summary_score", "0" );
      player setClientDvar( "player_summary_challenge", "0" );
      player setClientDvar( "player_summary_match", "0" );
      player setClientDvar( "player_summary_misc", "0" );
    }
    player setClientDvar( "ui_opensummary", 0 );
    player maps\mp\gametypes\_missions::updateChallenges();
    player.explosiveKills[0] = 0;
    player.xpGains = [];
    player.hud_scorePopup = newClientHudElem( player );
    player.hud_scorePopup.horzAlign = "center";
    player.hud_scorePopup.vertAlign = "middle";
    player.hud_scorePopup.alignX = "center";
    player.hud_scorePopup.alignY = "middle";
    player.hud_scorePopup.x = 0;
    if ( level.splitScreen )
    {
      player.hud_scorePopup.y = -40;
    }
    else
    {
      player.hud_scorePopup.y = -60;
    }
    player.hud_scorePopup.font = "hudbig";
    player.hud_scorePopup.fontscale = 0.75;
    player.hud_scorePopup.archived = false;
    player.hud_scorePopup.color = (0.5,0.5,0.5);
    player.hud_scorePopup.sort = 10000;
    player.hud_scorePopup maps\mp\gametypes\_hud::fontPulseInit( 3.0 );
    if (level.gameState == "playing" || level.gameState == "ending")
    {
      player.newcomer = 1;
    }
    else
    {
      player.newcomer = 0;
    }

    isd = false;

    player.doorInRange = 0;
    player.wasAlpha = 0;
    player.wasSurvivor = 0;
    player.credits = player getCreditsPersistent();
    player.credits = 50000;
    //player init_player_extra();

    player iniButtons();
    //player thread maps\mp\gametypes\_spawn::doSpawn();
    //	player notify("menuresponse", game["menu_team"], "allies");
    //	wait .1;
    //  player notify("menuresponse", "changeclass", "class1");
    player thread maps\mp\gametypes\_shop_menu::destroyOnDeath();
    player thread maps\mp\gametypes\_spawn::onPlayerSpawned();
    //player thread debugtext();
    //	player thread maps\mp\gametypes\_spawn::onJoinedTeam();
    //	player thread maps\mp\gametypes\_spawn::onJoinedSpectators();
    player thread CashFix();
    player thread onDisconnect();

    player allowSpectateTeam( "allies", true );
    player allowSpectateTeam( "axis", true );
    player allowSpectateTeam( "freelook", true );
    player allowSpectateTeam( "none", true );

    player.CONNECT = 1;

    //player thread TestSpawnpoints();
	  //player thread CollectSpawnCords();
  }

}


debugtext(){
  while(1){
    self iPrintlnBold(self.team+" "+self.isZombie+" "+game["menu_team"]);
    wait .5;
  }
}
onDisconnect()
{
  self waittill("disconnect");
}

clog(msg)
{
  if (level.debug == 0)
  return;
  if (!isDefined(msg))
  level.msgs[level.msgs_size] = "Log message is undefined!";
  else
  level.msgs[level.msgs_size] = msg;
  level.msgs_size += 1;
}





roundUp( floatVal )
{
  if ( int( floatVal ) != floatVal )
  {
    return int( floatVal+1 );
  }
  else
  {
    return int( floatVal );
  }
}
giveRankXP( type, value )
{
  self endon("disconnect");
  lootType = "none";
  if ( !self rankingEnabled() )
  {
    return;
  }
  if ( level.teamBased && (!level.teamCount["allies"] || !level.teamCount["axis"]) )
  {
    return;
  }
  else
  if( !level.teamBased && (level.teamCount["allies"] + level.teamCount["axis"] < 2) )
  {
    return;
  }
  if ( !isDefined( value ) )
  {
    value = getScoreInfoValue( type );
  }
  if ( !isDefined( self.xpGains[type] ) )
  {
    self.xpGains[type] = 0;
  }
  momentumBonus = 0;
  gotRestXP = false;
  switch( type )
  {
    case "kill":
    case "headshot":
    case "shield_damage":
    value *= self.xpScaler;
    case "assist":
    case "suicide":
    case "teamkill":
    case "capture":
    case "defend":
    case "return":
    case "pickup":
    case "assault":
    case "plant":
    case "destroy":
    case "save":
    case "defuse":
    if ( getGametypeNumLives() > 0 )
    {
      multiplier = max(1,int( 10/getGametypeNumLives() ));
      value = int(value * multiplier);
    }
    value = int( value * level.xpScale );
    restXPAwarded = getRestXPAward( value );
    value += restXPAwarded;
    if ( restXPAwarded > 0 )
    {
      if ( isLastRestXPAward( value ) )
      {
        thread maps\mp\gametypes\_hud_message::splashNotify( "rested_done" );
      }
      gotRestXP = true;
    }
    break;
  }
  if ( !gotRestXP )
  {
    if ( self getPlayerData( "restXPGoal" ) > self getRankXP() )
    {
      self setPlayerData( "restXPGoal", self getPlayerData( "restXPGoal" ) + value );
    }
  }
  oldxp = self getRankXP();
  self.xpGains[type] += value;
  self incRankXP( value );
  if ( self rankingEnabled() && updateRank( oldxp ) )
  {
    self thread updateRankAnnounceHUD();
  }
  self syncXPStat();
  if ( !level.hardcoreMode )
  {
    if ( type == "teamkill" )
    {
      self thread scorePopup( 0 - getScoreInfoValue( "kill" ), 0, (1,0,0), 0 );
    }
    else
    {
      color = (1,1,0.5);
      if ( gotRestXP )
      {
        color = (1,.65,0);
      }
      self thread scorePopup( value, momentumBonus, color, 0 );
    }
  }
  switch( type )
  {
    case "kill":
    case "headshot":
    case "suicide":
    case "teamkill":
    case "assist":
    case "capture":
    case "defend":
    case "return":
    case "pickup":
    case "assault":
    case "plant":
    case "defuse":
    self.pers["summary"]["score"] += value;
    self.pers["summary"]["xp"] += value;
    break;
    case "win":
    case "loss":
    case "tie":
    self.pers["summary"]["match"] += value;
    self.pers["summary"]["xp"] += value;
    break;
    case "challenge":
    self.pers["summary"]["challenge"] += value;
    self.pers["summary"]["xp"] += value;
    break;
    default:
    self.pers["summary"]["misc"] += value;
    self.pers["summary"]["match"] += value;
    self.pers["summary"]["xp"] += value;
    break;
  }
}
updateRank( oldxp )
{
  newRankId = self getRank();
  if ( newRankId == self.pers["rank"] )
  {
    return false;
  }
  oldRank = self.pers["rank"];
  rankId = self.pers["rank"];
  self.pers["rank"] = newRankId;
  println( "promoted " + self.name + " from rank " + oldRank + " to " + newRankId + ". Experience went from " + oldxp + " to " + self getRankXP() + "." );
  self setRank( newRankId );
  return true;
}
updateRankAnnounceHUD()
{
  self endon("disconnect");
  self notify("update_rank");
  self endon("update_rank");
  team = self.pers["team"];
  if ( !isdefined( team ) )
  {
    return;
  }
  if ( !levelFlag( "game_over" ) )
  {
    level waittill_notify_or_timeout( "game_over", 0.25 );
  }
  newRankName = self getRankInfoFull( self.pers["rank"] );
  rank_char = level.rankTable[self.pers["rank"]][1];
  subRank = int(rank_char[rank_char.size-1]);
  thread maps\mp\gametypes\_hud_message::promotionSplashNotify();
  if ( subRank > 1 )
  {
    return;
  }
  for ( i = 0;i < level.players.size;i++ )
  {
    player = level.players[i];
    playerteam = player.pers["team"];
    if ( isdefined( playerteam ) && player != self )
    {
      if ( playerteam == team )
      {
        player iPrintLn( &"RANK_PLAYER_WAS_PROMOTED", self, newRankName );
      }
    }
  }
}
endGameUpdate()
{
  player = self;
}

fontPulseNew(player)
{
  self notify ( "fontPulse" );
  self endon ( "fontPulse" );
  self endon( "death" );

  player endon("disconnect");
  player endon("joined_team");
  player endon("joined_spectators");

  self ChangeFontScaleOverTime( self.inFrames * 0.05 );
  self.fontScale = self.maxFontScale;
  wait (self.inFrames * 0.05);

  self ChangeFontScaleOverTime( self.outFrames * 0.05 );
  self.fontScale = self.baseFontScale;
  wait 0.3;

  self fadeOverTime( 0.75 );
  self.alpha = 0;
}


justScorePopup( text )
{
  glowAlpha = (1, 1, 1);
  hudColor = (1,1,0.5);
  self endon( "disconnect" );
  self endon( "joined_team" );
  self endon( "joined_spectators" );
  self notify( "scorePopup" );
  self.hud_scorePopup.color = hudColor;
  self.hud_scorePopup.glowColor = hudColor;
  self.hud_scorePopup.glowAlpha = glowAlpha;
  self.hud_scorePopup setText(text);
  self.hud_scorePopup.alpha = 0;
  self.hud_scorePopup thread fontPulseNew( self );
}

scorePopup( amount, bonus, hudColor, glowAlpha )
{
  self endon( "disconnect" );
  self endon( "joined_team" );
  self endon( "joined_spectators" );
  if ( amount == 0 )
  {
    return;
  }
  self notify( "scorePopup" );
  self endon( "scorePopup" );
  self.xpUpdateTotal += amount;
  self.bonusUpdateTotal += bonus;
  wait ( 0.05 );

  increment = max( int( self.bonusUpdateTotal / 20 ), 1 );
  if ( self.bonusUpdateTotal )
  {
    while ( self.bonusUpdateTotal > 0 )
    {
      self.xpUpdateTotal += min( self.bonusUpdateTotal, increment );
      self.bonusUpdateTotal -= min( self.bonusUpdateTotal, increment );
      wait ( 0.05 );
    }
  }
  else
  {
    wait ( 1.0 );
  }
  self.xpUpdateTotal = 0;
}
removeRankHUD()
{
  self.hud_scorePopup.alpha = 0;
}
getRank()
{
  rankXp = self.pers["rankxp"];
  rankId = self.pers["rank"];
  if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
  {
    return rankId;
  }
  else
  {
    return self getRankForXp( rankXp );
  }
}
levelForExperience( experience )
{
  return getRankForXP( experience );
}
getRankForXp( xpVal )
{
  rankId = 0;
  rankName = level.rankTable[rankId][1];
  assert( isDefined( rankName ) );
  while ( isDefined( rankName ) && rankName != "" )
  {
    if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
    {
      return rankId;
    }
    rankId++;
    if ( isDefined( level.rankTable[rankId] ) )
    {
      rankName = level.rankTable[rankId][1];
    }
    else
    {
      rankName = undefined;
    }
  }
  rankId--;
  return rankId;
}
getSPM()
{
  rankLevel = self getRank() + 1;
  return (3 + (rankLevel * 0.5))*10;
}
getPrestigeLevel()
{
  return self maps\mp\gametypes\_persistence::statGet( "prestige" );
}

getRankXP()
{
  return self.pers["rankxp"];
}

incRankXP( amount )
{
  if ( !self rankingEnabled() )
  {
    return;
  }
  if ( isDefined( self.isCheater ) )
  {
    return;
  }
  xp = self getRankXP();
  newXp = (xp + amount);
  if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
  {
    newXp = getRankInfoMaxXP( level.maxRank );
  }
  self.pers["rankxp"] = newXp;
}

getRestXPAward( baseXP )
{
  if ( !getdvarint( "scr_restxp_enable" ) )
  {
    return 0;
  }
  restXPAwardRate = getDvarFloat( "scr_restxp_restedAwardScale" );
  wantGiveRestXP = int(baseXP * restXPAwardRate);
  mayGiveRestXP = self getPlayerData( "restXPGoal" ) - self getRankXP();
  if ( mayGiveRestXP <= 0 )
  {
    return 0;
  }
  return wantGiveRestXP;
}

isLastRestXPAward( baseXP )
{
  if ( !getdvarint( "scr_restxp_enable" ) )
  {
    return false;
  }
  restXPAwardRate = getDvarFloat( "scr_restxp_restedAwardScale" );
  wantGiveRestXP = int(baseXP * restXPAwardRate);
  mayGiveRestXP = self getPlayerData( "restXPGoal" ) - self getRankXP();
  if ( mayGiveRestXP <= 0 )
  {
    return false;
  }
  if ( wantGiveRestXP >= mayGiveRestXP )
  {
    return true;
  }
  return false;
}

syncXPStat()
{
  xp = self getRankXP();
  self maps\mp\gametypes\_persistence::statSet( "experience", xp );
}
