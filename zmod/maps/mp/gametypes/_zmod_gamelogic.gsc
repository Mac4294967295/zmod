#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_shop_menu;

doInit()
{
	setDvar("scr_zmod_pregame_time", "15");
	setDvar("scr_zmod_intermission_time", "10");
	setDvar("scr_zmod_starting_time", "10");
	setDvar("scr_zmod_alpha_time", "10");
	setDvar("scr_zmod_sentry_timeout", "200");

	level thread initHUD();
	level thread OnGameEnded();
	level thread doPregame();
	level thread onPlayerConnect();

	//level.ShowCreditShop = false;
	level maps\mp\gametypes\_SpawnPoints::InitializeSpawnPoints();
	level weaponInit();
	level maps\mp\gametypes\_zmod_hud::CreateServerHUD();
	level.infotext setText("Cycle Menu: [{+actionslot 3}]/[{+actionslot 1}]");
	level thread OverRider();
	maps\mp\gametypes\_zmod_gamelogic::CleanupKillstreaks();
	level.mapwait = 0;

	level initializeItemFuncArray();
	level thread maps\mp\gametypes\MapEdit::init();

	setDvar("g_gametype", "war");
	setDvar("ui_gametype", "war");
	setDvar("scr_war_scorelimit", 0);
	setDvar("scr_war_waverespawndelay", 0);
	setDvar("scr_war_playerrespawndelay", 0);

	level thread doGameStarter();
}

onPlayerConnect()
{
  self endon ( "game_ended" );
  for(;;)
  {
    level waittill( "connected", player );

	player.isZombie=0;
    player.credits=0;
	player.spawning = 0;
	player.isAlpha = 0;
	player.bounty = 0;
	player.bonuscash = 0;
    player initializeZMenu();
    player initializeHMenu();
    player initializeCMenu();

    player.doorInRange = 0;
    player.wasAlpha = 0;
    player.wasSurvivor = 0;
    //player.credits = player getCreditsPersistent();
    //player.credits = 50000;
    player iniButtons();
	player maps\mp\gametypes\_zmod_hud::CreatePlayerHUD();
	player thread maps\mp\gametypes\_shop_menu::clearOnDeath();
	player thread maps\mp\gametypes\_zmod_hud::doCash();
	player thread maps\mp\gametypes\_zmod_hud::doHealth();

    //player thread maps\mp\gametypes\_shop_menu::destroyOnDeath();
    player thread maps\mp\gametypes\_spawn::onPlayerSpawned();
    player thread maps\mp\gametypes\_shop_menu::CashFix();
	player thread maps\mp\gametypes\_spawn::monitorPlayerWeapons();
    //player thread onDisconnect();
    player allowSpectateTeam( "allies", true );
    player allowSpectateTeam( "axis", true );
    player allowSpectateTeam( "freelook", true );
    player allowSpectateTeam( "none", true );

	/*
	if(level.gameState == "")
		level waittill( "gamestatechange" );
	*/
	//player monitorSpectator();

	//player closepopupMenu();
	//player closeInGameMenu();

	player thread maps\mp\gametypes\_shop_menu::doShop();

	if( player.spawning == 0 )
		player thread maps\mp\gametypes\_spawn::doSpawn();

    //player thread TestSpawnpoints();
	//player thread CollectSpawnCords();
  }
}

monitorSpectator()
{
	while(1)
	{
		self iprintln("Team: " + self.team);
		if(self.team == "spectator")
		{
			self maps\mp\gametypes\_spawn::doSpawn();
			self iprintln("spawn");
		}
		wait 1;
	}
}

initHUD()
{
    level.TimerText = level createServerFontString( "objective", 1.5 );
    level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );

	level.infotext = NewHudElem();
	level.infotext.alignX = "center";
	level.infotext.alignY = "bottom";
	level.infotext.horzAlign = "center";
	level.infotext.vertAlign = "bottom";
	level.infotext.foreground = true;
	level.infotext.fontScale = 1;
	level.infotext.font = "objective";
	level.infotext.alpha = 1;
	level.infotext.glowAlpha = 1;
	level.infotext.color = ( 1.0, 1.0, 1.0 );
}

OnGameEnded()
{
	level waittill ( "game_ended" );
	waitframe();						//give other "game_ended" notifies time to process

	//destroy zmod player hud elements
	level.TimerText destroy();
	level.infotext destroy();

	foreach(player in level.players)
	{
		player.HintText destroy();
		player.healthtext destroy();
		player.healthlabel destroy();
		player.lifetext destroy();
		player.lifelabel destroy();
		player.menutext destroy();
		player.cash destroy();
		player.cashlabel destroy();
		player.option1 destroy();
		player.option2 destroy();
		player.option3 destroy();
		player.scrollleft destroy();
		player.scrollright destroy();
		player.perkztext1 destroy();
		player.perkztext2 destroy();
		player.perkztext3 destroy();
		player.perkztext4 destroy();
		player.perkztext5 destroy();
		player.DebugHUD destroy();
	}
}

doPregame()
{
	self endon ( "game_ended" );

	level.gameState = "pregame";

	counter = getdvarInt("scr_zmod_pregame_time");
	while(counter > 0)
	{
		level.TimerText setText("Waiting for other players: " + counter);
		setDvar("fx_draw", 1);
		wait 1;

		counter--;
	}
	level.TimerText setText("");
	level notify("gamestatechange");
}

doIntermission()
{
  self endon ( "game_ended" );

  level.gameState = "intermission";
  level notify("gamestatechange");
  level.lastAlive = 0;
  level thread doIntermissionTimer();

  level notify("RESETDOORS");
  level notify("RESETCLUSTER");
  setDvar("cg_drawCrosshair", 1);
  setDvar("cg_drawCrosshairNames", 1);
  setDvar("cg_drawFriendlyNames", 1);

	//level.forcespawn = 1;

	foreach( player in level.players )
	{
		player thread maps\mp\gametypes\_spawn::doSpawn();
		player freezeControls(false);
	}

	//level.forcespawn = 0;

  //dropDead();
  /*
  foreach(player in level.players){
    player.bounty = 0;
    if(player getCItemVal("cash", "in_use")==1)   player.bounty=200;
  }
  */
  //level.ShowCreditShop = true;

  level waittill ( "zmod_intermission_ended" );
  //wait getdvarInt("scr_zmod_intermission_time");
  //level.ShowCreditShop = false;
  level thread doZombieTimer();
  CleanupKillstreaks();
  VisionSetNaked("icbm", 5);
}

doIntermissionTimer()
{
  self endon ( "game_ended" );
  level.counter = getdvarInt("scr_zmod_intermission_time");

  while(level.counter > 0)
  {
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

  level notify( "zmod_intermission_ended" );
}

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

doZombieTimer()
{
  self endon ( "game_ended" );
  setDvar("cg_drawCrosshair", 1);
  level.counter = getdvarInt("scr_zmod_alpha_time");

  while(level.counter > 0){
    level.TimerText setText("^1Alpha Zombie in: " + level.counter);
    wait 1;

    level.counter--;
  }
  level.TimerText setText("");
  level thread maps\mp\gametypes\_spawn::PickZombie();
}

dropDead()
{
  foreach (player in level.players)
  player suicide();
}


doGameStarter()
{
  level waittill ( "gamestatechange" );	//wait for pregame to finish
  level.gameState = "starting";
  level notify("gamestatechange");

  if(level.mapedit_created == 0)	//continue only if mapedit created
  {
	  level waittill("mapedit_created");
  }

  level.lastAlive = 0;
  level thread doStartTimer();
  foreach(player in level.players)
  {
    //	player thread doSetup();
	player freezeControls(false);
	player VisionSetNakedForPlayer(getDvar("mapname"), 0);
    player thread initializeZMenu();
    player thread initializeHMenu();
    player thread initializeCMenu();
    //player thread maps\mp\gametypes\_spawn::doSpawn();
  }
  wait getdvarint("scr_zmod_starting_time");
  level thread doZombieTimer();
  VisionSetNaked("icbm", 5);
}

doStartTimer()
{
  self endon ( "game_ended" );
  level.counter = getdvarint("scr_zmod_starting_time");
  while(level.counter > 0)
  {
    level.TimerText setText("^2Game Starting in: " + level.counter);
    setDvar("fx_draw", 1);
    wait 1;
    level.counter--;
  }
  level.TimerText setText("");
  //first_round_init();
  foreach(player in level.players)
  {
    //player thread doSetup();
  }
}

doPlaying()
{
  self endon ( "game_ended" );
  //wait 5;
  level.TimerText SetText( "" );
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

    if(level.playersLeft["allies"] == 0)
    {
      level thread doEnding();
      return;
    }
	else if( level.playersLeft["axis"] == 0 )
	{
		wait 5;		//Give alpha zombies time to spawn
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();

		if( level.playersLeft["axis"] == 0 )
		{
			level thread doEnding();
			return;
		}
	}

    wait .5;
  }
}

doPlayingTimer()
{
  self endon ( "game_ended" );
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
	self endon ( "game_ended" );

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
		player.moveSpeedScaler = 1;
		player freezeControls(true);
		player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyEnding );
		player.newcomer = 0;
	}
	maps\mp\gametypes\_zmod_gamelogic::CleanupKillstreaks();
	wait 4.5;
	VisionSetNaked(getDvar( "mapname" ), 2);

	level thread maps\mp\gametypes\_zmod_gamelogic::doIntermission();
}

doLastAlive()
{
  self endon("disconnect");
  self endon("death");
  foreach ( primary in self getWeaponsListPrimaries()){
    if(!maps\mp\gametypes\_human_items::isWeaponSpecial(primary)){ //makes sure to not give ammo for "special" weapons
      self GiveMaxAmmo(primary);
    }
  }
  self.grenades=3;
  self _giveWeapon(level.explosives[self getHItemVal("grenade", "in_use")]+"_mp", 1);
  self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
  self maps\mp\perks\_perks::givePerk("specialty_falldamage");
  self thread maps\mp\gametypes\_quickmessages::quickstatements("7");
  self iPrintlnBold("^2You are ^1LAST-ALIVE! ^5SPEED BOOST ^2AND ^5FULL AMMO!");
  self.moveSpeedScaler = 1.17;
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
  if (self.credits - amount > 0)
  self.credits -= amount;
  else
  self.credits = 0;
  self notify("CASH");

  self.cash maps\mp\gametypes\_zmod_hud::doTextPulse("cash", 0.6);
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
  level.explosives[0] = "frag_grenade";
  level.explosives[1] = "semtex";
  level.explosives[2] = "claymore";
  level.explosives[3] = "c4";

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

assistedKill(who)
{
  if (level.gameState != "playing" || who.team == self.team)
  return;
  earn = 0;
  if (self.team == "allies"){
  	earn = 25;
		self.HAssist++;
	}else if (self.team == "axis"){
		self.ZAssist++;
  	earn = 50;
	}
  self maps\mp\gametypes\_zmod_hud::justScorePopup("Assist: +$" + earn);
  self statCashAdd(earn);
}
killedPlayer(who, weap)
{
	if (self.team == who.team || level.gameState != "playing")
		return;
	if (self.team == who.team)
		return;
	//processChallengeKill(self, who, weap);
	if (self.isZombie != 0)
	{
		amount = 100 + (50 * self.combo);

		self statCashAdd(amount);
		self.combo++;
		if (self.combo > 1)
			self thread maps\mp\gametypes\_zmod_hud::justScorePopup("Kill Combo! x" + self.combo + " +$" + amount);
		else
			self thread maps\mp\gametypes\_zmod_hud::justScorePopup("Killed Human! +$" + amount);
		self notify("CASH");
	}
	else
	{
		who statCashAdd(50);
		who maps\mp\gametypes\_zmod_hud::justScorePopup("Died! +$50");

		earn = 50;
		if (weap == "melee_mp")
		{
			earn *= 4;
			self thread maps\mp\gametypes\_zmod_hud::justScorePopup("Melee Kill! +$" + earn);
		}
		else
			self thread maps\mp\gametypes\_zmod_hud::justScorePopup("Killed Zombie! +$" + earn);
		self statCashAdd(earn);
	}
}
