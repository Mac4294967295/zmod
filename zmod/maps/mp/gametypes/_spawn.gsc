#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;

doSpawn(){
  //self iPrintLnBold(level.gamestate+" "+self getCItemVal("life", "in_use")+" "+self.isZombie);
  //wait 2;
//  self iPrintlnBold("dospawn");
  //self notify("death");
  self.menu=0;
  self.isRepairing=false;
  //self iPrintLnBold(self.team);
  if(level.gameState=="playing" || level.gameState=="ending"){
    if(self getCItemVal("life", "in_use")>0 && self.isZombie==0){
      self setCItemVal("life", "in_use", self getCItemVal("life", "in_use")-1);
    //  self.team="allies";
    //  self notify("menuresponse", game["menu_team"], "allies");
    //  wait .1;
    //  self notify("menuresponse", "changeclass", "class1");
      self doHumanSetup();
      self maps\mp\gametypes\_credit_items::giveCreditUpgrades();
    }else{
      //self.team="axis";
      self.isZombie=1;
      if(self.team!="axis"){
        self notify("menuresponse", game["menu_team"], "axis");
  		  wait .1;
  		  self notify("menuresponse", "changeclass", "class1");
        return;
      }
      self doZombieSetup();
    }
  }else{
    self.isZombie=0;
    if (self.team == "axis" || self.team == "spectator"){
      self notify("menuresponse", game["menu_team"], "allies");
      wait .1;
      self notify("menuresponse", "changeclass", "class1");
      return;
    }
    //self.team="allies";
  //  self notify("menuresponse", game["menu_team"], "allies");
  //  wait .1;
    //self notify("menuresponse", "changeclass", "class1");
    self doHumanSetup();
    self maps\mp\gametypes\_credit_items::giveCreditUpgrades();
  }
  self thread maps\mp\gametypes\_shop_menu::CreatePlayerHUD();
  maps\mp\gametypes\_shop_menu::doShop();
  self thread maps\mp\gametypes\_shop_menu::monitorShop();
  //self thread maps\mp\gametypes\_shop_menu::doMenuScroll();
  self thread maps\mp\gametypes\_rank::doCash();
  self thread maps\mp\gametypes\_rank::doHealth();
  //self thread maps\mp\gametypes\_rank::doLives();
  self.combo = 0;
  self statCashAdd(5000);
	if(level.gamestate == "starting")
	{
		self thread OMAExploitFix();
	}

}

doHumanSetup(){
  self thread maps\mp\gametypes\_rank::doLives();
  self iPrintLnBold("humasteup");
  self _clearPerks();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
	self maps\mp\perks\_perks::givePerk("specialty_quieter");
  self.maxhealth = 100;
  self.randomlmg = randomInt(level.lmg.size);
	self.randomar = randomInt(level.assault.size);
	self.randommp = randomInt(level.machine.size);
	self.randomsmg = randomInt(level.smg.size);
	self.randomsr = randomInt(level.rifle.size);
	self.randomshot = randomInt(level.shot.size);
	self.randomhand = randomInt(level.hand.size);
  self takeAllWeapons();
	self giveWeapon(level.smg[self.randomsmg] + "_mp", 0, false);
	self giveWeapon(level.shot[self.randomshot] + "_mp", 0, false);
	self giveWeapon(level.hand[self.randomhand] + "_mp", 0, false);
	self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
	self GiveMaxAmmo(level.shot[self.randomshot] + "_mp");
	self GiveMaxAmmo(level.hand[self.randomhand] + "_mp");
  wait 0.2;
	self switchToWeapon(level.smg[self.randomsmg] + "_mp");
  //self thread doHW();

}

doZombieSetup(){
  self _clearPerks();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
  self takeAllWeapons();
	self giveWeapon("usp_tactical_mp", 0, false);
  self setWeaponAmmoClip("usp_tactical_mp", 0);
  self setWeaponAmmoStock("usp_tactical_mp", 0);
  wait .2;
  self switchToWeapon("usp_tactical_mp");
	self maps\mp\gametypes\_zombie_items::giveZUpgrades();
}

pickZombie()
{
	doPlaceTimerText();
/*
	times = 3;
	if (getDvarInt("scr_zmod_alpha_count") != 0)
		times = getDvarInt("scr_zmod_alpha_count");
	if (getDvarInt("scr_zmod_autoadjust") == 1)
	{
		if (level.players.size < 6)
			times = 2;
		if (level.players.size < 3)
			times = 1;
	}
	if (times >= level.players.size)
			times = level.players.size - 1;
	//If theres only one person, make sure they go zombie all the time
	if (times <= 0)
			times = 1;
	while (times > 0)
	{
		p = chooseZombie();
		if (p == -1)
			break;
		level.players[p].isZombie = 2;
		level.players[p] thread doAlphaZombie();
		times--;
	}
	level.TimerText setText("^1Alpha Zombies RELEASED!");

	level playSoundOnPlayers("mp_defeat");

*/
  randPlayer = level.players[randomInt(level.players.size)];
	randPlayer notify("menuresponse", game["menu_team"], "axis");
	wait .1;
	randPlayer notify("menuresponse", "changeclass", "class3");
  randPlayer.isZombie=1;
	level.gameState = "playing";
	level notify("gamestatechange");
	level thread doPlaying();
	level thread doPlayingTimer();
	level thread inGameConstants();
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
    //self notify("death");
    if(!(self getCItemVal("life", "in_use")>0 && self.isZombie==0)) //if is respawing due to lives dont respawn at default spawn but at random or tac insertion
      self maps\mp\gametypes\_SpawnPoints::SpawnPlayer();
    self thread maps\mp\gametypes\_spawn::doSpawn();
	}
}
/*
doJoinTeam()
{
//	if(self.CONNECT == 1)
	//	{
			notifyHello = spawnstruct();
			notifyHello.titleText = "Welcome to the [UD]Ultimate Zombie Server";
			notifyHello.notifyText = "Please read rules at bottom!";
			notifyHello.notifyText2 = "Modified by Chaz & [UD]Funky ";
			notifyHello.glowColor = (0.0, 0.6, 0.3);
			if(level.gameState == "intermission" || level.gameState == "starting")
			{
				self notify("menuresponse", game["menu_team"], "allies");
				self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyHello );
			}
			if(level.gameState == "playing" || level.gameState == "ending"){
			self notify("menuresponse", game["menu_team"], "allies");
			}
//		self.CONNECT = 0;
	//	}
}
*/
/*
onJoinedTeam()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill( "joined_team" );
    //self iPrintlnBold("onJoinedTeam");
		self thread removeRankHUD();
		self thread doJoinTeam();
	}
}
*/
/*
onJoinedSpectators()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill( "joined_spectators" );
		self thread removeRankHUD();
	}
}
*/
