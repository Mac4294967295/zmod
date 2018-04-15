#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;

doSpawn(){
  //self iPrintLnBold(level.gamestate+" "+self getCItemVal("life", "in_use")+" "+self.isZombie);
  //wait 2;
//  self iPrintlnBold("dospawn");
  //self notify("death");
  self.menu=0;
  //self.hasAnaconda=false; //is true when player had the .44 Magnum  before he bought better devils
  self.grenades=3;
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
	  
	  if(self.team!="axis")
	  {
		if(self.sessionstate == "playing")
		{	
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		
		self maps\mp\gametypes\_menus::addToTeam( "axis" );
		
		class = self maps\mp\gametypes\_class::getClassChoice( "class3" );
		primary = self maps\mp\gametypes\_class::getWeaponChoice( "class3" );		
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;	
		
		self notify("end_respawn");
		
		self.bounty=0;
		return;
	  }
	  
	  /*
      if(self.team!="axis"){
        self notify("menuresponse", game["menu_team"], "axis");
  		  wait .1;
  		  self notify("menuresponse", "changeclass", "class3");
        self.bounty=0;
        return;
      }
	  */	  
      self doZombieSetup();
    }
  }else{
    self.isZombie=0;
	
	if (self.team == "axis" || self.team == "spectator")
	{
		if(self.sessionstate == "playing")
		{	
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		
		self maps\mp\gametypes\_menus::addToTeam( "allies" );
		
		class = self maps\mp\gametypes\_class::getClassChoice( "class0" );
		primary = self maps\mp\gametypes\_class::getWeaponChoice( "class0" );		
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;	
		
		self notify("end_respawn");
		return;
	}
	
	/*
    if (self.team == "axis" || self.team == "spectator"){
      self notify("menuresponse", game["menu_team"], "allies");
      wait .1;
      self notify("menuresponse", "changeclass", "class0");
      return;
    }
	*/
	
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
  self thread maps\mp\gametypes\_zmod_hud::doCash();
  self thread maps\mp\gametypes\_zmod_hud::doHealth();
  //self thread maps\mp\gametypes\_rank::doLives();
  self.combo = 0;
  self statCashAdd(5000);
	if(level.gamestate == "starting")
	{
		self thread OMAExploitFix();
	}

}

doHumanSetup(){
  self thread maps\mp\gametypes\_zmod_hud::doLives();
  self _clearPerks();
  self setHItemVal("recoilcontrol", "text1", "Upgrade Recoil Control (0/3) - ");
  self _unsetperk("specialty_bulletaccuracy");
  self SetClientDvar("perk_weapSpreadMultiplier", "1");
  //self player_recoilScaleOn(1);
  self _unsetperk("specialty_holdbreath");
  self _unsetperk("specialty_fastreload");
  self _unsetperk("specialty_quickdraw");
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
  self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
  self.moveSpeedScaler = 1.07;
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
  self resetHMenu();
	//self maps\mp\perks\_perks::givePerk("specialty_automantle");
	//self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	//self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
	//self maps\mp\perks\_perks::givePerk("specialty_quieter");
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
	//self giveWeapon(level.shot[self.randomshot] + "_mp", 0, false);
//	self giveWeapon(level.hand[self.randomhand] + "_mp", 0, false);
	self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
//	self GiveMaxAmmo(level.shot[self.randomshot] + "_mp");
//	self GiveMaxAmmo(level.hand[self.randomhand] + "_mp");
  self SetOffhandPrimaryClass( "frag" );
  self _giveWeapon("frag_grenade_mp", 1);
  self thread monitorGrenades();
  wait .5;
	self switchToWeapon(level.smg[self.randomsmg] + "_mp");

}

doZombieSetup(){
  self _clearPerks();
  SetDvar("player_sprintUnlimited", 1);
	//self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
  self.moveSpeedScaler = 1.07;
  self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
  self SetOffhandPrimaryClass("");
  self setWeaponAmmoClip("frag_grenade_mp", 0);
  self setWeaponAmmoStock("frag_grenade_mp", 0);
  self takeAllWeapons();
	self giveWeapon("usp_tactical_mp", 0, false);
  self setWeaponAmmoClip("usp_tactical_mp", 0);
  self setWeaponAmmoStock("usp_tactical_mp", 0);
  wait .2;
  self switchToWeapon("usp_tactical_mp");
	self maps\mp\gametypes\_zombie_items::giveZUpgrades();
}

pickZombie(){
  self endon ( "game_ended" );
  noPlayers=false;
  while(level.players.size==0){
    wait 4;
    noPlayers=true;
  }
  if(noPlayers) wait 10;
  numberOfZombies=int(level.players.size/6)+1;
  for(i=0;i<numberOfZombies;i++){
    while(1){
      rnd = randomInt(level.players.size);
      if(!isDefined(level.players[rnd])) return;
      randPlayer = level.players[rnd];
      if( randPlayer getCItemVal("antialpha", "in_use")==0){
        break;
      }else{
        randPlayer setCItemVal("antialpha", "in_use", 0);
        randPlayer iPrintlnBold("^2Anti-Alpha used!");
      }
    }
	
	if(self.sessionstate == "playing")
	{	
		self.switching_teams = true;
		self.joining_team = "axis";
		self.leaving_team = self.pers["team"];
		self suicide();
	}
		
	self maps\mp\gametypes\_menus::addToTeam( "axis" );
	
	class = self maps\mp\gametypes\_class::getClassChoice( "class3" );
	primary = self maps\mp\gametypes\_class::getWeaponChoice( "class3" );		
	self.pers["class"] = class;
	self.class = class;
	self.pers["primary"] = primary;	
	
	self notify("end_respawn");		
	
	/*
    randPlayer notify("menuresponse", game["menu_team"], "axis");
    wait .1;
    randPlayer notify("menuresponse", "changeclass", "class3");
	*/
	
    randPlayer.isZombie=1;
    level.gameState = "playing";
    level notify("gamestatechange");
  }
  level.gameState = "playing";
  level notify("gamestatechange");
  level thread maps\mp\gametypes\_zmod_gamelogic::doPlaying();
  level thread maps\mp\gametypes\_zmod_gamelogic::doPlayingTimer();
  level thread maps\mp\gametypes\_zmod_gamelogic::inGameConstants();
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

		if( level.gameState == "pregame" )
		{
			self freezeControls(true);
			self VisionSetNakedForPlayer("mpIntro", 0);
		}
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

monitorGrenades(){
  self endon("disconnect");
  self endon("death");
  while(self.isZombie==0){
    if(self.c4array.size==0){
      if(self.grenades>0 ){
        if(self getWeaponAmmoStock(level.explosives[self  getHItemVal("grenade", "in_use")]+"_mp")==0){
          self.grenades--;
          self setWeaponAmmoStock(level.explosives[self  getHItemVal("grenade", "in_use")]+"_mp", 1);
        }
      }
    wait .2;
    }
    wait .2;
  }
}

forceSpawn(){
  self endon("spawned_player");
  //wait 4;
  self notify("spawned_player");
}
