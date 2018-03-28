#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_shop_menu;


doIntermission()
{
  level.gameState = "intermission";
  level notify("gamestatechange");
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

dropDead()
{
  foreach (player in level.players)
  player suicide();
}


doGameStarter()
{

  level.gameState = "starting";
  level notify("gamestatechange");
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
  //first_round_init();
  foreach(player in level.players)
  {
    //player thread doSetup();
  }
}

doPlaying()
{
  wait 5;
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
  maps\mp\gametypes\_gamestate_logic::CleanupKillstreaks();
  wait 4.5;
  VisionSetNaked(getDvar( "mapname" ), 2);

  foreach(player in level.players)
  {
    player freezeControls(false);
  }
  level thread maps\mp\gametypes\_gamestate_logic::doIntermission();
}

doLastAlive()
{
  self endon("disconnect");
  self endon("death");
  wait 2;
  self GiveMaxAmmo(self getCurrentWeapon());
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
